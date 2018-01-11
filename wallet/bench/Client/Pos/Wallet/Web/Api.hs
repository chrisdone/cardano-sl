{-# LANGUAGE TypeFamilies #-}

module Client.Pos.Wallet.Web.Api
    ( getHistory
    ) where

import           Universum

import           Pos.Wallet.Web.Api         (GetHistory) -- , GetWallet, NewPayment)
import           Pos.Wallet.Web.ClientTypes (AccountId (..), CAccountId (..),
                                             Addr, CId (..), CTx, ScrollLimit,
                                             ScrollOffset, Wal)
import           Pos.Util.Servant           (VerbMod)
import           Servant.Client             (ClientM, Client, HasClient (..), client)



-- instance HasClient GetHistory

--instance HasClient (GetHistory) where
--    type Client (GetHistory) = Client GetHistory
--    clientWithRoute _ = clientWithRoute (Proxy @GetHistory)

--newPayment :: Int -- ^ value for "x"
--           -> Int -- ^ value for "y"
--           -> ClientM Position

--type NewPayment =
--       "txs"
--    :> "payments"
--    :> DCQueryParam "passphrase" CPassPhrase
--    :> CCapture "from" CAccountId
--    :> Capture "to" (CId Addr)
--    :> Capture "amount" Coin
--    :> DReqBody '[JSON] (Maybe InputSelectionPolicy)
--    :> WRes Post CTx

--newPayment
--    :: Send
--    Actions ClientM
--    -> PassPhrase
--    -> AccountId
--    -> CId Addr
--    -> Coin
--    -> InputSelectionPolicy
--    -> ClientM CTx
--newPayment _ _ _ _ _ _ = error ""

--getHistoryEndpoint :: Proxy GetHistory
--getHistoryEndpoint = Proxy

--getHistory
--    :: Maybe (CId Wal)
--    -> Maybe CAccountId
--    -> Maybe (CId Addr)
--    -> Maybe ScrollOffset
--    -> Maybe ScrollLimit
--    -> ClientM ([CTx], Word)
getHistory = client (Proxy @GetHistory)


-- client :: HasClient api => Proxy api -> Client api
















{-
    • Couldn't match type ‘Client
                             (Pos.Util.Servant.CQueryParam
                                "accountId" Pos.Wallet.Web.ClientTypes.Types.CAccountId
                              Servant.API.Sub.:> (Servant.API.QueryParam.QueryParam
                                                    "address" (CId Addr)
                                                  Servant.API.Sub.:> (Servant.API.QueryParam.QueryParam
                                                                        "skip" ScrollOffset
                                                                      Servant.API.Sub.:> (Servant.API.QueryParam.QueryParam
                                                                                            "limit" ScrollLimit
                                                                                          Servant.API.Sub.:> Pos.Wallet.Web.Api.WRes
                                                                                                               Servant.API.Verbs.Get
                                                                                                               ([CTx],
                                                                                                                Word)
                                                                                         )
                                                                     )
                                                 )
                             )’




                        with ‘Maybe AccountId
                           -> Maybe (CId Addr)
                           -> Maybe ScrollOffset
                           -> Maybe ScrollLimit
                           -> ClientM ([CTx], Word)’


      Expected type: Maybe (CId Wal)
                     -> Maybe AccountId
                     -> Maybe (CId Addr)
                     -> Maybe ScrollOffset
                     -> Maybe ScrollLimit
                     -> ClientM ([CTx], Word)
        Actual type: Client GetHistory


-}

--type GetHistory =
--       "txs"
--    :> "histories"
--    :> QueryParam "walletId" (CId Wal)
--    :> CQueryParam "accountId" CAccountId
--    :> QueryParam "address" (CId Addr)
--    :> QueryParam "skip" ScrollOffset
--    :> QueryParam "limit" ScrollLimit
--    :> WRes Get ([CTx], Word)



--type MyApi = "books" :> Get '[JSON] [Book] -- GET /books
--        :<|> "books" :> ReqBody '[JSON] Book :> Post '[JSON] Book -- POST /books

--myApi :: Proxy MyApi
--myApi = Proxy

--getAllBooks :: ClientM [Book]
--postNewBook :: Book -> ClientM Book
--(getAllBooks :<|> postNewBook) = client myApi


--getWallet :: ClientInfo -- ^ value for the request body
--          -> ClientM Email

--type GetWallet =
--       "wallets"
--    :> Capture "walletId" (CId Wal)
--    :> WRes Get CWallet



-- position :<|> hello :<|> marketing = client walletApi