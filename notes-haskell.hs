import Data.List as List
import Data.Char

data NestedList a = Elem a | List [NestedList a]

data BinaryTree a = Nil | Node a (BinaryTree a) (BinaryTree a)

instance Show a => Show (BinaryTree a) where
    show Nil = "__"
    show (Node x ls rs) = (show x) ++ " (" ++ (show ls) ++ ") " ++ " (" ++ (show rs) ++ ") "


binaryTreeMap f Nil = Nil
binaryTreeMap f (Node x ls rs) = Node (f x) (binaryTreeMap f ls) (binaryTreeMap f rs) 

instance Functor (BinaryTree) where
    fmap = binaryTreeMap


instance Applicative (BinaryTree) where
    pure x = Node x Nil Nil
    Nil <*> _ = Nil
    _ <*> Nil = Nil 
    (Node x lx rx) <*> (Node y ly ry) = Node (x y) (lx <*> ly) (rx <*> ry)

-- instance Monad (BinaryTree) where
--     return x = Node x Nil Nil
--     Nil >>= _ = Nil
--     (Node x ls rs) >>= f = Node (f x) (ls >>= f) (rs >>= f)

tree1 = Node 1 (Node 2 Nil (Node 3 Nil Nil)) Nil

inorder :: Num a => BinaryTree a -> [a]
inorder Nil = [0]
inorder (Node x ls rs) = (inorder ls) ++ [x] ++ (inorder rs)

flatten :: NestedList a -> [a]
flatten (Elem a) = [a]
flatten (List (x:xs)) =flatten x ++ flatten (List xs)
flatten (List []) = []

encodett :: (Num a, Eq b) => a->b->[b]->[(a,b)]
encodett n x [] = [(n,x)]
encodett n x (y:ys) = if (x==y)
                    then (encodett (n+1) x ys)
                else (n,x):(encodett 1 y ys)
encode :: (Num b, Eq a) => [a]->[(b,a)]
encode []= []
encode (x:xs) = encodett 1 x xs

dropevery :: [a]->Int->[a]
dropevery [] n = []
dropevery x n = if((length x)< n)
                   then x
                else (take (n-1) x) ++ (dropevery (drop n x) n)

replica :: (Eq t, Num t) => t-> a -> [a]
replica 0 x = [] 
replica n x = x: (replica (n-1) x)

replicate :: (Eq b, Num b) => [a]->b->[a]
replicate [] n = []
replicate (x:xs) n = (replica n x) ++ (Main.replicate xs n)

split ::  [a] -> Int -> ([a],[a])
split x n = ((take n x), (drop n x))

slice :: [a] -> Int -> Int -> [a] 
slice x a b = take ((b-a)+1) (drop (a-1) x) 

rotate :: [a] -> Int -> [a]
rotate x n = if(n>0 || n==0)
                then (drop (n) x) ++ (take (n) x)
            else (drop ((length x) + n) x) ++ (take ((length x) + n) x)

removeat :: [a] -> Int -> ([a],[a])
removeat x n = ([ x!!(n-1)  ],((take (n-1) x) ++ (drop (n) x)))

insertat :: [a] -> [a] -> Int -> [a]
insertat x y n = (take (n-1) y) ++ x ++ (drop (n-1) y)

range :: Enum a => a->a->[a]---------------------------------------------enum
range x y = [x..y]

combinations :: (Eq b, Num b)=> b -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations n xs = [xs!!i : x | i<-[0..(length xs -1)],
                        x <- combinations (n-1) (drop (i+1) xs)]

group :: [Int] -> [a] -> [[a]]
group [] _ = [[]]
group (x:xs) y = (take (x) y):(Main.group xs (drop x y))

merge :: Foldable t => [t a] -> [t a] -> [t a] -----------------------foldable
merge xs []= xs
merge [] ys = ys
merge (x:xs) (y:ys) = if((length x) < (length y))
                        then x:(merge xs (y:ys))
                    else y:(merge (x:xs) ys)

lsort :: Foldable t => [t a] -> [t a]
lsort [xs] = [xs]
lsort xs = merge (lsort (take ((length xs) `div` 2) xs)) (lsort (drop ((length xs) `div` 2) xs))

check :: (Integral a) => [a] -> a -> Bool
-- mod :: Integral a => a -> a -> a
check [] n = True
check (x:xs) n = if(n `mod` x /= 0)
                    then check (List.filter (\y -> y `mod` x /=0) xs) n
                else False

isPrime :: Integral a => a->Bool
isPrime n = check [2..(n-1)] n


gcd a b = if(a `mod` b ==0)
            then b
        else (Main.gcd b (a `mod` b))


coprime a b = if((a `mod` b /=0) && (b `mod` a /=0))
        then True
        else False


-- main = putStrLn "Hello World!"

main = do
            putStrLn "Hello, ur name plz?"
            name <- getLine
            let exclamation = "!!"
            putStrLn $ "hello, " ++ name ++ exclamation

-- error_do_loop = do
--                    let exclamation = "!!!"
                   

to_reverse_main = do
                    line <- getLine
                    if null line
                        then return ()
                    else do
                        putStrLn $ reverseWords line
                        to_reverse_main


reverseWords :: String -> String  
reverseWords = unwords.map reverse.words  


-- may be monad
reciprocal 0 = Nothing
reciprocal x = return (1/x)

addM a b = return (a+b) 


-- list Monad
pos_negM x =  [x,-x] -- if return [x,-x] used [[1,-1],[2,-2],[3,-3]] else no nested loop
sqM x = return (x*x)

-- taking table as input
or' False False = False
or' _ _ = True

and' True True = True
and' _ _ = False

table :: (Bool -> Bool -> Bool) -> IO ()
--table (\a b -> (and' a (or' a b)))
table f = putStrLn $ concatMap (++ "\n")
            [show a ++ " " ++ show b ++ " " ++ show (f a b ) | a<- [True,False], b<-[True,False]]



isTree Nil = True
isTree (Node x ls rs) = (isTree ls) `and'` (isTree rs)


count n x = if(n-x==0)
                then 1
            else if (n<x)
                then 0
            else (count (n-x) 1) + (count (n-x) 5) + (count (n-x) 10) + (count (n-x) 25) + (count (n-x) 50)

ways n = (count (n) 1) + (count (n) 5) + (count (n) 10) + (count (n) 25) + (count (n) 50)


num_to_word :: Int -> IO ()

num_to_word n = putStrLn $ concat $ intersperse "-" [digit!!(digitToInt x) | x<- show n]
                    where digit=["zero","one","two","three","four","five","six","seven","eight","nine"]


--- using either
using_either= do
                let s = Left "foo"
                let n = Right 3
                putStrLn $ show ( either length (*2) s ) 
                -- putStrLn $ show (either length (*2) n)


-- foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
-- and :: Foldable t => t Bool -> Bool
-- (&&) :: Bool -> Bool -> Bool
-- max :: Ord a => a -> a -> a
-- either :: (a -> c) -> (b -> c) -> Either a b -> c
-- drop :: Int -> [a] -> [a]
-- range :: Enum a => a->a->[a] -- range x y = [x..y]
-- map :: (a -> b) -> [a] -> [b]