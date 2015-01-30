//
//  TweetsViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/29/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView = UITableView()
    var tweets : [[String:AnyObject]]!
    
    //MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tweets"

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
    
        self.view = self.tableView
    }

    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = TweetCell()
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        

        let currentTweet = tweets[indexPath.row]
        let userDictionary = currentTweet["user"] as [String: AnyObject]
        let tweetDate = dateFormatter.dateFromString(currentTweet["created_at"] as String!)
        dateFormatter.dateFormat = "MM-dd-yy HH:mm"
        
        cell.tweetLabel.text = currentTweet["text"] as String!
        cell.usernameLabel.text = userDictionary["name"] as String!
        cell.dateLabel.text = dateFormatter.stringFromDate(tweetDate!)

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    

    


    
}
