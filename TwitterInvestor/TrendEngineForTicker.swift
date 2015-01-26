//
//  TrendEngineForTicker.swift
//  TwitterInvestor
//
//  Created by Jon Vogel on 1/24/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit


struct Trend{
  var startTime: NSDate?
  var EndTime: NSDate?
  var trendMagnitude: Int = 0
  
  
  
}

class TrendEngineForTicker{
  
  //MARK: Properties for engine
  var theJSON = [[String:AnyObject]]()
  //Variable to hold the ticker symbol that the class in currently collecting twitter data for.
  var ticker: String?
  //Do we have baseline trend data for this ticker? Or are we going to tell the user that there is no baseline data. We can expect that there will be no baseline data on stocks that are very obscure
  var needsBaseline:Bool = true
  //If we do have baseline data for the tweet then we want to display it as Tweets per hour to the user.
  var tweetsPerHour: Int?
  //If we do have baseline data for this tweet, this data is the date of the oldest tweet we have gotten.
  var idOfNewestTweet: NSDate?
  //Bool to see if stock is trending 
  var isTrending:Bool = false
  //Int that will represent the magnitude of the trend 
  var trendMagnitude: Int = 0
  
  
  
  //MARK: Initalizers
  init(tickerSymbol: String, firstJSONBlob: [[String:AnyObject]]){
    self.ticker = tickerSymbol
    
    //theJSON = stripTweets(firstJSONBlob)
   
    
    if firstJSONBlob.count == 0{
      tweetsPerHour = 0
    }else {
      println(figureOutAverageInterval(firstJSONBlob))
    }
  }
  
  
  //MARK: Funcitons
  //Function to get average tweet time interval.
  private func figureOutAverageInterval(JSONBlob: [[String:AnyObject]])->Double{
    var arrayOfDatesFromJSON = [NSDate]()
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    for o in JSONBlob{
      let dateOfTweet = dateFormat.dateFromString(o["created_at"] as String)
      arrayOfDatesFromJSON.append(dateOfTweet!)
    }
    
    var arrayOfTimeIntervals = [NSTimeInterval]()
    for var i = 0; i < arrayOfDatesFromJSON.count; ++i{
      if arrayOfDatesFromJSON[i] != arrayOfDatesFromJSON.last {
        let TI = arrayOfDatesFromJSON[i].timeIntervalSinceDate(arrayOfDatesFromJSON[i+1]) as Double
        arrayOfTimeIntervals.append(TI)
      }
    }
    
    var totalIntervalTime:Double = 0
    for number in arrayOfTimeIntervals{
      totalIntervalTime = totalIntervalTime + number
    }
    println(arrayOfDatesFromJSON.count)
    return (totalIntervalTime/Double(arrayOfTimeIntervals.count))
  }
  
  
  //Funciton to strip tweets that have nothing to do with investing.
  private func stripTweets(JSONBlob: [[String:AnyObject]])->[[String:AnyObject]]{
    var JSON = JSONBlob
    let arrayOfKeyWords = ["Stock","Market","Money","Mover","investing","DayTrader", "loser", "Gainer", "PreMarket", "Soared", "rating", "buy", "sell"]
    
    
    for var i = 0; i < JSON.count; ++i{
      let currentTweet = JSON[i]
      let text = currentTweet["text"] as String
      let entities = currentTweet["entities"] as [String:AnyObject]
      let hashTags = entities["hashtags"] as [AnyObject]
      var arrayOfHashTags = [String]()
      for o in hashTags{
        arrayOfHashTags.append(o["text"] as String!)
      }
      for k in arrayOfKeyWords{
        if text.lowercaseString.rangeOfString(k) == nil{
          JSON.removeAtIndex(i)
        }
      }
    }
    return JSON
  }
  
  func checkForTrend(){
    
    
    
    
  }
  
  
}