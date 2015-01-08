// Playground - noun: a place where people can play

import UIKit


class Stack {
  var items = [Int]()
  func push(item : Int) {
    self.items.append(item)
  }
  
  func pop() -> Int? {
    if !self.items.isEmpty{
    let item = self.items.last
    self.items.removeLast()
    return item!
    } else {
      return nil
    }
  }
  
  func peak() ->Int? {
    return self.items.last
  }
}
