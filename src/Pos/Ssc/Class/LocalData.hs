{-# LANGUAGE AllowAmbiguousTypes    #-}
{-# LANGUAGE DefaultSignatures      #-}
{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE RankNTypes             #-}
{-# LANGUAGE ScopedTypeVariables    #-}
{-# LANGUAGE TypeFamilies           #-}
{-# LANGUAGE UndecidableInstances   #-}

-- | This module defines type class for local data storage.

module Pos.Ssc.Class.LocalData
       (
         -- * Modern
         LocalQueryM
       , LocalUpdateM
       , SscLocalDataClassM (..)

         -- * Old
       , HasSscLocalData (..)
       , LocalQuery
       , LocalUpdate
       , MonadSscLD (..)
       , SscLocalDataClass (..)
       , sscRunLocalQuery
       , sscRunLocalUpdate
       , sscGetLocalPayload
       , sscApplyGlobalState
       ) where

import           Control.Lens        (Lens')
import           Control.Monad.Trans (MonadTrans)
import           Universum

import           Pos.DHT.Model       (DHTResponseT)
import           Pos.DHT.Real        (KademliaDHT)
import           Pos.Ssc.Class.Types (Ssc (..))
import           Pos.Types.Types     (SlotId)

----------------------------------------------------------------------------
-- Modern
----------------------------------------------------------------------------

type LocalQueryM ssc a = forall m . (MonadReader (SscLocalDataM ssc) m) => m a
type LocalUpdateM ssc a = forall m .(MonadState (SscLocalDataM ssc) m) => m a

-- | This type class abstracts local data used for SSC. Local means
-- that it is not stored in blocks.
class Ssc ssc => SscLocalDataClassM ssc where
    -- | Empty local data which is created on start.
    sscEmptyLocalDataM :: SscLocalDataM ssc
    -- | Get local payload to be put into main block corresponding to
    -- given SlotId.
    sscGetLocalPayloadMQ :: SlotId -> LocalQueryM ssc (SscPayload ssc)
    -- | Update LocalData using global data from blocks (last version
    -- of best known chain).
    sscApplyGlobalStateMU :: SscGlobalStateM ssc -> LocalUpdateM ssc ()

----------------------------------------------------------------------------
-- LEGACY
----------------------------------------------------------------------------

type LocalQuery ssc a = forall m . ( HasSscLocalData ssc (SscLocalData ssc)
                                   , MonadReader (SscLocalData ssc) m
                                   ) => m a
type LocalUpdate ssc a = forall m . ( HasSscLocalData ssc (SscLocalData ssc)
                                    , MonadState (SscLocalData ssc) m
                                    ) => m a

-- | Type class which allows usage of classy pattern.
class HasSscLocalData ssc a where
    sscLocalData :: Lens' a (SscLocalData ssc)

instance (SscLocalData ssc ~ a) => HasSscLocalData ssc a where
    sscLocalData = identity

-- | Monad which has read-write access to LocalData.
class Monad m => MonadSscLD ssc m | m -> ssc where
    getLocalData :: m (SscLocalData ssc)
    setLocalData :: SscLocalData ssc -> m ()

    default getLocalData :: MonadTrans t => t m (SscLocalData ssc)
    getLocalData = lift getLocalData

    default setLocalData :: MonadTrans t => SscLocalData ssc -> t m ()
    setLocalData = lift . setLocalData

instance (Monad m, MonadSscLD ssc m) => MonadSscLD ssc (ReaderT x m)
instance (Monad m, MonadSscLD ssc m) => MonadSscLD ssc (DHTResponseT s m)
instance (MonadSscLD ssc m, Monad m) => MonadSscLD ssc (KademliaDHT m)

-- | This type class abstracts local data used for SSC. Local means
-- that it is not stored in blocks.
class Ssc ssc => SscLocalDataClass ssc where
    -- | Empty local data which is created on start.
    sscEmptyLocalData :: SscLocalData ssc
    -- | Get local payload to be put into main block corresponding to
    -- given SlotId.
    sscGetLocalPayloadQ :: SlotId -> LocalQuery ssc (SscPayload ssc)
    -- | Update LocalData using global data from blocks (last version
    -- of best known chain).
    sscApplyGlobalStateU :: SscGlobalState ssc -> LocalUpdate ssc ()

----------------------------------------------------------------------------
-- Helpers for transform from MonadSscLD to Reader/State monad and back
----------------------------------------------------------------------------

-- | Convenient wrapper to run LocalQuery in MonadSscLD.
sscRunLocalQuery
    :: forall ssc m a.
       MonadSscLD ssc m
    => Reader (SscLocalData ssc) a -> m a
sscRunLocalQuery query = runReader query <$> getLocalData @ssc

-- | Convenient wrapper to run LocalUpdate in MonadSscLD.
sscRunLocalUpdate
    :: MonadSscLD ssc m
    => State (SscLocalData ssc) a -> m a
sscRunLocalUpdate upd = do
    (res, newLocalData) <- runState upd <$> getLocalData
    res <$ setLocalData newLocalData
----------------------------------------------------------------------------
-- Methods for using in MonadSscLD
----------------------------------------------------------------------------
sscGetLocalPayload
    :: forall ssc m.
       (MonadSscLD ssc m, SscLocalDataClass ssc)
    => SlotId -> m (SscPayload ssc)
sscGetLocalPayload = sscRunLocalQuery . sscGetLocalPayloadQ @ssc

sscApplyGlobalState
    :: forall ssc m.
       (MonadSscLD ssc m, SscLocalDataClass ssc)
    =>  SscGlobalState ssc -> m ()
sscApplyGlobalState = sscRunLocalUpdate . sscApplyGlobalStateU @ssc
