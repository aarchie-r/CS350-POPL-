import Data.Char
import Data.String

type Variable = Char                                                                    --Vaiables are of char type                                                
data Term = Var Variable | Oneterm Term Term | Twoterms Term Term deriving (Eq,Show)   -- Lambda term will consist of variable or oneterm(\x.Y) or twoterm(MN)

isLambda :: Char -> Bool                                                                -- Function to check if symbol is lambda symbol(\\)
isLambda x = if (x=='\\')   
                then True
            else False

isVariable :: Char -> Bool                                                              -- Function to check if symbol is variable(a-z)
isVariable x = ((x >='a') && (x <= 'z') )

showSimplified (Var x) = [x]                                                            -- Function to print parsed version in simplified format
showSimplified (Oneterm x y) = "\\"++(showSimplified x)++".("++ (showSimplified y) ++")"
showSimplified (Twoterms x y) = "("++(showSimplified x) ++ ")"++ "("++(showSimplified y) ++ ")"


-- function to get the closing ')' of the opend '(' pasarenthesis
-- (x:xs) is the list of characters i.e., string
-- p is the difference of closed and open parenthesis i.e., p = #(')') seen till now - #('(') seen till now
-- i= the ith element of list which needs to checked now

getClosing (x:xs) p i = if(x==')')              
                        then if(p+1==1)         -- check if it is an extra closing
                                then i          -- if yes, return its index
                                else if (length xs > 0)         
                                        then (getClosing xs (p+1) (i+1))       
                                        else -1         -- else we just return by saying no matching closing found
                        else if (x=='(')              
                                then if(length xs > 0)  
                                        then getClosing xs (p-1) (i+1)  
                                        else -1                -- else we just return by saying no matching closing found 
                        else if(length xs > 0)         
                                then getClosing xs p (i+1)      --recurssively call function with i= i+1 , if there are elements still left for search 
                                else -1                 -- else we just return by saying no matching closing found

parseExpr :: [Char] -> Term                                                             -- Function which parses given string to lambda term,                                           -- if it fails to do so, it raises an error "invalid lambda term"
parseExpr ('(':rs) = let i = getClosing rs 0 1 in
                        if(i==((length rs)))
                                then parseExpr (take (i-1) rs)
                        else if(i/=(-1)) 
                                then Twoterms (parseExpr (take (i-1) rs)) (parseExpr (drop (i) rs))
                        else  error "Invalid lambda term"                                           -- Invalid term
parseExpr (x:rs)
        | (isLambda x) && (head (tail rs) == '.') = Oneterm (Var (head rs)) (parseExpr (drop 2 rs)) -- For (\x.M)
        | (isVariable x) && (length rs > 0) = Twoterms (Var x) (parseExpr rs)                       -- For MN
        | (isVariable x) = Var x                                                                    -- For variable
        | otherwise = error "Invalid lambda term"                                                   -- Invalid term

----------------------------------------------(ii)----------------------------------------------------------------------

freeVar (Var a) = [a]                                                              -- freeVar (a) = a
freeVar (Oneterm y e) = [i | i <- (freeVar e), let j = freeVar y , i/=(head j)]    -- freeVar (\y.M) = freevar(M)\{y}
freeVar (Twoterms a b) = mergeLists (freeVar a) (freeVar b)                        -- freeVar (MN) = freevar(M) U freevar(N)

freeVariables x = freeVar (parseExpr x)
----------------------------------------------(iii)------------------------------------------------------------------------



substituteHelper (Oneterm y e) x v = if (x == (head (freeVar y)))            -- All rules of substitution are captured in these 3 statements             
                                then (Oneterm y e)
                        else let e' = (substituteHelper e x v) in (Oneterm y e')
substituteHelper (Var y) x v = if (x == y)
                        then v
                    else (Var y)
substituteHelper (Twoterms e1 e2) x v = Twoterms (substituteHelper e1 x v) (substituteHelper e2 x v)

substitute e x v = showSimplified (substituteHelper (parseExpr e) x (parseExpr v) )                       --substitute e x v: replace free instances of x in e with v
-----------------------------------------------(iv)------------------------------------------------------------------------

betaRed (Var x) = Var x                                                                    -- Different cases for betaReduction to work properly
betaRed (Oneterm y e) = Oneterm y (betaRed e)                
betaRed (Twoterms (Oneterm (Var y) e1) (Var x)) = betaRed (substituteHelper e1 y (Var x))
betaRed (Twoterms (Oneterm (Var y) e1) v) = betaRed (substituteHelper e1 y v)
betaRed (Twoterms (Twoterms (Var x) (Var y)) v) = (Twoterms (Twoterms (Var x) (Var y)) v)
betaRed (Twoterms (Twoterms e1 e2) v) = betaRed (Twoterms (betaRed (Twoterms e1 e2)) v)
betaRed (Twoterms (Var y) e) = Twoterms (Var y) (betaRed e)

betaReduction x = showSimplified (betaRed (parseExpr x))

------------------------------------Helper Functions--------------------


dropdups l | (length l < 2) = l                                   -- This function will drop the duplicates from a sorted list
           | (length l >=2) = if (x /= head xs)                   -- If first element is not equal to second one, then take first element into output
               then x: dropdups xs                                -- otherwise drop it
               else dropdups xs where
               (x:xs) = l 

mergeWithDups [] [] = []                                          -- Both are empty, return empty list 
mergeWithDups [] (x:xs) = (x:xs)                                  -- One of them is empty, return other list
mergeWithDups (y:ys) [] = (y:ys)
mergeWithDups (x:xs) (y:ys) = if (x==y)                           -- If both element are equal, take once and move to next element of both lists
    then x: mergeWithDups xs ys
    else if(x>y)
        then y: mergeWithDups (x:xs) ys                           -- else take the smaller one and move to the next element of this list 
        else x: mergeWithDups xs (y:ys)    

mergeLists a b = dropdups (mergeWithDups a b)                     -- This function makes use of mergeWithDups and dropdups to provide merged list with no duplicates if there are duplicates in input list
