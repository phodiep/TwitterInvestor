//
//  Stock.swift
//  TwitterInvestor
//
//  Created by Denise Koch on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation


class Stock {

    let DBUG                        = false

    private var symbol: String      = ""
    private var ticker: String      = ""
    private var name: String        = ""
    private var companyName: String = ""
    private var ask: Float?         = 0.0
    private var change: Float?      = 0.0
    private var pe: Float?          = 0.0
    private var peratio: Float?     = 0.0
    private var price: Float?       = 0.0

    private var count   : Int         = -1
    private var query   : [String:AnyObject]
    private var results : [String:AnyObject]
            var quote   : [String:AnyObject]

//  var quoteData : [String:AnyObject]
    var emptyDictionary = Dictionary<String, String>()

    init(jsonDictionary: [String:AnyObject]) {

        // Extract stock quote data
        self.count     = jsonDictionary.count

        self.query     = jsonDictionary["query"] as [String:AnyObject]
        self.results   = query["results"] as [String:AnyObject]
        self.quote     = results["quote"] as [String:AnyObject]
        // 'quote' now contains all of the available data for this quote request.yy

        // Let's check to see if we got a valid 'ticker symbol' and it's data.
        if let theStringValue  = quote["ErrorIndicationreturnedforsymbolchangedinvalid"] as? String {
            if theStringValue.hasPrefix( "No such ticker symbol" ) {

                self.quote = emptyDictionary

            } else {

                self.symbol         = getSymbol()  // getStringValue( "Symbol" )!
                self.ticker         = getSymbol()  // getStringValue( "Symbol" )!
                self.name           = getName()
                self.companyName    = getCompanyName()
                self.ask            = convertToFloat( "AskRealTime" )
                self.change         = convertToFloat( "Change" )
                self.pe             = convertToFloat( "PERatio" )
                self.peratio        = convertToFloat( "PERatio" )
                self.price          = convertToFloat( "AskRealTime" )
                getDaysRange()
            }
        }

        // ---------------------------------------------------------------------

        if DBUG {
            println( "symbol[\(symbol)] symbol[\(ticker)]" )
            for ( key, value ) in quote {
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

    }

    /**
     *
     */
    func convertToInt( key : NSString ) -> Int? {
        if DBUG { println( "convertToInt() key[\(key)]" ) }
        var searchKey  = key
        if  searchKey == "Company" { searchKey = "Name" }
        if  let theStringValue = quote["\(searchKey)"] as? String {
            let anInteger      = theStringValue.toInt()
            return anInteger!
        } else {
            return 0   // ????
        }
    }

    /*
     * New Version, w/ comma's
     */
    func getStringValue( key: NSString ) -> String? {
        if DBUG { println( "getStringValue() key[\(key)]" ) }
        var searchKey  = key
        var testString : NSString  = ""
        if  searchKey == "Company" { searchKey = "Name" }
        if  searchKey == "Price"   { println( "Price[\(searchKey)]") }
        if  searchKey == "Change"  { println( "Change[\(searchKey)]") }
        
        if let theStringValue  = quote["\(searchKey)"] as? String {
            if theStringValue.rangeOfString( "." ) != nil {
                println( theStringValue.rangeOfString( "." ))
                let results = theStringValue.rangeOfString( "." );
                let short   = theStringValue.
                println("key[\(key)] [\(theStringValue)|\(results)] -> decimal point exists")
            }
            return theStringValue

        } else {
           return "-"
        }
    }

    func getStringValuePlain( key: NSString ) -> String? {
        if DBUG { println( "getStringValue() key[\(key)]" ) }
        var searchKey  = key
        if  searchKey == "Company" { searchKey = "Name" }
        if let theStringValue  = quote["\(searchKey)"] as? String {
           return theStringValue
        } else {
           return "-"
        }
    }

    func convertToFloat( key: NSString ) -> Float? {
        if DBUG { println( "convertToFloat() key[\(key)]" ) }
        var searchKey  = key
        if  let theStringValue = quote["\(key)"] as? String {
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
        return getStringValue( "Symbol" )!
    }

    func getTicker() -> String {
        return getStringValue( "Symbol" )!
    }

    func getName() -> String {
        return getStringValue( "Name" )!
    }

    func getCompanyName() -> String {
        return  getStringValue( "Name" )!
    }

    func getChange() -> String {
        return getStringValue( "Change" )!
    }
    
    func getPrice() -> String {
        return getStringValue( "AskRealTime" )!
    }

    func getPERatio() -> String {
        return getStringValue( "PERatio" )!
    }

    func getDaysRange() -> String {
        return getStringValue( "DaysRange" )!
    }

    func getFiftyDayAverage() -> String {
        return getStringValue( "FiftydayMovingAverage" )!
    }

    func getMarketCapitalization() -> String {
        return getStringValue("MarketCapitalization")!
    }

    func getAverageDailyVolume() -> String {
        return getStringValue("AverageDailyVolume")!
    }

    func getEPSEstimateCurrentYear() -> String {
        return getStringValue("EPSEstimateCurrentYear")!
    }

    func getDividendYield() -> String {
        return getStringValue("DividendYield")!
    }

    /*
    setValueLabel(dividendLabel,       self.stock.getStringValue("DividendYield")!)jk
    func createNumberWithCommas( floatValue : Float ) {
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