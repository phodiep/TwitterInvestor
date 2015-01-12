//
//  ViewController.swift
//  TweetFellows
//
//  Created by Bradley Johnson on 1/5/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var tweets = [Tweet]()
  let networkController = NetworkController()

  func doSomething() -> String {
    println("brad")
    return "Brad"
  }
  
  //MARK: ViewController LifeCycle
   override func viewDidLoad() {
    super.viewDidLoad()
    
    self.doSomething()
    
    
      
    //    if let jsonPath = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
    
//      if let jsonData = NSData(contentsOfFile: jsonPath) {
//        var error : NSError?
//        if let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error:&error) as? [AnyObject] {
//    
//          for object in jsonArray {
//            if let jsonDictionary = object as? [String : AnyObject] {
//              let tweet = Tweet(jsonDictionary)
//              self.tweets.append(tweet)
//            }
//          }
//        }
//      } else {
//        println("getting data from path failed")
//      }
    //}
    //println(self.tweets.count)
    self.tableView.dataSource = self
    self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
    self.tableView.delegate = self
    self.tableView.estimatedRowHeight = 144
    self.tableView.rowHeight = UITableViewAutomaticDimension
    
    self.networkController.fetchHomeTimeline { (tweets, errorString) -> () in
      if errorString == nil {
        self.tweets = tweets!
        self.tableView.reloadData()
      } else {
        //show user alert view telling them it didnt work
      }
    
    
    // Do any additional setup after loading the view, typically from a nib.
//    

   
  }
  }
//  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
//    let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEET_VC") as UIViewController
//    self.navigationController?.pushViewController(tweetVC, animated: true)
    
  }
  
  //MARK: UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.tweets.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
      //cell.backgroundColor = UIColor.blueColor()
    let tweet = self.tweets[indexPath.row]
    //cell.textLabel?.text = tweet.text
    cell.tweetLabel.text = tweet.text
    cell.usernameLabel.text = tweet.username
    if tweet.image == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> () in
//        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        cell.tweetImageView.image = tweet.image
      })
    } else {
      cell.tweetImageView.image = tweet.image
    }
    return cell
  }
  
  //MARK: UITableViewDelegate
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println(indexPath.row)
    
        let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEET_VC") as TweetViewController
    tweetVC.networkController = self.networkController
    tweetVC.tweet = self.tweets[indexPath.row]
      self.navigationController?.pushViewController(tweetVC, animated: true)
    
  }
}

