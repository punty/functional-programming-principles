import Foundation

//Functional Programming Principles in Swift

//1.Evaluation Strategy
//All the evaluation does is reducing an expression to a value
//Can express every algorithm (if not side effect) -> example C++ (has a side effect on the variable c so can't be express as substitution we need a store)
//call-by-value -> first resolve arguments then function <- this is used by default
//call-by-name -> first resolve function then arguments <- Autoclosure
//http://www.russbishop.net/swift-call-by-name

let square: (Double) -> Double = { $0 * $0 }
square(2.0)

let sumOfSquare: (Double, Double) -> Double  = {
    return square($0) + square($1)
}

//substitution model
sumOfSquare(3, 2+2)
sumOfSquare(3, 4)
square(3) + square(4)
3 * 3 + square(4)
9 + square(4)
9 + 4 * 4
9 + 16
25

//Lambda calculs

//Tail recursion

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

//Functional form of a loop (Tail Recursion)
func gcd(_ a: Int, _ b: Int) -> Int {
    return b == 0 ? a: gcd(b,a % b)
}

//Evaluation
gcd(14,21)
gcd(14,21)
gcd(21, 14)
gcd(14, 7)
gcd(7, 0)
7

func factorial(_ n: Int) -> Int {
    precondition(n >= 0)
    if n == 0 {
        return 1
    }
    
    return n * factorial(n - 1)
}

factorial(4)

//Evaluation
factorial (4)
4 * factorial(3)
4 * (3 * factorial(2))
4 * (3 * (2 * factorial(1)))
4 * (3 * (2 * (1 * factorial(0))))
4 * (3 * (2 * (1 * 1)))
24

func factorialTailRec(_ n: Int) -> Int {
    precondition(n >= 0)
    func factorialIter(_ n: Int, _ acc: Int) -> Int {
        if n == 0 {
            return acc
        } else {
            return factorialIter(n-1, acc * n)
        }
    }
    return factorialIter(n, 1)
}
factorialTailRec(4)

/*
    1
   1 1
  1 2 1
 1 3 3 1
1 4 6 4 1
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

func countChange(money: Int, coins: [Int]) -> Int {
    //TODO: Implement
    fatalError()
}


