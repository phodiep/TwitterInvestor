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
    
    var moreButton: UIBarButtonItem!
    var newsButton: UIBarButtonItem!
    var orientation: UIDeviceOrientation!
    //MARK: UIViewController Lifecycle

    var timerForTwitterTrendCheck: NSTimer?
    var operationQueueCheckTrend: NSOperationQueue?
    var isTrending: Bool?
    var trendMagnitude: Double?
  
    var alertController: UIAlertController!

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
        
        self.orientation = UIDevice.currentDevice().orientation

        self.title = self.stock.getStringValue( "Symbol" ) // ticker
        
//        self.newsButton = UIBarButtonItem(title: "News", style: .Done, target: self, action: "newsButtonPressed:")
//        self.navigationItem.rightBarButtonItem = self.newsButton

        self.moreButton = UIBarButtonItem(title: "More", style: .Done, target: self, action: "moreButtonPressed:")
        self.navigationItem.rightBarButtonItem = self.moreButton

        
        // cell.tickerLabel.text = stockQuote.getStringValue("Symbol")  // self.watchList[indexPath.row].ticker
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
        
        companyLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        priceLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        peLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        changeLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        daysRangeLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        fiftyDayAverageLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        marketCapLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        volAverageLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        epsLabel.font = UIFont(name: "HelveticaNeue", size: 16)

        titleRange.font = UIFont(name: "HelveticaNeue", size: 12)
        titleRange.textColor = UIColor.grayColor()
        titleRange.text = "Range"

        titleFiftyDay.font = UIFont(name: "HelveticaNeue", size: 12)
        titleFiftyDay.textColor = UIColor.grayColor()
        titleFiftyDay.text = "50 Day Average"
        
        titleMarketCap.font = UIFont(name: "HelveticaNeue", size: 12)
        titleMarketCap.textColor = UIColor.grayColor()
        titleMarketCap.text = "Market Cap"

        titlePrice.font = UIFont(name: "HelveticaNeue", size: 12)
        titlePrice.textColor = UIColor.grayColor()
        titlePrice.text = "Price"
        
        titleChange.font = UIFont(name: "HelveticaNeue", size: 12)
        titleChange.textColor = UIColor.grayColor()
        titleChange.text = "Change"
        
        titleVolAvg.font = UIFont(name: "HelveticaNeue", size: 12)
        titleVolAvg.textColor = UIColor.grayColor()
        titleVolAvg.text = "Volume Average"

        
        titlePE.font = UIFont(name: "HelveticaNeue", size: 12)
        titlePE.textColor = UIColor.grayColor()
        titlePE.text = "P/E"
        
        titleEPS.font = UIFont(name: "HelveticaNeue", size: 12)
        titleEPS.textColor = UIColor.grayColor()
        titleEPS.text = "EPS"


        timerForTwitterTrendCheck = NSTimer(timeInterval: 60, target: self, selector: "checkForTrend", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerForTwitterTrendCheck!, forMode: NSRunLoopCommonModes)
        self.operationQueueCheckTrend = NSOperationQueue()
        
        companyLabel.text = self.stock.getStringValue( "Name" ) // Company Name
        priceLabel.text   = self.stock.getStringValue( "AskRealtime" )  //")price!)"
        peLabel.text      = self.stock.getStringValue( "PERatio" )

        let floatChange   = self.stock.convertToFloat( "Change" )
        let greenColor    = UIColor(red: 31/255, green: 153/255, blue: 43/255, alpha: 1.0)
        
        if        floatChange == 0.0 {
            changeLabel.textColor = UIColor.blackColor()
        } else if floatChange  > 0.0 {
            changeLabel.textColor = greenColor
        } else if floatChange  < 0.0 {
            changeLabel.textColor = UIColor.redColor()
        } else {
            changeLabel.textColor = UIColor.blackColor()
        }
        changeLabel.text =  self.stock.getStringValue( "Change" )

        daysRangeLabel.text = self.stock.getStringValue( "DaysRange" )
        fiftyDayAverageLabel.text = self.stock.getStringValue( "FiftydayMovingAverage" )
        marketCapLabel.text = self.stock.getStringValue( "MarketCapitalization" )
        volAverageLabel.text = self.stock.getStringValue( "AverageDailyVolume" )
        epsLabel.text =  self.stock.getStringValue( "EPSEstimateCurrentYear" )
        
        
        companyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        priceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        peLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        changeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        daysRangeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        fiftyDayAverageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        marketCapLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        volAverageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        epsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        titleRange.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleFiftyDay.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleMarketCap.setTranslatesAutoresizingMaskIntoConstraints(false)
        titlePrice.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleChange.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleVolAvg.setTranslatesAutoresizingMaskIntoConstraints(false)
        titlePE.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleEPS.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.stockView.addSubview(companyLabel)
        self.stockView.addSubview(priceLabel)
        self.stockView.addSubview(peLabel)
        self.stockView.addSubview(changeLabel)
        self.stockView.addSubview(daysRangeLabel)
        self.stockView.addSubview(fiftyDayAverageLabel)
        self.stockView.addSubview(marketCapLabel)
        self.stockView.addSubview(volAverageLabel)
        self.stockView.addSubview(epsLabel)
        
        self.stockView.addSubview(titleRange)
        self.stockView.addSubview(titleFiftyDay)
        self.stockView.addSubview(titleMarketCap)
        self.stockView.addSubview(titlePrice)
        self.stockView.addSubview(titleChange)
        self.stockView.addSubview(titleVolAvg)
        self.stockView.addSubview(titlePE)
        self.stockView.addSubview(titleEPS)
        
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
        let twitterBlueColor    = UIColor(red: 166/255, green: 232/255, blue: 255/255, alpha: 0.8)
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
        
        alertController.addAction(webOption)
        alertController.addAction(tweetsOption)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if let popoverController = self.alertController.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
        }

        self.presentViewController(self.alertController, animated: true, completion: nil)
    }

    
}
