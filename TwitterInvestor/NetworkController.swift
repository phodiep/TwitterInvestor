//
//  NetworkController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation

class NetworkController {
    
    var urlSession: NSURLSession
    
    class var sharedInstance : NetworkController {
        struct Static {
            static let instance: NetworkController = NetworkController()
        }
        return Static.instance
    }
    
    init() {
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
    
    
}