f :: (a -> b) -> b -> [a] -> b
f = undefined
g :: (c -> Bool) -> a -> [c] -> [c]
g = undefined
-- h :: (c -> Bool) -> a -> [c] -> [c]
-- h = f

foo a b = let c = \a -> b ++ a in
            let b = a ++ (c a) in 
              c (bar b)
  where bar e = e ++ a ++ b

main = putStrLn $ foo "x" "o"
