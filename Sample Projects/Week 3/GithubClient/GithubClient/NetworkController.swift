//
//  NetworkController.swift
//  GithubClient
//
//  Created by Bradley Johnson on 1/19/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import Foundation


class NetworkController {
  
  var urlSession : NSURLSession
  
  init() {
    let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    
    self.urlSession = NSURLSession(configuration: ephemeralConfig)
    
  }
  
  func fetchRepositoriesForSearchTerm(searchTerm : String, callback : ([AnyObject]?, String) -> (Void)) {
    
//    let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    let url = NSURL(string: "http://127.0.0.1:3000")
    
    let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (data, urlResponse, error) -> Void in
      if error == nil {
        println(urlResponse)
      }
      
    })
    dataTask.resume()
      

    
    
  }
}