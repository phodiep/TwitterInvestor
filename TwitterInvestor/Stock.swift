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
    var ask: Float?         = 0.0
    var change: Float?      = 0.0
    var pe: Float?          = 0.0
    var peratio: Float?     = 0.0
    var price: Float?       = 0.0
    
    init(jsonDictionary: [String:AnyObject]) {

        // println( "Stock[\(jsonDictionary)]" );

        extractData( jsonDictionary )


        printStockDictionary( jsonDictionary )
    }
    
    init(ticker: String, companyName: String, change: Float = 0.0, price: Float = 0.0, pe: Float = 0.0) {

        self.ticker = ticker
        self.symbol = ticker
        self.companyName = companyName
        self.name = companyName
        self.change = 0.0
        self.price = 0.0
        self.pe = 0.0
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

    func getCompanyName() -> String {
        return self.name
    }

    func extractData( jsonDictionary : [String:AnyObject] ) {

        var count : Int = jsonDictionary.count
        var query    = jsonDictionary["query"] as [String:AnyObject]
        var results  = query["results"] as [String:AnyObject]
        var quote    = results["quote"] as [String:AnyObject]
        println( quote )

 //       var quote = jsonDictionary.indexForKey("quote")

        self.symbol         = quote["Symbol"] as String
        self.ticker         = quote["symbol"] as String    // Should be removed
        self.companyName    = quote["Name"] as String      // Should be removed
        self.name           = quote["Name"] as String

        let strPrice        = quote["AskRealtime"] as NSString     // Should be removed
        self.price          = strPrice.floatValue

        // println( "prices[\(self.price)" )
        let stringAsk       = quote["AskRealtime"] as NSString
        self.ask            = stringAsk.floatValue

        let stringChange         = quote["Change"] as NSString
        self.change            = stringChange.floatValue

        let stringPERatio             = quote["PERatio"] as NSString
        self.peratio            = stringPERatio.floatValue

        let stringPE       = quote["PERatio"] as NSString
        self.ask            = stringPE.floatValue
    }

    func convertToFloat( quote: NSString ) -> Float {
        var working : NSString  = ""
        var results : Float     = 0.0
        return results
    }

    func printStockDictionary( jsonDictionary : [String:AnyObject] ) {

    }

}