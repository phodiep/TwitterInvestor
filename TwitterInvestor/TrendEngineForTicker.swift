//
//  TrendEngineForTicker.swift
//  TwitterInvestor
//
//  Created by Jon Vogel on 1/24/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit


struct Trend{
  //Date and time when the trend was detected
  var startTime: NSDate?
  //Date and time when the trend ended/returned to baseline
  var EndTime: NSDate?
  //Int that will represent the magnitude of the trend
  var trendMagnitude: Int = 0
  //Number of tweet that have made up the trend
  var numberOfTweetsThatRepresentTheTrend: Int?

}

class TrendEngineForTicker{
  
  //MARK: Properties for engine
  var arrayOfAllJSON = [[String:AnyObject]]()
  //Variable to hold the ticker symbol that the class in currently collecting twitter data for.
  var ticker: String?
  //Do we have baseline trend data for this ticker? Or are we going to tell the user that there is no baseline data. We can expect that there will be no baseline data on stocks that are very obscure
  var needsBaseline:Bool = true
  //If we do have baseline data for the tweet then we want to display it as Tweets per hour to the user.
  var tweetsPerHour: Int?
  //If we do have baseline data for this tweet, this data is the date of the oldest and newest tweets we have gotten.
  var idOfNewestTweet: String?
  //Date stamp of newest Tweet
  var dateOfNewestTweet: NSDate?
  //ID of oldest tweet 
  var idOfOldestTweet: String?
  //Date Stamp of oldest tweet
  var dateOfOldestTweet: NSDate?
  
  //Bool to see if stock is trending 
  var isTrending:Bool = false
  //Array of all trends that have occured for this stock.
  var arrayOfTrends = [Trend]()
  
  
  //MARK: Initalizers
  init(tickerSymbol: String, firstJSONBlob: [[String:AnyObject]]){
    self.ticker = tickerSymbol
    //theJSON = stripTweets(firstJSONBlob)
   // println(firstJSONBlob)
    
    if firstJSONBlob.count == 0{
      tweetsPerHour = 0
    }else {
      for item in firstJSONBlob{
        self.arrayOfAllJSON.append(item)
      }
      let newestTweet = firstJSONBlob.first as [String:AnyObject]!
      self.idOfNewestTweet = newestTweet["id_str"] as? String
      self.dateOfNewestTweet = newestTweet["created_at"] as? NSDate
      println(self.dateOfNewestTweet)
      let oldestTweet = firstJSONBlob.last as [String:AnyObject]!
      self.idOfOldestTweet = oldestTweet["id_str"] as? String
     // println(idOfNewestTweet)
      //println(idOfOldestTweet)
      //figureOutAverageInterval(firstJSONBlob)
      buildBackAWeek(self.ticker!, oldestTweetID: self.idOfOldestTweet!)
    }
  }
  
  
  func buildBackAWeek(theTicker: String,oldestTweetID: String){
    let fiveDaysAgo = NSDate(timeIntervalSinceNow: -432000)
   // println(todaysDate)
    
    
    NetworkController.sharedInstance.twitterRequestForSinceID(theTicker, theID: oldestTweetID) { (returnedJSON, error) -> Void in
      
      for item in returnedJSON!{
        self.arrayOfAllJSON.append(item)
      }
      //println(self.arrayOfAllJSON.count)
      for item in self.arrayOfAllJSON{
        println(item["created_at"])
      }
      let oldestTweet = self.arrayOfAllJSON.last as [String:AnyObject]!
      self.idOfOldestTweet = oldestTweet["id_str"] as? String
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
      //println(dateOfTweet)
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
    let arrayOfKeyWords = ["Stock","Market","Money","Mover","investing","DayTrader", "loser", "Gainer", "PreMarket", "Soared", "rating", "buy", "sell", "stock", "chart", "longterm", "Trade","investment"]
    
    
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
  
  func checkForTrend()->Bool{
    
    
    
    
    
    return false
  }
  
  
}