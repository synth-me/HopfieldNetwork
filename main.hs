import System.Environment
import Data.List.Split 
import Data.List
-- entropy.hs 
-- here we divide the string into list
divide :: [[Char]] -> [[String]]
divide m = map(\x-> splitOn "," x) m 

-- here we get the probabilities of equality between the two vectors 
getProb :: (Real a, Fractional b) => [a] -> b 
getProb xs = (realToFrac (sum xs) / genericLength xs)*100

-- here we convert the command from string to integer 
parseCommand :: Num b => [[Char]] -> [[b]]
parseCommand p0 = map(\x -> map(\y -> case y of
				          "1" -> 1
				          "0" -> 0 ) x ) (divide p0)

-- here we make the binary comparison 
compareBinary :: Integer -> Integer -> Integer
compareBinary n0 n1 = case n0 == n1 of
                                True -> 1 
                                False -> 0 

-- here we compare the two vectors in function 
compareVectors :: [Integer] -> [Integer] -> [Integer] 
compareVectors v0 v1 = zipWith (\x y -> compareBinary x y) v0 v1 

compareCompact :: [[Integer]] -> [Integer]
compareCompact q = zipWith (\x y -> compareBinary x y) (head q) (last q)

main :: IO()
main = do
    args <- getArgs 
-- here we get the command line arguments 
    let p1 = (floor.getProb.compareCompact.parseCommand) args 
    print p1
    