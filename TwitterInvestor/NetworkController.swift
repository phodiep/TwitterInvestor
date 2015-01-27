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
    
    func getStockInfoFromYahoo(ticker: String, completionHandler: ([Stock]?, String?) -> () ) {
        let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20%28%22\(ticker)%22%29&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")
        
        let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (jsonData, response, error) -> Void in
            var stock: Stock?
            var errorString: String?
            
            if error == nil && jsonData != nil {
                if let urlResponse = response as? NSHTTPURLResponse {
                    switch urlResponse.statusCode {
                    case 200...299:
                        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as [String: AnyObject]
                        let resultsDictionary = jsonDictionary["results"] as [String: AnyObject]
                        println(resultsDictionary)
                    default:
                        errorString = "\(urlResponse.statusCode) error ... \(error)"
                    }
                }
            }
        })
        dataTask.resume()
    }
  
  
  func getInitialTwitterRequest(tickerSymbol: String, trailingClosure: (TrendEngineForTicker?,NSError?)->Void) {
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
          
          //This is the URL for the JSON twitter request for hometimeline
          //https://stream.twitter.com/1.1/statuses/firehose.json
          //https://api.twitter.com/1.1/search/tweets.json?q=%23yolo&count=200&src=typd
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/search/tweets.json?q=%23\(tickerSymbol)&count=100")//q=%SIRI")
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
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    trailingClosure(TrendEngineForTicker(tickerSymbol: tickerSymbol,firstJSONBlob: arrayOfResults),nil)
                  })
                }
              }
              //If response is bad
            case 400...599:
              println(error)
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                trailingClosure(nil, error)
              })
            default:
              println("\(responseCode.statusCode)")
            }
          })
        }
      }
    }
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
          
          //This is the URL for the JSON twitter request for hometimeline
          //https://stream.twitter.com/1.1/statuses/firehose.json
          //https://api.twitter.com/1.1/search/tweets.json?q=%23yolo&count=200&src=typd
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
                  NSOperationQueue.currentQueue()?.name = "TwitterRequestQueue"
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
  
  
  func getJSONToCheckForTrend(){
    
    
    
  }
  
  
  
  
  
  
    
    
}