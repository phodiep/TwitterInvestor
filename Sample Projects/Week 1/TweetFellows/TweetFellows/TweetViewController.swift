//
//  TweetViewController.swift
//  TweetFellows
//
//  Created by Bradley Johnson on 1/8/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
  
  var tweet : Tweet!

  @IBOutlet weak var favoritesLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  var networkController : NetworkController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = tweet.image
        self.tweetTextLabel.text = tweet.text
        self.usernameLabel.text = tweet.username
        // Do any additional setup after loading the view.
      
      self.networkController.fetchInfoForTweet(tweet.id, completionHandler: { (infoDictionary, errorDescription) -> () in
        println(infoDictionary)
        if errorDescription == nil {
        self.tweet.updateWithInfo(infoDictionary!)
          self.favoritesLabel.text = self.tweet.favoriteCount
        }
      })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
