// Playground - noun: a place where people can play

import UIKit

func printSomething(string : String) {
  println(string)
}

printSomething("Brad")

let printSomethingFunction : (String) -> () = printSomething

printSomethingFunction("Brad")

func addTwoNumbers(a : Int, b : Int, completionHandler : (Int) -> (Int)) {
  completionHandler(32)
  let sum = a + b
  completionHandler(sum)
}

func doSomethingWithNumber(num : Int) -> Int {
  println(num)
  return num
}

//calling it with a global function
addTwoNumbers(2, 2, doSomethingWithNumber)

//calling it with a closure expression
addTwoNumbers(2, 2) { (sum : Int) -> (Int) in
  println(sum)
  let multiply = sum * sum
  return multiply
}

var completionHandler = {(sum : Int) -> (Int) in
  println(sum)
  var a = 32
  return a
}

//CLOSURE CHALLENGE - Design a 




















