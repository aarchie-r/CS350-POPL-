> import Data.List as List

importing the data structure library
-----------------------------Q1--------------------------------

> takeAlternative 0 _ = []
> takeAlternative n [] = []
> takeAlternative n (x:xs) = x : (takeAlternative (n-1) (List.tail xs))

this function "takeAlternative" takes two arguments - The first argument is a natural number N and the second is a
list of type [a] sufficiently long and returns a list of same type [a] a list of N elements from the positions 0, 2, . . ., 2N
and if it runs out of elements it returns as much elements as it can.
The function basically prints the first element and recursively removes first element from remaining list using "List.tail xs" 
and calling function again for n-1 elements appending it to resulting list

takeAlternative :: (Eq t, Num t) => t -> [a] -> [a]

-----------------------------Q2--------------------------------

> lastElem [] = Prelude.undefined
> lastElem (x:xs) = if (length (x:xs) /= 1)
>                    then (lastElem xs)
>                     else x

function "Last" which takes a list of type [a] and
returns the last element of the list

for empty list it returns "undefined"
and for the non-empty list it checks if the length is equal to 1 returns the very first element 
else calls again the function for the tail of list

lastElem :: [p] -> p

-----------------------------Q3--------------------------------

> removeDuplicates [] = []
> removeDuplicates (x:xs) = x : removeDuplicates (List.filter (\y -> y/=x) xs)

function "removeDuplicates" is used to filter out all the duplicates from a list

> merge (x:xs) [] = removeDuplicates(x:xs)
> merge [] (y:ys) = removeDuplicates(y:ys)
> merge (x:xs) (y:ys) = if (x<y)
>                         then removeDuplicates (x:(merge xs (y:ys)))
>                         else removeDuplicates (y:(merge (x:xs) ys))

function "merge" of type [a] → [a] → [a] which merges two sorted lists and produces a merged sorted list with no
duplicates using function "removeDuplicates" preserving the original ordering
first the cases with the any of the empty list if given is handled
then first elements of both the lists are compared  then the one with smaller value is appended in list and checked for the duplicates
furthur recursively called merge function.


-----------------------------Q4--------------------------------

-------------(a)-------------

> makeZip [] [] = []
> makeZip (x:xs) (y:ys) = if (length (x:xs) == length (y:ys)) 
>                             then (x,y) : (makeZip xs ys)
>                         else error "not equal length" 

the function "makeZip" is of type [a] → [b] → [(a, b)] which takes two lists of equal length and produces a list of tuples -
the first element from each tuple comes from the first list
and the second comes from the second list
throws error if the list is of not same length.

-------------(b)-------------

> zipWith foo [] [] = []
> zipWith foo (x:xs) (y:ys) = map foo1 (makeZip (x:xs) (y:ys))
>                                 where foo1 (x,y) = foo x y

function "zipWith" is of type (a → b → c) → [a] → [b] → [c] which takes a function f of type
(a → b → c), and two lists [x1, x2, . . . ] and [y1, y2, . . . ] and
produces the list [(f x1 y1),(f x2 y2), . . . ] by mapping the function to the tuple produced using "makeZip"


-----------------------------Q5--------------------------------

-------------(a)-------------

right-associative fold, "foldR" is implemented as-

> foldR foo start []= start
> foldR foo start (x:xs) = foo x (foldR foo start xs)

it takes a function, the starting value and the list of values to be considered.
it is of type-
foldR :: (t1 -> t2 -> t2) -> t2 -> [t1] -> t2

where function "foo" is made right associative by making the result
at the remaining list as second argument by recursively calling "foldR"

-------------(b)-------------

> mapFoldR funct [] = []
> mapFoldR funct (x:xs) =funct x : (foldR (\y ys -> (funct y):ys) [] xs)

the map function implemented using "foldR" is given by "mapFoldR" function 
using "(:)" as function in place of foo defined by the lambda function,
 which appends the first element to the remaining list by evaluating it with function "funct"
 and the start value is made empty list, so that it becomes the end point for the list.


-----------------------------Q6--------------------------------

> numsFrom n = n : numsFrom (n+1)

the infinite list with starting value n and recursively calling function at n+1 thus in ascending order

-------------(a)-------------

infinite stream using list comprehension

> streamByListComprehension = List.filter (\n -> ((n `mod` 2 ==0) || (n `mod` 3 ==0) || (n `mod` 5==0))) (numsFrom 2)

using function "List.filter" we filter out the numbers which satisfy the given condition 
from the infinite list so generated using function "numsFrom" starting from 2
and thus generating infinite stream of numbers satisfing the condition of each number being-
multiples of 2, 3 or 5

-------------(b)-------------

infinite stream using self-referential streams

> getStream (x:xs) = if ((mod x 2 ==0) || (mod x 3 ==0) || (mod x 5==0))
>                 then x: getStream xs
>             else getStream xs

> streamBySelfReferential = getStream (numsFrom 2)

"getStream" function is given the stream of natural numbers starting from 2
it checks each starting element for condition, if satisfied it is included in the final stream else we just parse 
and finally call for the function recursively for the remaining list.

-----------------------------------------------------------------------------------------------------------