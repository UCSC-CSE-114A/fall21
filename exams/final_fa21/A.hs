import Data.List
-- f :: (a -> b) -> b -> [a] -> b
-- f = undefined
-- g :: (c -> Bool) -> a -> [c] -> [c]
-- g = undefined
-- h :: (c -> Bool) -> a -> [c] -> [c]
-- h = f

data Gift = Clothes Size Color
          | Toy String
          | Cash Int
          | Cookies Flavor
  deriving (Show, Eq)

data Size = S | M | L
  deriving (Show, Eq)
data Color = Red | Blue | Green
  deriving (Show, Eq)
data Flavor = Chocolate | Oatmeal | Sugar
  deriving (Show, Eq)

data WrappedGift = Card String String Gift
                 | Bag  String String Gift
                 | Box  String String Gift

instance Show WrappedGift where
  show (Card to from _) = "[Card] To:" ++ to ++ " From:" ++ from
  show (Bag  to from _) = "[Bag] To:" ++ to ++ " From:" ++ from
  show (Box  to from _) = "[Box] To:" ++ to ++ " From:" ++ from

unwrap :: String -> [WrappedGift] -> [Gift]
unwrap _ [] = []  
unwrap name (w:ws) = case w of
                  Card to from g | to == name -> g : unwrap name ws
                  Bag  to from g | to == name -> g : unwrap name ws
                  Box  to from g | to == name -> g : unwrap name ws
                  _ -> unwrap name ws 
 
keep :: [Gift] -> [Gift]
keep = filter isKeeper
  where 
    isKeeper (Clothes _ _) = True
    isKeeper (Clothes S Green) = False
    isKeeper (Cookies _) = False 
    isKeeper (Toy name) = isPrefixOf "Lego" name 
    isKeeper _ = True

presents = [ Box "Alice" "Owen" (Clothes M Blue)
           , Box "Owen" "Alice" (Clothes M Blue)
           , Bag "Owen" "Bob" (Cookies Sugar) 
           , Bag "Bob" "Owen" (Cookies Chocolate) 
           , Card "Owen" "Carol" (Cash 25) 
           , Bag "Owen" "Carol" (Clothes L Red) 
           , Box "Owen" "Dave" (Toy "Lego Mindstorms Robot") 
           , Box "Dave" "Owen" (Toy "Lego Hogwarts Castle") 
           , Box "Owen" "Eve" (Toy "Largo Minestorms Robot") 
           , Box "Owen" "Eve" (Clothes S Green )
           , Card "Eve" "Owen" (Cash 0)
           ]

regift :: String -> String -> [WrappedGift] -> [WrappedGift]
regift oldTo newTo wrapped = regift_helper gifts
  where
    gifts = unwrap oldTo wrapped
    keepers = keep gifts

    regift_helper [] = []
    regift_helper (g:gs) | elem g keepers = regift_helper gs
                         | otherwise      = wrap g : regift_helper gs

    wrap (Cookies f)    = Bag  newTo oldTo (Cookies f)    
    wrap (Clothes sz c) = Box  newTo oldTo (Clothes sz c)    
    wrap (Cash d)       = Card newTo oldTo (Cash d)    
    wrap (Toy n)        = Box  newTo oldTo (Toy n)    

main = putStrLn ( show (( keep . unwrap "Owen" ) presents ))
--main = putStrLn ( show ( regift "Owen" "Fred" presents ))

nats = 0 : next 1
  where
    next n = n : next (n+1)

  
