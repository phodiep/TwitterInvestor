//
//  HelpViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    let helpText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Help"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(helpText)

        self.setHelpText()
        
        self.helpText.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.helpText.font = UIFont.systemFontOfSize(16)
        self.helpText.scrollEnabled = true
        
        let views = ["helpText":helpText]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[helpText]|",
            options: nil, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[helpText]|",
            options: nil, metrics: nil, views: views))
    }

    func setHelpText() {
      helpText.text = "Purpose:\n\tThe purpose of this app is to provide you with trend information specific to a stock of your choice from twitter. We think that this is a clever and unique approach to gather data for a stock that you are interested in. \n\nSecurity:\n\tThis app is very secure. We access your twitter account from your phones built in twitter log in. Not a lot of people know that you don’t have to have the twitter app installed to login on your phone. In your phone setting there is an item called Twitter that allows you to add an account. This is possible through an agreement between apple and twitter. This puts the security of the app on the same level as apple and twitter.\n\nUse:\n\tSince you have already found this help page we assume you know about the other option “Search.” If you press on Search you have the ability to search for a particular stock using its ticker symbol. When you enter a ticker symbol make sure that you don’t include the hash tag symbol, capitalization does not matter. We will let you know if you ticker is valid or not. Then we will pull basic data for the stock from Yahoo and go to Twitter and gather tweets for the last 5 days. We check to make sure tweets are relevant to the stock market and if we find no financially relevant tweets, we tell you. \n\tWhen you click on a stock that you have searched for, you get a detail view of more stock data and a graph on twitter data for the last five days. We then check every minute to see if new tweets have been tweeted and if the frequency is fast enough to represent a trend. We will alert you if it does. We also give you options to view all the tweets that were returned and do a Google news search for the stock. \n\tHopefully this app alerts you to movements that you can capitalize on*!\n\nLimitations:\n\tThe data you enter is not persistent. If you close the app all the way (Swipe up after tapping the home button twice) all your searched tickers will disappear. If you just exit out of the app (press home button once) then your phone determines when the app is allowed to work in the background. This that we can only check for a trend when your phone lets it. This is entirely up to your phone. If we do find a trend you will get a push notification. \n\n*Disclaimer:\n\tWe are not responsible for any action you take based on the information you receive from this app. "
  
  
  }

}
