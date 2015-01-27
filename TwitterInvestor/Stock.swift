//
//  Stock.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation


class Stock {

    var symbol: String      = ""
    var ticker: String      = ""
    var name: String        = ""
    var companyName: String = ""
    var price: Float?       = 0.0
    var ask: Float?         = 0.0
    var change: Float?      = 0.0
    var pe: Float?          = 0.0
    var peratio: Float?     = 0.0
    
    init(jsonDictionary: [String:AnyObject]) {

        println( "Stock[\(jsonDictionary)]" );

        extractData( jsonDictionary )


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

    func getSymbol() -> String {
        return self.symbol
    }

    func getTicker() -> String {
        return self.ticker
    }

    func getName() -> String {
        return self.name
    }

    func extractData( jsonDictionary : [String:AnyObject] ) {

        var count : Int = jsonDictionary.count

        var quote = jsonDictionary.indexForKey("quote")

        self.symbol         = "" //jsonDictionary["Symbol"] as String
        self.ticker         = jsonDictionary["symbol"] as String    // Should be removed
        self.companyName    = jsonDictionary["Name"] as String      // Should be removed
        self.name           = jsonDictionary["Name"] as String

        self.price          = ( jsonDictionary["Ask"] as Float )    // Should be removed
        self.ask            = ( jsonDictionary["Ask"] as Float )
        self.change         = ( jsonDictionary["Change"] as Float )
        self.pe             = ( jsonDictionary["PERatio"] as Float )  // Should be removed
        self.peratio        = ( jsonDictionary["PERatio"] as Float )
    }

    func printStockDictionary( jsonDictionary : [String:AnyObject] ) {

    }

}