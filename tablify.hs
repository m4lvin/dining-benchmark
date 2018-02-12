#!/usr/bin/env stack
-- stack --resolver lts-10.5 script --package directory,split

module Main where
import Data.List.Split
import Data.Maybe
import System.Directory

type ResultTable = [((String,Int),String)] -- list of ((checker,number),result)s

numberRange :: [Int]
numberRange = [3, 4, 5, 10, 15, 20, 30, 40, 50, 60, 70, 80]

checkers :: [String]
checkers = ["old.mck", "old.mctk", "old.mcmas", "mck", "mctk", "mcmas", "smcdel", "smcdel.alt"]

lookupResult :: ResultTable -> (String,Int) -> String
lookupResult t cn = longifyTo 6 $ fromMaybe "  --- " (lookup cn t)

main :: IO ()
main = do
  resultFiles <- filter (`notElem` [".",".."]) <$> getDirectoryContents "./results/"
  results <- mapM (\fileName -> do
    fileContent <- readFile ("./results/" ++ fileName)
    let [checker,number] = splitOn "-" fileName
    let result = init fileContent
    return ((checker,read number),result)
    ) resultFiles
  putStrLn "$n$ & MCK     & MCTK     & MCMAS    &  MCK     & MCTK     & MCMAS    & (single) & (separate) \\\\"
  mapM_ (\number -> do
    putStr $ longifyTo 3 (show number) ++ " & "
    mapM_ (\checker ->
        putStr $ lookupResult (oldResults ++ results) (checker,number) ++ "  &  "
      ) checkers
    putStrLn "\\\\"
    ) numberRange

longifyTo :: Int -> String -> String
longifyTo n s = replicate (n - length s) ' ' ++ s

-- | old results from https://doi.org/10.1007/s10009-015-0378-x for comparison
oldResults :: ResultTable
oldResults =
  [ (("old.mck"  , 5),"   1.4")
  , (("old.mck"  ,10),"  74.7")
  , (("old.mck"  ,20)," 47937")
  , (("old.mck"  ,30),"  t/o ")
  , (("old.mck"  ,40),"  t/o ")
  , (("old.mck"  ,50),"  t/o ")
  , (("old.mck"  ,60),"  t/o ")
  --
  , (("old.mctk" , 5)," 0.024")
  , (("old.mctk" ,10)," 0.128")
  , (("old.mctk" ,15),"  --- ")
  , (("old.mctk" ,20),"34.790")
  , (("old.mctk" ,30)," 2.946")
  , (("old.mctk" ,40),"20.786")
  , (("old.mctk" ,50),"72.444")
  , (("old.mctk" ,60),"  t/o ")
  --
  , (("old.mcmas", 3),"  --- ")
  , (("old.mcmas", 4),"  --- ")
  , (("old.mcmas", 5)," 0.017")
  , (("old.mcmas",10)," 0.091")
  , (("old.mcmas",15),"  --- ")
  , (("old.mcmas",20)," 0.667")
  , (("old.mcmas",30)," 1.476")
  , (("old.mcmas",40)," 5.053")
  , (("old.mcmas",50),"13.437")
  , (("old.mcmas",60),"14.180")
  , (("old.mcmas",70),"  --- ")
  , (("old.mcmas",80),"  --- ")
  ]
