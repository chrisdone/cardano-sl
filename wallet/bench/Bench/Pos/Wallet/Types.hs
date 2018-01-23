module Bench.Pos.Wallet.Types
    ( AdditionalBenchConfig (..)
    , BenchEndpoint (..)
    , EndpointClient
    ) where

import           Universum

-- | Additional benchmark configuration, obtained from the file.
data AdditionalBenchConfig = AdditionalBenchConfig
    { -- | Name of the benchmark, used in the report file.
      benchName        :: !String
      -- | Duration of benchmark, in seconds.
    , benchDuration    :: !Double
      -- | Minimal value for the random delay generation, in seconds.
      -- This delay will be used as a pause between calls of a client.
    , minDelayForCalls :: !Double
      -- | Maximal value for the random delay generation, in seconds.
      -- This delay will be used as a pause between calls of a client.
    , maxDelayForCalls :: !Double
      -- | Path to report HTML-file (if doesn't exist, it will be created).
    , pathToReportFile :: !FilePath
    }

-- | Clarification which benchmark we want to use.
data BenchEndpoint
    = GetHistoryBench
    | GetWalletsBench
    | NewPaymentBench
    deriving (Show)

-- | Type synonym for client function: this function sends
-- requests to particular endpoint of the Wallet Web API.
type EndpointClient = IO ()
