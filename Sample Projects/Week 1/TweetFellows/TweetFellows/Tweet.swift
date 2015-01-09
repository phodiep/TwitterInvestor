//
//  Tweet.swift
//  TweetFellows
//
//  Created by Bradley Johnson on 1/5/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class Tweet {
  var text : String
  var username : String
  var imageURL : String
  var image : UIImage?
  var id : String
  var favoriteCount : String?
  var userID : String
  
  init( _ jsonDictionary : [String : AnyObject]) {
    self.id = jsonDictionary["id_str"] as String
    self.text = jsonDictionary["text"] as String
    let userDictionary = jsonDictionary["user"] as [String : AnyObject]
    self.userID = userDictionary["id_str"] as String
    self.imageURL = userDictionary["profile_image_url"] as String
   self.username = userDictionary["name"] as String
    println(userDictionary)
    
    //put image download code here, to do it all at once
    
    if jsonDictionary["in_reply_to_user_id"] is NSNull {
      
      println("nsnull")
    }
  }
  
  func updateWithInfo(infoDictionary : [String : AnyObject]) {
    let favoriteNumber = infoDictionary["favorite_count"] as Int
    self.favoriteCount = "\(favoriteNumber)"
  }
}
