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

    func getFormattedRangeStringValue( key: NSString ) -> String? {
        var rangeWithCommas = "1,000,000 - 2,000,00"
        if DBUG { println( "getFormattedRangeStringValue() key[\(key)]" ) }
        return rangeWithCommas
    }

    /*
     * New Version, w/ comma's
     */
    func getFormattedStringValue( key: NSString ) -> String? {

        if DBUG { println( "convertToFloat() key[\(key)]" ) }
        var floatKey : Float = 0.0
            floatKey         = (key  as NSString).floatValue

        if DBUG { println( "getFormattedStringValue() key[\(key)] floatKey[\(floatKey)]" ) }

        var formatter  = NSNumberFormatter()
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            formatter.locale      = NSLocale( localeIdentifier:  "en_US" )
            formatter.usesSignificantDigits = false

        var stringKey : String = formatter.stringFromNumber( floatKey )!

        if DBUG { println( "getFormattedStringValue() key[\(stringKey)]" ) }
        var newString : String = String(map(stringKey.generate()) {
            $0 == "$" ? " " : $0
            })
        if DBUG { println( "getFormattedStringValue() key[\(newString)]" ) }
        var minus : [ String ] = newString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " " ))
        if  minus.count > 1 {
            newString = minus[0] + minus[1]
        }

        if DBUG { println( "getFormattedStringValue() key[\(newString)]" ) }
        return newString
    }

    func getFormattedStringValueNoDecimal( key: NSString ) -> String? {
        var newString       : String = getFormattedStringValue( key )!
        var newString2      : String = ""
        var noDecimalString : String = ""
        
        if newString.hasSuffix( ".00" ) == true {

            let count  = countElements(newString) // string length
            let short  = count - 3
            println( "\(newString)" )
            // var str = "Hello, playground"
            newString2 = newString.substringWithRange(Range<String.Index>(start: advance(newString.startIndex, 0), end: advance(newString.endIndex, -3)))
            return newString2
        } else {
            return newString2
        }
    }

    func getStringValue( key: NSString ) -> String? {
        if DBUG { println( "getStringValue() key[\(key)]" ) }
        var searchKey  = key
        if  searchKey == "Company" { searchKey = "Name" }
        if let theStringValue  = quote["\(searchKey)"] as? String {
           return theStringValue
        } else {
           return "-"
        }
    }


    func convertToFloat( quoteKey: NSString ) -> Float? {
        if DBUG { println( "convertToFloat() key[\(quoteKey)]" ) }
        var aFloat : Float     = 0.0
        var searchKey          = quoteKey
        if  let theStringValue = quote["\(quoteKey)"] as? String {
                aFloat         = (theStringValue as NSString).floatValue
        }
        return aFloat
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

    func getChangeFloat() -> Float {
        var change : Float = convertToFloat( "Change" )!
        return change
    }
    
    func getPrice() -> String {
        return getStringValue( "AskRealtime" )!
    }

    func getPERatio() -> String {
        return getStringValue( "PERatio" )!
    }

    func getDaysRange() -> String {
        var range    : String  = ""
        var daysLow  : String  = self.getFormattedStringValue( getStringValue("DaysLow")! )!
        var daysHigh : String  = self.getFormattedStringValue( getStringValue("DaysHigh")! )!

        range = daysLow + " - " + daysHigh
        return range
    }

    // Created so comma's could be added to the two values that make 'DaysRange, 'DaysLow'
    func getDaysRangeLow() -> String {
        return getStringValue( "DaysLow" )!
    }

    // Created so comma's could be added to the two values that make 'DaysRange, 'DaysHigh'
    func getDaysRangeHigh() -> String {
        return getStringValue( "DaysHigh" )!
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

    func getAverageDailyVolumeNoDecimal() -> String {
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