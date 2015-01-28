//
//  Stock.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation

class Stock {
    var ticker: String?
    var companyName: String?
    var industry: String?
    var price: Float?
    var change: Float?
    var changePerc: Float?
    var pe: Float?
    var dividend: Float?
    var dividendPerc: Float?
    
  init(){
    
  }
  
  
    init(jsonDictionary: [String:AnyObject]) {
        
        self.ticker = jsonDictionary["ticker"] as? String
        self.companyName = jsonDictionary["name"] as? String
        
    }
    
    init(ticker: String, companyName: String, change: Float = 0.0, price: Float = 0.0, pe: Float = 0.0) {
        self.ticker = ticker
        self.companyName = companyName
        self.change = change
        self.price = price
        self.pe = pe
    }
    
}