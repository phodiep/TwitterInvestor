//
//  Stock.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation


class Stock {

    let DBUG                = true

    var symbol: String      = ""
    var ticker: String      = ""
    var name: String        = ""
    var companyName: String = ""
    var ask: Float?         = 0.0
    var change: Float?      = 0.0
    var pe: Float?          = 0.0
    var peratio: Float?     = 0.0
    var price: Float?       = 0.0

    var count : Int         = -1
    var query : [String:AnyObject]
    var results : [String:AnyObject]
    var quote : [String:AnyObject]

    var quoteData : AnyObject

    init(jsonDictionary: [String:AnyObject]) {

        // Extract stock quote data
        self.count    = jsonDictionary.count

        self.query    = jsonDictionary["query"] as [String:AnyObject]
        self.results  = query["results"] as [String:AnyObject]
        self.quote    = results["quote"] as [String:AnyObject]

        // Copy input 'quote' data...
        self.quoteData = quote

        // ---------------------------------------------------------------------

        for key in quote.keys {
            println("Key: \(key)")
        }

        for (key, value) in quote {
            println("Key: \(key)")
        }

        if DBUG { println( quote ) }

//        printStockDictionary( jsonDictionary )
    }

    init(ticker: String, companyName: String, change: Float = 0.0, price: Float = 0.0, pe: Float = 0.0) {

        self.ticker = ticker
        self.symbol = ticker
        self.companyName = companyName
        self.name = companyName
        self.change = 0.0
        self.price = 0.0
        self.pe = 0.0

        // just to keep the compiler quite.
        self.query  =  Dictionary()
        self.results = Dictionary()
        self.quote   = Dictionary()

        self.quoteData = quote
    }

    /**
     *
     */
    func convertToInt( key : NSString ) -> Int {
        println( "convertToInt() key[\(key)]" )
        let aString   : NSString   = quoteData["\(key)"] as NSString
        let anInteger : Int?       = aString.integerValue
        return anInteger!
//        let a:Int? = firstText.text.toInt() // firstText is UITextField

    }

    func getStringValue( key: NSString ) -> NSString {
        println( "getStringValue() key[\(key)]" )
        let string : NSString       = quoteData["\(key)"] as String
        return string
    }

    func convertToFloat( key: NSString ) -> Float {
        println( "convertToFloat() key[\(key)]" )
        let string : NSString   = quoteData["\(key)"] as NSString
        let aFloat : Float      = string.floatValue
        return aFloat
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

    func printStockDictionary( jsonDictionary : [String:AnyObject] ) {

    }
}