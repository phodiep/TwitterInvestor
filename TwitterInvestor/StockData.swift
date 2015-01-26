//
//  StockData.swift
//  TwitterInvestor
//
//  Created by Gru on 01/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class StockData {

    var ticker: String?

    init( tickerSymbol: String, JSONBlob: NSData ) { self.ticker = tickerSymbol

        let jsonDictionary = NSJSONSerialization.JSONObjectWithData( JSONBlob, options: nil, error: nil) as [String : AnyObject]

        let stockInfo = jsonDictionary
        println( jsonDictionary )

/*        for data in jsonDictionary {
            print( data["symbol"]! )
        } */

    }
}

/*
class TrendEngineForTicker{

    //MARK: Properties for engine
    //Variable to hold the ticker symbol that the class in currently collecting twitter data for.
    var ticker: String?
    //Do we have baseline trend data for this ticker?
    var needsBaseline:Bool = true
    //If we do have baseline data for this tweet, this data is the date of the oldest tweet we have gotten.
    var dateOfOldestTweet: NSDate?



    //MARK: Initalizers
    init(tickerSymbol: String, firstJSONBlob: [[String:AnyObject]]){
        self.ticker = tickerSymbol

        let dateFormat = NSDateFormatter()
        let lastTweet = firstJSONBlob.last as [String:AnyObject]!
        dateFormat.dateFromString(lastTweet["created_at"] as String)
        //self.dateOfOldestTweet = NSDate(timeInterval: 0.0, sinceDate: dateFormat)

        for o in firstJSONBlob{
            println(o["created_at"]!)
            //println(o["text"]!)
        }
        
        
        
    }
    
    
    //MARK: Funcitons
    

}
*/

/**


http:// query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22AAPL%22)&env=store://datatables.org/alltableswithkeys&format=json

{"query":{"count":1,"created":"2015-01-24T07:51:22Z","lang":"en-US","results":{"quote":{"symbol":"AAPL","Ask":null,"AverageDailyVolume":"48385500","Bid":"112.86","AskRealtime":"0.00","BidRealtime":"112.86","BookValue":"19.015","Change_PercentChange":"+0.58 - +0.52%","Change":"+0.58","Commission":null,"Currency":"USD","ChangeRealtime":"+0.58","AfterHoursChangeRealtime":"N/A - N/A","DividendShare":"1.8457","LastTradeDate":"1/23/2015","TradeDate":null,"EarningsShare":"6.45","ErrorIndicationreturnedforsymbolchangedinvalid":null,"EPSEstimateCurrentYear":"7.84","EPSEstimateNextYear":"8.61","EPSEstimateNextQuarter":"2.01","DaysLow":"111.53","DaysHigh":"113.75","YearLow":"70.5071","YearHigh":"119.75","HoldingsGainPercent":"- - -","AnnualizedGain":null,"HoldingsGain":null,"HoldingsGainPercentRealtime":"N/A - N/A","HoldingsGainRealtime":null,"MoreInfo":"cnsprmiIed","OrderBookRealtime":null,"MarketCapitalization":"662.6B","MarketCapRealtime":null,"EBITDA":"60.449B","ChangeFromYearLow":"+42.4729","PercentChangeFromYearLow":"+60.24%","LastTradeRealtimeWithTime":"N/A - <b>112.98</b>","ChangePercentRealtime":"N/A - +0.52%","ChangeFromYearHigh":"-6.77","PercebtChangeFromYearHigh":"-5.65%","LastTradeWithTime":"Jan 23 - <b>112.98</b>","LastTradePriceOnly":"112.98","HighLimit":null,"LowLimit":null,"DaysRange":"111.53 - 113.75","DaysRangeRealtime":"N/A - N/A","FiftydayMovingAverage":"110.641","TwoHundreddayMovingAverage":"104.383","ChangeFromTwoHundreddayMovingAverage":"+8.597","PercentChangeFromTwoHundreddayMovingAverage":"+8.24%","ChangeFromFiftydayMovingAverage":"+2.339","PercentChangeFromFiftydayMovingAverage":"+2.11%","Name":"Apple Inc.","Notes":null,"Open":"112.32","PreviousClose":"112.40","PricePaid":null,"ChangeinPercent":"+0.52%","PriceSales":"3.61","PriceBook":"5.91","ExDividendDate":"Nov  6","PERatio":"17.43","DividendPayDate":"Nov 13","PERatioRealtime":null,"PEGRatio":"1.20","PriceEPSEstimateCurrentYear":"14.34","PriceEPSEstimateNextYear":"13.05","Symbol":"AAPL","SharesOwned":null,"ShortRatio":"1.30","LastTradeTime":"4:00pm","TickerTrend":"&nbsp;=-====&nbsp;","OneyrTargetPrice":"123.33","Volume":"46464828","HoldingsValue":null,"HoldingsValueRealtime":null,"YearRange":"70.5071 - 119.75","DaysValueChange":"- - +0.52%","DaysValueChangeRealtime":"N/A - N/A","StockExchange":"NasdaqNM","DividendYield":"1.64","PercentChange":"+0.52%"}}}}
 */