module Bench.Pos.Wallet.Run
    ( runBench
    ) where

import           Universum

import           Gauge.Main             (bench, defaultMainWith, nfIO)
import           Gauge.Main.Options     (Config (..), defaultConfig)
import           System.Random          (randomRIO)
import           Control.Concurrent     (threadDelay)

import           Bench.Pos.Wallet.Types (AdditionalBenchConfig (..), EndpointClient)

-- |
runBench :: EndpointClient -> AdditionalBenchConfig -> IO ()
runBench endpointClient (AdditionalBenchConfig {..}) =
    defaultMainWith config [bench benchName $ nfIO (endpointClient >> wait (minDelayForCalls, maxDelayForCalls))]
  where
    config = defaultConfig {
        timeLimit  = Just benchDuration,
        reportFile = Just pathToReportFile
    }

-- | Waiting some random delay.
-- Values of @from@ and @to@ are already checked:
-- both are positive and @to@ is greater than @from@.
wait :: (Double, Double) -> IO ()
wait (from, to) =
    randomRIO (fromInMicrosec, toInMicrosec) >>= threadDelay
  where
    fromInMicrosec, toInMicrosec :: Int
    fromInMicrosec = truncate $ from * asMicrosec
    toInMicrosec   = truncate $ to * asMicrosec
    asMicrosec = 1000000
