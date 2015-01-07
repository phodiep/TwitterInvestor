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
  
  init( _ jsonDictionary : [String : AnyObject]) {
    self.text = jsonDictionary["text"] as String
    let userDictionary = jsonDictionary["user"] as [String : AnyObject]
    self.imageURL = userDictionary["profile_image_url"] as String
   self.username = userDictionary["name"] as String
    println(userDictionary)
    
    if jsonDictionary["in_reply_to_user_id"] is NSNull {
      
      println("nsnull")
    }
  }
}
