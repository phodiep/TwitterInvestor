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
  var trendMagnitude: Double = 0
  //Number of tweet that have made up the trend
  var numberOfTweetsThatRepresentTheTrend: Int?

  init(){
    
  }
}

class TrendEngineForTicker{
  
  //MARK: Properties for engine
  var arrayOfAllJSON = [[String:AnyObject]]()
  //Variable to hold the ticker symbol that the class in currently collecting twitter data for.
  var ticker: String?
  //Do we have baseline trend data for this ticker? Or are we going to tell the user that there is no baseline data. We can expect that there will be no baseline data on stocks that are very obscure
  var needsBaseline:Bool = true
  //If we do have baseline data for the tweet then we want to display it as Tweets per hour to the user.
  var tweetsPerHour: Double?
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
  var tweetText: String?
  var arrayOfTrends = [Trend]()
  var tweetBuckets : [AnyObject]?
  var plotView: UIView?
  
  
  //MARK: Initalizers
  init(tickerSymbol: String, JSONBlob: [[String:AnyObject]]){
    //Set the ticker property to the ticker symbol that is passed in
    self.ticker = tickerSymbol
    //If no tweets were found we don't neew to do anything
    if JSONBlob.count == 0{
      tweetsPerHour = 0
    }else {
      //If we find tweets then we strip them all and append the remaining to the array of All JSON
      self.arrayOfAllJSON = self.stripTweets(JSONBlob)
      for item in JSONBlob{
        println(item["id_str"])
      }
      println("____________")
      for item in self.arrayOfAllJSON{
        println(item["id_str"])
      }
      //Set the formatting options for the Oldest and newest tweets
      let format = NSDateFormatter()
      format.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
      //Set the Id and Date of newest tweet.
      let newestTweet = arrayOfAllJSON.first as [String:AnyObject]!
      self.idOfNewestTweet = newestTweet["id_str"] as? String
      self.dateOfNewestTweet = format.dateFromString(newestTweet["created_at"] as String!)
      //set the ID and Date of the oldest Tweets
      let oldestTweet = arrayOfAllJSON.last as [String:AnyObject]!
      self.idOfOldestTweet = oldestTweet["id_str"] as? String
      self.dateOfOldestTweet = format.dateFromString(oldestTweet["created_at"] as String!)
      //Set tweets per hour
      self.tweetsPerHour = self.figureOutAverageInterval(self.arrayOfAllJSON)
      //Set the needs baseline property to nil.
      self.needsBaseline = false
      self.tweetBuckets = self.putTweetsInBucket(self.arrayOfAllJSON)
      self.setPlotView()
    }
  }
  
  
  func getMoreTweets(theTicker: String,oldestTweetID: String, completion: (Bool)->Void){
    
    let fiveDaysAgo = NSDate(timeIntervalSinceNow: -430000)
    
    if self.dateOfOldestTweet?.compare(fiveDaysAgo) == NSComparisonResult.OrderedDescending{
      NetworkController.sharedInstance.twitterRequestForSinceID(theTicker, theID: oldestTweetID) { (returnedJSON, error) ->   Void in
      
        for item in returnedJSON!{
          self.arrayOfAllJSON.append(item)
        }
        let oldestTweet = self.arrayOfAllJSON.last as [String:AnyObject]!
        self.idOfOldestTweet = oldestTweet["id_str"] as? String
        let format = NSDateFormatter()
        format.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        self.dateOfOldestTweet = format.dateFromString(oldestTweet["created_at"] as String!)
        //completion(format.dateFromString(oldestTweet["created_at"] as String!)!)
        self.dateOfOldestTweet = format.dateFromString(oldestTweet["created_at"] as String!)
        self.getMoreTweets(self.ticker!, oldestTweetID: self.idOfOldestTweet!, completion: { (theBool) -> Void in
          
          completion(theBool)
          
        })
      }
    }else{
      completion(true)
      return
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
    return (totalIntervalTime/Double(arrayOfTimeIntervals.count))/60
  }
  
  
  //Funciton to strip tweets that have nothing to do with investing.
  private func stripTweets(JSONBlob: [[String:AnyObject]])->[[String:AnyObject]]{
    var JSON = JSONBlob
    //make sure all lower case
    let arrayOfKeyWords = ["stock","market","money","mover","investing","daytrader", "loser", "gainer", "premarket", "soared", "rating", "buy", "sell", "stock", "chart", "longterm", "trade","investment", "long", "short"]
    
    
    
    var investmentRelatedTweets = [[String:AnyObject]]()
    
    for var i = 0; i < JSON.count; ++i {
      let currentTweet = JSON[i]
      var text = currentTweet["text"] as String
      let entities = currentTweet["entities"] as [String:AnyObject]
      let hashTags = entities["hashtags"] as [AnyObject]
      var arrayOfHashTags = [String]()
      for o in hashTags{
        arrayOfHashTags.append(o["text"] as String!)
        //println(o)
      }
      for item in arrayOfHashTags{
        text = "\(text) \(item)"
      }
      
      //revisit this logic
      for k in arrayOfKeyWords{
          if text.lowercaseString.rangeOfString(k) != nil {
            investmentRelatedTweets.append(JSON[i])
            break
          }
      }
    }
    self.tweetBuckets = putTweetsInBucket(investmentRelatedTweets)
    return investmentRelatedTweets
  }

    
    func putTweetsInBucket(theJSON: [[String:AnyObject]])->[AnyObject]{
        //    var theMovingDate = NSDate(timeInterval: 3600, sinceDate: self.dateOfOldestTweet as NSDate!)
        var theMovingDate = NSDate(timeInterval: 3600, sinceDate: NSDate(timeIntervalSinceNow: -432000))
        let format = NSDateFormatter()
        format.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        var masterBucket = [AnyObject]()
        var bucket = [[String:AnyObject]]()
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        
        for var i = theJSON.count; i > 0; --i{
            let oneTweet = theJSON[i-1]
            var dateFromOneTweet = format.dateFromString(oneTweet["created_at"] as String!)
            
            if compareDates(dateFromOneTweet!, laterDate: theMovingDate){
                bucket.append(oneTweet)
            }else{
                masterBucket.append(["date": dateFormatter.stringFromDate(theMovingDate), "count": bucket.count])
                
                
                bucket = [[String:AnyObject]]()
                theMovingDate = NSDate(timeInterval: 3600, sinceDate: theMovingDate)
                while !(compareDates(dateFromOneTweet!, laterDate: theMovingDate)){
                    masterBucket.append(["date": dateFormatter.stringFromDate(theMovingDate), "count": bucket.count])
                    bucket = [[String:AnyObject]]()
                    theMovingDate = NSDate(timeInterval: 3600, sinceDate: theMovingDate)
                }
                bucket.append(oneTweet)
            }
        }
        masterBucket.append(["date": dateFormatter.stringFromDate(theMovingDate), "count": bucket.count])
                
        return masterBucket
        
    }

  
  
  func compareDates(earlierDate: NSDate, laterDate: NSDate)->Bool{
    if earlierDate.compare(laterDate) == NSComparisonResult.OrderedAscending{
      return true
    }
    if earlierDate.compare(laterDate) == NSComparisonResult.OrderedSame{
      return true
      
      
    }
    return false
  }

  func setPlotView(){
    self.plotView = TrendPlot(frame: CGRectZero, data: self.tweetBuckets!)
  }
  
  
  
  
  
  func checkForTrend()->Double?{
    var magnitudeOfTrend: Double?
    if self.needsBaseline == true {
      
    }else{
      NetworkController.sharedInstance.twitterRequestForAfterID(self.ticker!, theID: self.idOfNewestTweet!) { (returnedJSON, error) -> Void in
        let JSON = self.stripTweets(returnedJSON!)
        let averageIntervalForNewTweets = self.figureOutAverageInterval(JSON)
        switch (averageIntervalForNewTweets-self.tweetsPerHour!)/self.tweetsPerHour!{
        
        case 0...0.2:
          var newTrend = Trend()
          newTrend.trendMagnitude = (averageIntervalForNewTweets-self.tweetsPerHour!)/self.tweetsPerHour!
          magnitudeOfTrend = newTrend.trendMagnitude
        case 0.3...0.5:
          let date = NSDate()
          var newTrend = Trend()
          newTrend.startTime = date
          newTrend.trendMagnitude = (averageIntervalForNewTweets-self.tweetsPerHour!)/self.tweetsPerHour!
          newTrend.numberOfTweetsThatRepresentTheTrend = JSON.count
          magnitudeOfTrend = newTrend.trendMagnitude
        case 0.6...1:
          let date = NSDate()
          var newTrend = Trend()
          newTrend.startTime = date
          newTrend.trendMagnitude = (averageIntervalForNewTweets-self.tweetsPerHour!)/self.tweetsPerHour!
          newTrend.numberOfTweetsThatRepresentTheTrend = JSON.count
          magnitudeOfTrend = newTrend.trendMagnitude
        case 1.1...99:
          let date = NSDate()
          var newTrend = Trend()
          newTrend.startTime = date
          newTrend.trendMagnitude = (averageIntervalForNewTweets-self.tweetsPerHour!)/self.tweetsPerHour!
          newTrend.numberOfTweetsThatRepresentTheTrend = JSON.count
          magnitudeOfTrend = newTrend.trendMagnitude
        default:
          magnitudeOfTrend = 0
        }
        for item in JSON{
          self.arrayOfAllJSON.insert(item, atIndex: 0)
        }
        
        
        
      }
    }
    return magnitudeOfTrend
  }
}