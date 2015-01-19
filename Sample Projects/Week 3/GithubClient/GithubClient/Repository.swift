//
//  Repository.swift
//  GithubClient
//
//  Created by Bradley Johnson on 1/19/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import Foundation


struct Repository {
  let name : String
  let author : String
  
  init(jsonDictionary : [String : AnyObject]) {
    self.name = jsonDictionary["name"] as String
    self.author = "Brad"
  }
}
