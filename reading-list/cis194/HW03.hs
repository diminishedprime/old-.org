-- Exercise 1
-- p stands for partition
-- q stands for partition by
-- d stands for decrement
-- b stands for by
-- y is 

import Data.List
import Data.Ord

skips a = map (p a) [0 .. length a - 1]
p y b = q y b
  where q [] _ = []
        q (x:y) 0 = [x] ++ q y b
        q (x:y) z = q y $ z - 1

-- Exercise 2

-- f is a helper function that's shorter for recursion.
-- tail is a safe operation here since if it matches, a tail exists.
-- If a is less than b, and b is greater than c, then it is a local maximum.
localMaxima :: [Integer] -> [Integer]
localMaxima a = f a
  where f z@(a:b:c:y) = if a < b && b > c
                        then [b] ++ f (tail z)
                        else f (tail z)
        f _ = []

-- Exercise 3
-- g adds 1 through 9 to the list, and then sorts and groups it
-- r takes a list of Integer and turns it into the horizontal equivalent
-- l is a fn that returns the longest string from a list of strings
-- p is a fn that pads a string a with spaces, to be b chars long.
histogram :: [Integer] -> String
histogram b = let q = map r $ g b
                  l = maximumBy (comparing length) q
                  p b a = if length a < b
                          then p b (a ++ " ")
                          else a
              in unlines $ reverse $ transpose $ map (p (length l)) q 
g :: [Integer] -> [[Integer]]
g a = group . sort $ [1..9] ++ a
r :: [Integer] -> String
r z@(a:y) = (show a) ++ "=" ++ map (\_-> '*') y


