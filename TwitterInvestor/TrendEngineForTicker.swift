//
//  TrendEngineForTicker.swift
//  TwitterInvestor
//
//  Created by Jon Vogel on 1/24/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

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
    
    let lastTweet = firstJSONBlob.last
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
    let dateAsString = lastTweet!["created_at"] as String!
    let oldestDate = dateFormat.dateFromString(dateAsString)
    println(oldestDate!)
    for o in firstJSONBlob{
      println(o["created_at"]!)
      //println(o["text"]!)
    }
    
    
    
  }
  
  
  //MARK: Funcitons
  
  
  
}