//
//  Tweet.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation

class Tweet {
    
    var id: String
    var text: String
    
    init(jsonDictionary: [String: AnyObject]) {
        self.id = jsonDictionary["id"] as String
        self.text = jsonDictionary["text"] as String
        
    }
}