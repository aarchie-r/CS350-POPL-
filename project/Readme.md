# Untyped Lambda Calculus Implementation in Haskell

### Team Members 
+ Aarchie (200004)
+ Udit Prasad (201055) 
+ Asmita Nimesh (190198)
## Basic implementation details:
### Parsing
We have used recursive descent parsing to convert the given input string to lambda term using the appropriate rules.

Things to keep care while giving input:
+ Lambda symbol should be replaced by (\\\\)
+ There should be no space, i.e. all spaces should be removed 
+ Input should be fully parenthesized in case of valid lambda term
+ Variables should only be single character (a-z)
+ Input to Q2,3 and 4 should be a valid lamda term

On Valid Lambda Term, we will get the parsed form in terms of
+ `Var x` corresponds to x(variable)
+ `OneTerm x Y` correspomds to (λx.Y)
+ `TwoTerms X Y` corresponds to XY  

whereas on 
invalid Lambda term. we will get  `error "Invalid Lambda term"` or any other exception.
### Free Variables
For Free variables calculation, we have recursively invoked the same function using the 3 basic rules to find freeVars.

We have used merging of lists after dropping duplicates to find union of free variables.

### Substitution

We have used all the rules while doing beta substitution

### Beta Reduction

It recursively calls itself and also makes use of substitution and ends up in normal form if it exixts. 

## Example inputs
1. Grammar Checker
   + Lambda term- a
        + Input -` parseExpr "a"`
        + Output - `Var 'a'`
   + Lambda term- (λx.y)
        + Input - `parseExpr "(\\x.y)"`
        + Output - `Oneterm (Var 'x') (Var 'y')`
   + Lambda term - (λa.(λb . ba)a)b
        + Input - `parseExpr "(((\\a.(\\b.ba))a)b)" `
        + Output -  `Twoterms (Twoterms (Oneterm (Var 'a') (Oneterm (Var 'b') (Twoterms (Var 'b') (Var 'a')))) (Var 'a')) (Var 'b')`
   + Lambda term- (λx.xx)(λx.xx)
        + Input - `parseExpr "(\\x.xx)(\\x.xx)"`
        + Output - `Twoterms (Oneterm (Var 'x') (Twoterms (Var 'x') (Var 'x'))) (Oneterm (Var 'x') (Twoterms (Var 'x') (Var 'x')))`
2. Free Variables
   + Lambda term- a
        + Input - `freeVariables "a"`
        + Output -` "a"`
   + Lambda term- (λx.y)
        + Input - `freeVariables "(\\x.y)"`
        + Output - `"y"`
   + Lambda term - (λa.(λb . ba)a)b
        + Input - `freeVariables "(((\\a.(\\b.ba))a)b)"` 
        + Output -  `"ab"`
   + Lambda term- (λx.xx)(λx.xx)
        + Input - `freeVariables "(\\x.xx)(\\x.xx)"`
        + Output - ""
   + Lambda term- ((λy.y)(λx.(λz.(zy))))w
        + Input - `freeVariables "((\\y.y)(\\x.(\\z.(zy))))w"`
        + Output - `"wy"`
3. Substitution
   + a [a:=b]
        + Input - `substitute "a" 'a' "b" `
        + Output -`b`
   + a [b:=c]
        + Input - `substitute "a" 'b' "c"`
        + Output - `a`
   + λx.y [y:=z]
        + Input - `substitute "\\x.y" 'y' "z" `
        + Output - `\\x.(z)`
   + (λx.y)(λy.yz) [z:=(λx.xx)]
        + Input - `substitute "(\\x.y)(\\y.yz)" 'z' "(\\x.xx)"`
        + Output - `(\\x.(y))(\\y.((y)(\\x.((x)(x)))))`
   + ((λy.y)(λx.(λz.(zy))))w [w:=λx.xx)] 
        + Input - `substitute "((\\y.y)(\\x.(\\z.(zy))))w" 'w' "(\\x.xx)" `
        + Output - `((\\y.(y))(\\x.(\\z.((z)(y)))))(\\x.((x)(x)))`
4. Beta Reduction
   + Lambda Term: (λa.(λb . ba)a)b
        + Input - `betaReduction "(((\\a.(\\b.ba))a)b)"` 
        + Output -`(b)(a)`
   + Lambda term: (λx.xx)(λa.a)
        + Input - `betaReduction "(\\x.xx)(\\a.a)"`
        + Output - `\\a.(a)`
   + Lambda term: (λx.xx)(λx.xx)
        + Input - `betaReduction "(\\x.xx)(\\x.xx)"` 
        + Output - Infinite Loop
   + Lambda term: ((λx.xx)(λy.yx))z
        + Input - `betaReduction "((\\x.xx)(\\y.yx))z"`
        + Output - `((x)(x))(z)`
   + Lambda term: ((λz.z)(λy.yy))(λx.xa)
        + Input - `betaReduction "((\\z.z)(\\y.yy))(\\x.xa)"` 
        + Output - `(a)(a)`
   + Lambda term: (λy.(λx.x(yy)))x
        + Input - `betaReduction "(\\y.(\\x.x(yy)))x"`
        + Output - `\\x.((x)((x)(x)))`
