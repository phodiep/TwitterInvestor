//
//  Stock.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation

class Stock {

    var symbol: String
    var ticker: String
    var name: String
    var companyName: String
    var price: Float?
    var change: Float?
    var pe: Float?
    
    
    init(jsonDictionary: [String:AnyObject]) {

        self.symbol         = jsonDictionary["symbol"] as String
        
        self.ticker         = jsonDictionary["ticker"] as String
        self.companyName    = jsonDictionary["name"] as String
        self.name           = jsonDictionary["name"] as String

        self.price          = ( jsonDictionary["price"] as Float )
        self.change         = ( jsonDictionary["change"] as Float )
        self.pe             = ( jsonDictionary["pe"] as Float )

        printStockDictionary( jsonDictionary )
    }
    
    init(ticker: String, companyName: String, change: Float = 0.0, price: Float = 0.0, pe: Float = 0.0) {
        self.ticker = ticker
        self.symbol = ticker
        self.companyName = companyName
        self.name = companyName
        self.change = change
        self.price = price
        self.pe = pe
    }

    func getTicker() -> String {
        return self.ticker
    }

    func getName() -> String {
        return self.name
    }

    func printStockDictionary( jsonDictionary : [String:AnyObject] ) {

    }
    
}