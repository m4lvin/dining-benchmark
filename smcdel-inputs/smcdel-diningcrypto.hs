module Main where

import Data.List
import SMCDEL.Language
import SMCDEL.Symbolic.S5
import System.Environment (getArgs)

-- initial structure for the dining cryptographers, ring topology!
knsInit :: Int -> KnowStruct
knsInit n = KnS props law obs where
  props = [ P 0 ] -- The NSA paid
    ++ [ (P 1) .. (P n) ] -- agent i paid
    ++ sharedbits
  law = boolBddOf $ Conj [someonePaid, noTwoPaid] where
    someonePaid = Disj (map (PrpF . P) [0..n])
    noTwoPaid   = Conj [ Neg $ Conj [ PrpF $ P x, PrpF $ P y ]
                       | x <- [0..n], y <- [(x+1)..n] ]
  obs = [ (show i, obsfor i) | i<-[1..n] ]
  sharedbitLabels = [1,n] : [ [k,k+1] | k <- [1..n], k < n ] -- 2n shared bits
  sharedbitRel = zip sharedbitLabels [ (P $ n+1) .. ]
  sharedbits =  map snd sharedbitRel
  obsfor i =  P i : map snd (filter (\(label,_) -> i `elem` label) sharedbitRel)

reveal :: Int -> Int -> Form
reveal n i = Xor (map PrpF ps) where
  (KnS _ _ obs) = knsInit n
  (Just ps)     = lookup (show i) obs

data Variant = Single | Separate deriving (Show,Read)

checkForm :: Variant -> Int -> Form
checkForm var n = announcePrefix goal where
  announcePrefix = case var of
    Single   -> PubAnnounceW (Xor [reveal n i | i<-[1..n] ])
    Separate -> pubAnnounceWhetherStack [ reveal n i | i<-[1..n] ]
  goal =
    Impl (Neg (PrpF $ P 1)) $
      Disj [ K "1" (Conj [Neg $ PrpF $ P k | k <- [1..n]  ])
           , Conj [ K "1" (Disj [ PrpF $ P k | k <- [2..n] ])
                  , Conj [ Neg $ K "1" (PrpF $ P k) | k <- [2..n] ] ] ]

main :: IO ()
main = do
  args <- getArgs
  (n,var) <- case args of
    [aInteger,aString] -> do
      let k = read aInteger :: Int
      let var = if aString == "--separate" then Separate else Single
      return (k,var)
    [aInteger] -> do
      let k = read aInteger :: Int
      return (k,Single)
    _ ->
      return (3,Single)
  putStrLn $ "Number of agents: " ++ show n
  putStrLn $ "Variant: " ++ show var
  print $ validViaBdd (knsInit n) (checkForm var n)
