//
//  DetailViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var stock: Stock!
    var trendEngine: TrendEngineForTicker!

    let rootView = UIView()
    let stockView = UIView()
    let twitterView = UIView()

    var alertController: UIAlertController!
    var moreButton: UIBarButtonItem!

    var timerForTwitterTrendCheck: NSTimer?
    var operationQueueCheckTrend: NSOperationQueue?
    var isTrending: Bool?
    var trendMagnitude: Double?
  
    
    //MARK: UIViewController Lifecycle
    override func loadView() {
        self.rootView.frame = UIScreen.mainScreen().bounds
        
        self.stockView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.twitterView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.rootView.addSubview(stockView)
        self.rootView.addSubview(twitterView)
        
        self.view = self.rootView

        self.alertController = UIAlertController(title: "More Options", message: "", preferredStyle: .ActionSheet)
        
        self.layoutRootView()
        self.layoutStockView()
        self.layoutTwitterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.stock.getStringValue( "Symbol" ) // ticker
        
        self.setupAlertViewController()
        
    }
    
    //MARK: AlertViewController
    func setupAlertViewController() {
        self.moreButton = UIBarButtonItem(title: "More", style: .Done, target: self, action: "moreButtonPressed:")
        self.navigationItem.rightBarButtonItem = self.moreButton
        let webOption = UIAlertAction(title: "Web", style: .Default) { (action) -> Void in
            let webVC = WebViewController()
            webVC.ticker = self.stock.getStringValue("Symbol")  //self.stock.ticker
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
        let tweetsOption = UIAlertAction(title: "Tweets", style: .Default) { (action) -> Void in
            let tweetVC = TweetsViewController()
            tweetVC.tweets = self.trendEngine.arrayOfAllJSON
            self.navigationController?.pushViewController(tweetVC, animated: true)
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                //close actionsheet
        }
        
        alertController.addAction(webOption)
        alertController.addAction(tweetsOption)
        alertController.addAction(cancelOption)

    }


    //MARK: Autolayout Views
    func layoutRootView() {
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        let stockViewHeight = (UIScreen.mainScreen().bounds.height - navBarHeight! - statusBarHeight) * 0.35
        let twitterViewHeight = (UIScreen.mainScreen().bounds.height - navBarHeight! - statusBarHeight) * 0.65
        
        let views = ["stockView" : self.stockView,
            "twitterView" : self.twitterView]
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[stockView]|",
            options: nil, metrics: nil, views: views))
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[twitterView]|",
            options: nil, metrics: nil, views: views))
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(\(navBarHeight! + statusBarHeight))-[stockView(\(stockViewHeight))][twitterView(\(twitterViewHeight))]|",
            options: nil, metrics: nil, views: views))
        
    }
    
    func layoutStockView() {
        // start time for Trend Check
        timerForTwitterTrendCheck = NSTimer(timeInterval: 60, target: self, selector: "checkForTrend", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerForTwitterTrendCheck!, forMode: NSRunLoopCommonModes)
        self.operationQueueCheckTrend = NSOperationQueue()

        
        self.stockView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let companyLabel = UILabel()
        let priceLabel = UILabel()
        let peLabel = UILabel()
        let changeLabel = UILabel()
        let daysRangeLabel = UILabel()
        let fiftyDayAverageLabel = UILabel()
        let marketCapLabel = UILabel()
        let volAverageLabel = UILabel()
        let epsLabel = UILabel()
        
        let titleRange = UILabel()
        let titleFiftyDay = UILabel()
        let titleMarketCap = UILabel()
        let titlePrice = UILabel()
        let titleChange = UILabel()
        let titleVolAvg = UILabel()
        let titlePE = UILabel()
        let titleEPS = UILabel()
        
        
        func setTitleLabel(label: UILabel, text: String) {
            label.font = UIFont(name: "HelveticaNeue", size: 12)
            label.textColor = UIColor.grayColor()
            label.text = text
        }
        func setValueLabel(label: UILabel, text: String, font: UIFont = UIFont(name: "HelveticaNeue", size: 16)!) {
            label.font = font
            label.text = text
        }

        setTitleLabel(titleRange, "Range")
        setTitleLabel(titleFiftyDay, "50 Day Average")
        setTitleLabel(titleMarketCap, "Market Cap")
        setTitleLabel(titlePrice, "Price")
        setTitleLabel(titleChange, "Change")
        setTitleLabel(titleVolAvg, "Volume Average")
        setTitleLabel(titlePE, "P/E")
        setTitleLabel(titleEPS, "EPS")

        setValueLabel(companyLabel,         self.stock.getStringValue("Name")!,          font: UIFont(name: "HelveticaNeue-Bold", size: 18)!)
        setValueLabel(priceLabel,           self.stock.getStringValue("AskRealtime")!,   font: UIFont(name: "HelveticaNeue-Bold", size: 16)!)
        setValueLabel(peLabel,              self.stock.getStringValue( "PERatio" )!)
        setValueLabel(daysRangeLabel,       self.stock.getStringValue("DaysRange")!)
        setValueLabel(fiftyDayAverageLabel, self.stock.getStringValue("FiftydayMovingAverage")!)
        setValueLabel(marketCapLabel,       self.stock.getStringValue("MarketCapitalization")!)
        setValueLabel(volAverageLabel,      self.stock.getStringValue("AverageDailyVolume")!)
        setValueLabel(epsLabel,             self.stock.getStringValue("EPSEstimateCurrentYear")!)
        setValueLabel(changeLabel,          self.stock.getStringValue( "Change" )!)
        let floatChange   = self.stock.convertToFloat( "Change" )
        let greenColor    = UIColor(red: 31/255, green: 153/255, blue: 43/255, alpha: 1.0)
        if floatChange == 0.0 {
            changeLabel.textColor = UIColor.blackColor()
        } else if floatChange  > 0.0 {
            changeLabel.textColor = greenColor
        } else if floatChange  < 0.0 {
            changeLabel.textColor = UIColor.redColor()
        } else {
            changeLabel.textColor = UIColor.blackColor()
        }


        
        func readyAutoLayout(label: UILabel) {
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.stockView.addSubview(label)
        }
        readyAutoLayout(companyLabel)
        readyAutoLayout(priceLabel)
        readyAutoLayout(peLabel)
        readyAutoLayout(changeLabel)
        readyAutoLayout(daysRangeLabel)
        readyAutoLayout(fiftyDayAverageLabel)
        readyAutoLayout(marketCapLabel)
        readyAutoLayout(volAverageLabel)
        readyAutoLayout(epsLabel)
        readyAutoLayout(titleRange)
        readyAutoLayout(titleFiftyDay)
        readyAutoLayout(titleMarketCap)
        readyAutoLayout(titlePrice)
        readyAutoLayout(titleChange)
        readyAutoLayout(titleVolAvg)
        readyAutoLayout(titlePE)
        readyAutoLayout(titleEPS)

        
        let views = ["companyLabel": companyLabel,
                    "priceLabel": priceLabel,
                    "peLabel": peLabel,
                    "changeLabel": changeLabel,
                    "daysRangeLabel" : daysRangeLabel,
                    "fiftyDayAverageLabel" : fiftyDayAverageLabel,
                    "marketCapLabel" : marketCapLabel,
                    "volAverageLabel" : volAverageLabel,
                    "epsLabel" : epsLabel,
                    "titleRange" : titleRange,
                    "titleFiftyDay" : titleFiftyDay,
                    "titleMarketCap" : titleMarketCap,
                    "titlePrice" : titlePrice,
                    "titleChange" : titleChange,
                    "titleVolAvg" : titleVolAvg,
                    "titlePE" : titlePE,
                    "titleEPS" : titleEPS
        ]
        
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[companyLabel]",
            options: nil, metrics: nil, views: views))
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[priceLabel]-16-|",
            options: nil, metrics: nil, views: views))

        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-16-[companyLabel]-8-[titleRange][daysRangeLabel]-8-[titleFiftyDay][fiftyDayAverageLabel]-8-[titleMarketCap][marketCapLabel]-8-[titleVolAvg][volAverageLabel]",
            options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views))

        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-18-[titlePrice][priceLabel]-16-[titleChange][changeLabel]-16-[titlePE][peLabel]-16-[titleEPS][epsLabel]",
            options: NSLayoutFormatOptions.AlignAllRight, metrics: nil, views: views))
    }
  
  
    func checkForTrend(){
      operationQueueCheckTrend!.addOperationWithBlock { () -> Void in
        
        self.trendMagnitude = self.trendEngine.checkForTrend()
        self.isTrending = self.trendEngine.isTrending
      }
    }

    func layoutTwitterView() {
        let twitterBlueColor = UIColor(red: 166/255, green: 232/255, blue: 255/255, alpha: 0.8)
        self.twitterView.backgroundColor = twitterBlueColor //UIColor.whiteColor()

        let trendLabel = UILabel()
        var plotImage : UIView
        let averageLabel = UILabel()
        let latestTweet = UILabel()
        let isTrendingLabel = UILabel()
        
        trendLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        averageLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        latestTweet.font = UIFont(name: "HelveticaNeue", size: 16)
        isTrendingLabel.font = UIFont(name: "HelveticaNeue", size: 16)

        trendLabel.text = "TwitterTrends"
        trendLabel.textColor = UIColor.blackColor()
        
        plotImage = self.trendEngine.plotView!//TrendPlot(frame: CGRectZero, data: self.trendEngine.tweetBuckets!)
        let average = NSString(format: "%.02f", Float(60/self.trendEngine.tweetsPerHour!))
        averageLabel.text = "Average: \(average) tweets/hr"
        
        let latestDate = self.trendEngine.dateOfNewestTweet
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm"
        
        latestTweet.text = "Latest Tweet: \(dateFormatter.stringFromDate(latestDate!))"
        let isTrend = (self.trendEngine.isTrending ? "Yes":"No")
        isTrendingLabel.text = "Trending? \(isTrend)"
        
        trendLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        plotImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        averageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        latestTweet.setTranslatesAutoresizingMaskIntoConstraints(false)
        isTrendingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.twitterView.addSubview(trendLabel)
        self.twitterView.addSubview(plotImage)
        self.twitterView.addSubview(averageLabel)
        self.twitterView.addSubview(latestTweet)
        self.twitterView.addSubview(isTrendingLabel)
        
        let views = ["trendLabel" : trendLabel,
            "plotImage" : plotImage,
            "averageLabel" : averageLabel,
            "latestTweet" : latestTweet,
            "isTrendingLabel" : isTrendingLabel]

        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-8-[trendLabel]-8-|",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-8-[plotImage]-8-|",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-16-[trendLabel]-[plotImage]",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[plotImage]-8-[averageLabel(30)]-[latestTweet(30)]-[isTrendingLabel(30)]-16-|",
            options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views))

        
    }
    
    //MARK: Button Actions
    func newsButtonPressed(sender: UIButton) {
//        let webVC = WebViewController()
//        webVC.ticker = stock.getStringValue("Symbol")  //self.stock.ticker
//        self.navigationController?.pushViewController(webVC, animated: true)

        let tweetVC = TweetsViewController()
        tweetVC.tweets = self.trendEngine.arrayOfAllJSON
        self.navigationController?.pushViewController(tweetVC, animated: true)

    }

    
    func moreButtonPressed(sender: UIButton) {

        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if let popoverController = self.alertController.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
        }

        self.presentViewController(self.alertController, animated: true, completion: nil)
    }

    
}
