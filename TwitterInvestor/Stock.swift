//
//  Stock.swift
//  TwitterInvestor
//
//  Created by Denise Koch on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation


class Stock {

    let DBUG                = false

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

    var quoteData : [String:AnyObject]
    var emptyDictionary = Dictionary<String, String>()

    init(jsonDictionary: [String:AnyObject]) {

        // Extract stock quote data
        self.count    = jsonDictionary.count

        self.query    = jsonDictionary["query"] as [String:AnyObject]
        self.results  = query["results"] as [String:AnyObject]
        self.quote    = results["quote"] as [String:AnyObject]

        // Copy input 'quote' data...
        self.quoteData = quote

        if let theStringValue  = quote["ErrorIndicationreturnedforsymbolchangedinvalid"] as? String {
            if theStringValue.hasPrefix( "No such ticker symbol" ) {

                self.quoteData = emptyDictionary

            } else {

                self.quoteData = quote

                self.symbol = getStringValue( "Symbol" )!
                self.ticker = getStringValue( "Symbol" )!
            }
        }

        // ---------------------------------------------------------------------

        if DBUG {
            println( "symbol[\(symbol)] symbol[\(ticker)]" )
            for ( key, value ) in quoteData {
                println( "Key: \(key) Value: \(value) " )
            }
            println( quote )
        }
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
    func convertToInt( key : NSString ) -> Int? {
        if DBUG { println( "convertToInt() key[\(key)]" ) }
        var searchKey  = key
        if  searchKey == "Company" { searchKey = "Name" }
        if  let theStringValue = quoteData["\(searchKey)"] as? String {
            let anInteger      = theStringValue.toInt()
            return anInteger!
        } else {
            return 0   // ????
        }
    }

    func getStringValue( key: NSString ) -> String? {
        if DBUG { println( "getStringValue() key[\(key)]" ) }
        var searchKey  = key
        if  searchKey == "Company" { searchKey = "Name" }
        if let theStringValue  = quoteData["\(searchKey)"] as? String {
           return theStringValue
        } else {
           return "-"
        }
    }

    func convertToFloat( key: NSString ) -> Float? {
        if DBUG { println( "convertToFloat() key[\(key)]" ) }
        var searchKey  = key
        if  let theStringValue = quoteData["\(key)"] as? String {
            let aFloat         = (theStringValue as NSString).floatValue
            return aFloat
        } else {
            return 0.0  // ????
        }
    }

    func isValidQuote( quote : [String:AnyObject] ) -> Bool {
        println( "isValidQuote()" );
        return false
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

/*  func createNumberWithCommas( floatValue : Float ) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //[formatter setNumberStyle:NSNumberFormatterNoStyle];
        //[formatter setPositiveFormat:@"###-###-####"];
        [formatter setGroupingSeparator:@"."];
        [formatter setGroupingSize:2];
        [formatter setUsesGroupingSeparator:YES];
        [formatter setSecondaryGroupingSize:3];

        //[formatter setLenient:YES];
        NSString *num = @"539000";
        NSString *str = [formatter stringFromNumber:[NSNumber numberWithDouble:[num doubleValue]]];
        [formatter release];
        NSLog(@"%@",str);
    }   */

    func printStockDictionary( jsonDictionary : [String:AnyObject] ) {

    }
}