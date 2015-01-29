//
//  NetworkController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation
import Social
import Accounts

class NetworkController {

    let DBUG = false
  
  
  
    var arrayOfAllTweetJSON = [[String:AnyObject]]()
    //Variable for the ID of the oldest Tweet
    var idOfOldestTweet: String?
    //Date Stamp of oldest tweet
    var dateOfOldestTweet: NSDate?

    //URLSession Variable
    var urlSession: NSURLSession
    var twitterAccount: ACAccount?
  
    //Shared Instance of Network controller. (Singleton pattern)
    class var sharedInstance : NetworkController {
        struct Static {
            static let instance: NetworkController = NetworkController()
        }
        return Static.instance
    }
  
  
  
    init() {
      //Make sure the URL session will save data on RAM
        let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        self.urlSession = NSURLSession(configuration: ephemeralConfig)
    }

    /**
    * @abtract A really simple way to calculate the sum of two numbers.
    * @param firstNumber An NSInteger to be used in the summation of two numbers
    * @param secondNumber The second half of the equation.
    * @return The sum of the two numbers passed in.
    *
    * @discussion A really simple way to calculate the sum of two numbers.

    *  https://www.quandl.com/resources/api-for-stock-data
    *  Quandl is the easiest way to find, use and share numerical data. Search millions of datasets.
    *  Instantly download, graph, share or access via API.
    *  for example: https://www.quandl.com/api/v1/datasets/WIKI/CRIS.json
    */
    func getStockInfoFromYahoo(ticker: String, stockLookup: (Stock?, NSError?) -> () ) {

        if DBUG { println( "getStockInfoFromYahoo() ticker[\(ticker)]" ) }

        let url = NSURL( string:
        "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22\(ticker)%22)&env=store://datatables.org/alltableswithkeys&format=json" )

        if DBUG {println( "url[\(url)]" ) }

        let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler : { (jsonData, response, error) -> Void in
            
            var stock: Stock?
            var errorString: NSString
            
            if error == nil && jsonData != nil {
                if let urlResponse = response as? NSHTTPURLResponse {
                    let returnCode = urlResponse.statusCode
                    println( "returnCode[\(returnCode)] [\(urlResponse.statusCode)]" )
                    switch returnCode {
                    case 200...299:
                        let jsonDictionary = NSJSONSerialization.JSONObjectWithData( jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil ) as [String : AnyObject]
//                        println( jsonDictionary )
                        
                        if jsonDictionary.count == 1 {
                            
                            var stockData: Stock = Stock( jsonDictionary: jsonDictionary )
//                            trailingClosure(TrendEngineForTicker(tickerSymbol: tickerSymbol,firstJSONBlob: arrayOfResults),nil
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                stockLookup( stockData, nil  )
                            })
                        }
                        
                    default:
                        errorString = "\(urlResponse.statusCode) error ... \(error)"
                    }
                }
            }
        })
        dataTask.resume()
    }
  
  
  func twitterRequestForSinceID(tickerSymbol: String, theID: String, completion: ([[String:AnyObject]]?,NSError?)->Void){
    let myAccountStore = ACAccountStore()
    //Create a variable of type ACAccountType by using the method accountTypeWithAccountTypeIdentifier thats in ACAccountStore
    let myAccountType = myAccountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    //this starts a new thread to access the account and do something with it in the clsure statement
    myAccountStore.requestAccessToAccountsWithType(myAccountType, options: nil) { (gotit: Bool , error: NSError!) -> Void in
      //If ACAccountStore was able to access the account the gotit boolean in the cluses will be true or false
      if gotit{
        //A user can have multiple accounts with each of these services, we load them all into the array.
        let accountsArray = myAccountStore.accountsWithAccountType(myAccountType)
        //make sure we got at least one account
        if accountsArray.isEmpty == false{
          //We just want the first account that is stored in the array of account (there might only be one)
          self.twitterAccount = accountsArray[0] as? ACAccount
          //return twitterAccount
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=%23\(tickerSymbol)&count=100&max_id=\(theID)")
          //A request of type SLRequest, this starts a new thread.
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          //Set the SLRequests account property to the twitter accont that we got from the array of accounts
          twitterRequest.account = self.twitterAccount
          //call the performRequestWithHandler method on SLRequest (this starts a new thread) paramaters are the data that will be returned, the response code, and then an error
          twitterRequest.performRequestWithHandler({ (jsonData, responseCode, error) -> Void in
            //make a switch statement on the response code. You will probably get a basic server response code
            switch responseCode.statusCode{
              //If the response is good
            case 200...299:
              //create an array of json data that is typed as an array of [AnyObject]
              //println(jsonData)
              if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [String: AnyObject] {
                if let arrayOfResults = jsonDictionary["statuses"] as? [[String:AnyObject]]{
                 // NSOperationQueue.currentQueue()?.name = "TwitterRequestQueue"
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion(arrayOfResults,nil)
                  })
                }
              }
              //If response is bad
            case 400...599:
              println(error)
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(nil, error)
              })
            default:
              println("\(responseCode.statusCode)")
            }
          })
        }
      }
    }

  }
  
  
  func twitterRequestForAfterID(theTicker: String, theID: String, Completion: ([[String:AnyObject]]?, NSError?)->Void){
    let myAccountStore = ACAccountStore()
    //Create a variable of type ACAccountType by using the method accountTypeWithAccountTypeIdentifier thats in ACAccountStore
    let myAccountType = myAccountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    //this starts a new thread to access the account and do something with it in the clsure statement
    myAccountStore.requestAccessToAccountsWithType(myAccountType, options: nil) { (gotit: Bool , error: NSError!) -> Void in
      //If ACAccountStore was able to access the account the gotit boolean in the cluses will be true or false
      if gotit{
        //A user can have multiple accounts with each of these services, we load them all into the array.
        let accountsArray = myAccountStore.accountsWithAccountType(myAccountType)
        //make sure we got at least one account
        if accountsArray.isEmpty == false{
          //We just want the first account that is stored in the array of account (there might only be one)
          self.twitterAccount = accountsArray[0] as? ACAccount
          //return twitterAccount
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=%23\(theTicker)&count=100&since_id=\(theID)")
          //A request of type SLRequest, this starts a new thread.
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          //Set the SLRequests account property to the twitter accont that we got from the array of accounts
          twitterRequest.account = self.twitterAccount
          //call the performRequestWithHandler method on SLRequest (this starts a new thread) paramaters are the data that will be returned, the response code, and then an error
          twitterRequest.performRequestWithHandler({ (jsonData, responseCode, error) -> Void in
            //make a switch statement on the response code. You will probably get a basic server response code
            switch responseCode.statusCode{
              //If the response is good
            case 200...299:
              //create an array of json data that is typed as an array of [AnyObject]
              //println(jsonData)
              if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [String: AnyObject] {
                if let arrayOfResults = jsonDictionary["statuses"] as? [[String:AnyObject]]{
                  //NSOperationQueue.currentQueue()?.name = "TwitterRequestQueue"
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    Completion(arrayOfResults,nil)
                  })
                }
              }
              //If response is bad
            case 400...599:
              println(error)
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                Completion(nil, error)
              })
            default:
              println("\(responseCode.statusCode)")
            }
          })
        }
      }
    }
  }
  
  
  func overloadTwitter(tickerSymbol: String, trailingClosure: (TrendEngineForTicker?,NSError?)->Void){
    arrayOfAllTweetJSON = [[String:AnyObject]]()
    self.idOfOldestTweet = nil
    self.dateOfOldestTweet = nil
    let myAccountStore = ACAccountStore()
    //Create a variable of type ACAccountType by using the method accountTypeWithAccountTypeIdentifier thats in ACAccountStore
    let myAccountType = myAccountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    //this starts a new thread to access the account and do something with it in the clsure statement
    myAccountStore.requestAccessToAccountsWithType(myAccountType, options: nil) { (gotit: Bool , error: NSError!) -> Void in
      if gotit{
        //A user can have multiple accounts with each of these services, we load them all into the array.
        let accountsArray = myAccountStore.accountsWithAccountType(myAccountType)
        //make sure we got at least one account
        if accountsArray.isEmpty == false{
          //We just want the first account that is stored in the array of account (there might only be one)
          self.twitterAccount = accountsArray[0] as? ACAccount
          //return twitterAccount
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=%23\(tickerSymbol)&count=100")//q=%SIRI")
          //A request of type SLRequest, this starts a new thread.
          //var trendEngine: TrendEngineForTicker?
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          //Set the SLRequests account property to the twitter accont that we got from the array of accounts
          twitterRequest.account = self.twitterAccount
          //call the performRequestWithHandler method on SLRequest (this starts a new thread) paramaters are the data that will be returned, the response code, and then an error
          twitterRequest.performRequestWithHandler({ (jsonData, responseCode, error) -> Void in
            println(error)
            //make a switch statement on the response code. You will probably get a basic server response code
            switch responseCode.statusCode {
              //If the response is good
            case 200...299:
              //create an array of json data that is typed as an array of [AnyObject]
              //println(jsonData)
              if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [String: AnyObject] {
                if let arrayOfResults = jsonDictionary["statuses"] as? [[String:AnyObject]]{
                  //Check to See if any results got returned. Sometimes a hashtag just never has any tweets
                  if arrayOfResults.count == 0{
                    //Reture an trendengine that has a base line of zero
                    trailingClosure(TrendEngineForTicker(tickerSymbol: tickerSymbol, JSONBlob: self.arrayOfAllTweetJSON), nil)
                  }else{
                    //append the results to the global arrayofallTweetData
                    for item in arrayOfResults{
                      self.arrayOfAllTweetJSON.append(item)
                    }
                    //Set the formatting options for Dates
                    let format = NSDateFormatter()
                    format.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
                    //set the ID and Date of the oldest Tweets
                    let oldestTweet = self.arrayOfAllTweetJSON.last as [String:AnyObject]!
                    self.idOfOldestTweet = oldestTweet["id_str"] as? String
                    self.dateOfOldestTweet = format.dateFromString(oldestTweet["created_at"] as String!)
                    //Call get more tweets this is a recursive function that will keep appending to arrayof alljson and updating hte oldest date untill 5 days ago is reached.
                    self.getMoreTweets(tickerSymbol, oldestTweetID: self.idOfOldestTweet!, completion: { (returnedBool) -> Void in
                      //When we come back out of the recursion all the work of appending to the array should be complete and we check for a true.
                      if returnedBool == true {
                        println(self.arrayOfAllTweetJSON.count)
                        //Add the trailing closure to the main queue and return a trend engine that is initalized with the arrayOFALLTweets that has been built recursivly.
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                          trailingClosure(TrendEngineForTicker(tickerSymbol: tickerSymbol, JSONBlob: self.arrayOfAllTweetJSON), nil)
                        })
                      }
                    })
                  }
                }
              }
              //If response is bad
            case 400...599:
              //println(responseCode.statusCode)
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                trailingClosure(nil, error)
              })
            default:
              println("\(responseCode.statusCode)")
            }
          })
          //end accounts array is empty check
        }
        //got it check
      }
      //end account store request
    }
    //end function
  }

  func getMoreTweets(theTicker: String,oldestTweetID: String, completion: (Bool)->Void){
    
    let fiveDaysAgo = NSDate(timeIntervalSinceNow: -432000)
    
    if self.dateOfOldestTweet?.compare(fiveDaysAgo) == NSComparisonResult.OrderedDescending{
      NetworkController.sharedInstance.twitterRequestForSinceID(theTicker, theID: oldestTweetID) { (returnedJSON, error) ->   Void in
        for item in returnedJSON!{
          self.arrayOfAllTweetJSON.append(item)
        }
        let oldestTweet = self.arrayOfAllTweetJSON.last as [String:AnyObject]!
        self.idOfOldestTweet = oldestTweet["id_str"] as? String
        let format = NSDateFormatter()
        format.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        self.dateOfOldestTweet = format.dateFromString(oldestTweet["created_at"] as String!)
        //completion(format.dateFromString(oldestTweet["created_at"] as String!)!)
        self.dateOfOldestTweet = format.dateFromString(oldestTweet["created_at"] as String!)
        self.getMoreTweets(theTicker, oldestTweetID: self.idOfOldestTweet!, completion: { (theBool) -> Void in
          
          completion(theBool)
          
        })
      }
    }else{
      completion(true)
      return
    }
  }
  
    
}