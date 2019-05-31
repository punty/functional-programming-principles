import Foundation
/*:
 # Functional Programming Principles in Swift
 ## Substitution model
 The idea underlying this model is that all evaluation does is reduce an expression to a value.
 Program expressions are evaluated in the same way we would evaluate a mathematical expression It can be applied to all expressions, as long as they have no side effects.
 
 ## Expression Evaluation
 1. Take the operator with highest precedence.
 2. Evaluate its operands from left to right.
 3. Apply the operator to operand values
Example Expression Evaluation
 */
    let pi = 3.14159
    let radius = 10.0
    (2 * pi) * radius
    (2 * 3.14159) * radius
    6.28318 * radius
    6.28318 * 10
    62.8318
/*:
 ## Function Evaluation
 ## call-by-value
 first resolve arguments then function. This is used by default parameters to a function call are evaluated in the caller's context then copied to the callee. That's call-by-value because the only thing the callee gets is a copy of the value; any changes are local to the callee only. This is very restricting so call-by-reference has being introduced (so the pointer is copied but the referenced variable is available and it's possible to modify)
 ## call-by-name
 first resolve function then arguments, the the parameters aren't evaluated at call time, they are substituted into the callee instead.
 */
    let square: (Double) -> Double = { $0 * $0 }
    square(2.0)
    let sumOfSquares: (Double, Double) -> Double  = {
        return square($0) + square($1)
    }
/*:
Call-by-value Example
 */
    sumOfSquares(3, 2+2)
    sumOfSquares(3, 4)
    square(3) + square(4)
    3 * 3 + square(4)
    9 + square(4)
    9 + 4 * 4
    9 + 16
    25

/*:
Call-by-name Example
*/
    sumOfSquares(3, 2+2)
    square(3) + square(2+2)
    3 * 3 + square(2+2)
    9 + square(2+2)
    9 + (2+2) * (2+2)
    9 + 4 * (2+2)
    9+4*4
    25

/*:
 ## Interestring properties:
 * call-by-name and call-by-value evaluation strategies reduce an expression to the same value, as long as both evaluations terminate
 * If call-by-value evaluation of an expression terminates, then call-by-name evaluation of e terminates, too. (the opposite is not always true)
*/
/*:
 ## Recursion
 First recursion example
 */
    func sqrt(x: Double, guess: Double) -> Double {
        func isGuessValid(_ guess: Double) -> Bool {
            return abs(x * x - guess) / x < 0.001
        }
        func improveGuess(_ guess: Double) -> Double {
            return (guess + x / guess) / 2.0
        }
        func sqrtIter(_ guess: Double) -> Double {
            if isGuessValid(guess) {
                return guess
            } else {
                return sqrtIter(improveGuess(guess))
            }
        }
        return sqrtIter(1.0)
    }
    sqrt(10)

/*:
Factorial not tail recursion
 */
    func factorial(_ n: Int) -> Int {
        precondition(n >= 0)
        if n == 0 {
            return 1
        }
        
        return n * factorial(n - 1)
    }

    factorial(4)
/*:
 Factorial not tail recursion Evaluation
*/
    factorial (4)
    4 * factorial(3)
    4 * (3 * factorial(2))
    4 * (3 * (2 * factorial(1)))
    4 * (3 * (2 * (1 * factorial(0))))
    4 * (3 * (2 * (1 * 1)))
    24
/*:
 Factorial tail recursion
 */
    func factorialIter(_ n: Int, _ acc: Int) -> Int {
        if n == 0 {
            return acc
        } else {
            return factorialIter(n-1, acc * n)
        }
    }

    func factorialTailRec(_ n: Int) -> Int {
        precondition(n >= 0)
        return factorialIter(n, 1)
    }

    factorialIter (4, 1)
    factorialIter (3, 4)
    factorialIter (2, 12)
    factorialIter (1, 24)
    24
/*:
 Exercise 1:
 Write a function that computes the elements of Pascal’s triangle by means of a recursive process.  
 ![Pascal Triangle](pascal.png)
 */
func pascalTriangle(col: Int, row: Int) -> Int {
    func triangle(col: Int, row: Int) -> Int {
        precondition(row >= 0 && col >= 0 && col <= row)
        if col == row || col == 0 {
            return 1
        } else {
            return triangle(col: col-1, row: row-1) + triangle(col: col, row: row-1)
        }
    }
    return triangle(col: col, row: row)
}
pascalTriangle(col: 2, row: 4)
pascalTriangle(col: 4, row: 5)
/*:
 Write a recursive function which verifies the balancing of parentheses in a string
 */
func balance(chars: String) -> Bool {
    func balanceIter(chars: String.SubSequence, count: Int) -> Bool {
        if chars.isEmpty { //stop if it's empty and return true if balanced
            return count == 0
        } else if chars.first! == "(" { //if open parathesis increase count and continue
            return balanceIter(chars: chars.dropFirst(), count: count + 1)
        } else if chars.first! == ")" { //if close parathesis check if we have an open count (it means we are expecting a close brace) decrese the count and continue
            return count > 0 && balanceIter(chars: chars.dropFirst(), count: count - 1)
        } else { //just continue
            return balanceIter(chars: chars.dropFirst(), count: count)
        }
    }
    return balanceIter(chars: chars[chars.startIndex..<chars.endIndex], count: 0)
}
balance(chars:"(if (zero? x) max (/ 1 x))") //true
balance(chars: "I told him (that it’s not (yet) done). (But he wasn’t listening)") //true
balance(chars: ":-)") //false
balance(chars: "())(") //false
/*:
 Write a recursive function that counts how many different ways you can make change for an amount, given a list of coin denominations. For example, there are 3 ways to give change for 4 if you have coins with denomination 1 and 2: 1+1+1+1, 1+1+2, 2+2.
 */
func countChange(money: Int, coins: [Int]) -> Int {
    func countChangeIter(money: Int, coins: ArraySlice<Int>) -> Int {
        if money < 0 || coins.isEmpty { //we have no coin left or we have negative money just return 0
            return 0
        } else if (money == 0) { //base case, return 1 because we have one way to return this money gived the coin value
            return 1
        } else { //we iterate, get the first coin value and remove from money value + all the other combination
            return countChangeIter(money: money - coins.first!, coins: coins) + countChangeIter(money: money, coins: coins.dropFirst())
        }
    }
    return countChangeIter(money: money, coins: coins[coins.startIndex..<coins.endIndex])
}
countChange(money: 10, coins: [1,2,3,4,5])


//Week 2
struct Rational {
    
    private static func gcd(_ a: Int, _ b: Int) -> Int {
        func gcdIter (a: Int, b: Int) -> Int {
            if (b == 0) {
                return a
            } else {
                return gcdIter(a: b, b: a % b)
            }
        }
        return gcdIter(a: a, b: b)
    }
    
    let numer: Int
    let denom: Int
    
    init(numer: Int, denom: Int) {
        precondition(denom != 0, "denominator must be positive")
        let g = Rational.gcd(numer, denom)
        self.numer = numer/g
        self.denom = denom/g
    }
    
    func add(_ toAdd: Rational) -> Rational {
        return Rational (numer: numer * toAdd.denom + toAdd.numer * denom,
                         denom: denom * toAdd.denom)
    }
    
    var neg: Rational {
        return Rational(numer: -numer, denom: denom)
    }
    
    func sub(_ toSub: Rational) -> Rational {
        return add(toSub.neg)
    }
    
    func less(than: Rational) -> Bool {
        return numer * than.denom < than.numer * denom
    }
    
    func max(than: Rational) -> Rational {
       let max = (less(than: than)) ? than : self
       return max
    }
}

extension Rational: CustomStringConvertible {
    var description: String {
        return "\(numer) / \(denom)"
    }
}

extension Rational: AdditiveArithmetic {
    static func - (lhs: Rational, rhs: Rational) -> Rational {
        return lhs.sub(rhs)
    }
    
    static func += (lhs: inout Rational, rhs: Rational) {
        lhs = lhs.add(rhs)
    }
    
    static func + (lhs: Rational, rhs: Rational) -> Rational {
        return lhs.add(rhs)
    }
    
    static var zero: Rational {
       return Rational(numer: 0, denom: 1)
    }
    
    static func -= (lhs: inout Rational, rhs: Rational) {
        lhs = lhs.sub(rhs)
    }
}

let x = Rational(numer: 3, denom: 3)
let y = Rational(numer: 1, denom: 3)
let z = Rational(numer: 2, denom: 3)

let c = x - y - z

typealias CharacteristicSet = (Int) -> Bool

func contains(_ s: CharacteristicSet, element: Int) -> Bool {
    return s(element)
}

func singletonSet(element: Int) -> CharacteristicSet {
    return { $0 == element }
}

func union(_ s: @escaping CharacteristicSet, _ t: @escaping CharacteristicSet) -> CharacteristicSet {
    return {
        contains(s, element: $0) || contains(t, element: $0)
    }
}

func intersect(_ s: @escaping CharacteristicSet, _ t: @escaping CharacteristicSet) -> CharacteristicSet {
    return {
        contains(s, element: $0) && contains(t, element: $0)
    }
}
func diff(_ s: @escaping CharacteristicSet, _ t: @escaping CharacteristicSet) -> CharacteristicSet {
    return {
        contains(s, element: $0) && !contains(t, element: $0)
    }
}

func filter(_ s: @escaping CharacteristicSet, predicate: @escaping (Int) -> Bool) -> CharacteristicSet {
    return intersect(s, predicate)
}

let a = singletonSet(element: 4)
let v = singletonSet(element: 5)
union(a, v)

//TODO
final class Boolean {
    
}
