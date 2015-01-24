//
//  Stock.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation

class Stock {
    var ticker: String
    var companyName: String
    
    init(jsonDictionary: [String:AnyObject]) {
        
        self.ticker = jsonDictionary["ticker"] as String
        self.companyName = jsonDictionary["name"] as String
        
    }
    
    init(ticker: String, companyName: String) {
        self.ticker = ticker
        self.companyName = companyName
    }
    
}