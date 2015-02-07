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
    var trendEngine: TrendEngineForTicker!// = TrendEngineForTicker(tickerSymbol: , JSONBlob: )

    let rootView = UIView()
    let stockView = UIView()
    let twitterView = UIView()

    var alertController: UIAlertController!
    var moreButton: UIBarButtonItem!
  var isLoggedinToTwitter: Bool?

//    var timerForTwitterTrendCheck: NSTimer?
//    var operationQueueCheckTrend: NSOperationQueue?
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

        self.layoutStockView()
        self.layoutRootView()

      if self.isLoggedinToTwitter == true{
        if !self.trendEngine.needsBaseline{
            self.layoutTwitterView()
        } else {
            self.layoutTwitterView_empty()
        }
      }else{
        self.layOutTwitterViewNotLoggedIn()
      }
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
        
        if self.trendEngine.needsBaseline {
            tweetsOption.enabled = false
        }

    }


    //MARK: Autolayout Views
    func layoutRootView() {
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
//        let stockViewHeight = (UIScreen.mainScreen().bounds.height - navBarHeight! - statusBarHeight) * 0.35
//        let twitterViewHeight = (UIScreen.mainScreen().bounds.height - navBarHeight! - statusBarHeight) * 0.65
        
        let views = ["stockView" : self.stockView,
            "twitterView" : self.twitterView]
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[stockView]|",
            options: nil, metrics: nil, views: views))
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[twitterView]|",
            options: nil, metrics: nil, views: views))
        self.rootView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(\(navBarHeight! + statusBarHeight))-[stockView][twitterView]|",
            options: nil, metrics: nil, views: views))
        
    }
    
    func layoutStockView() {
        // start time for Trend Check
//        timerForTwitterTrendCheck = NSTimer(timeInterval: 60, target: self, selector: "checkForTrend", userInfo: nil, repeats: true)
//        NSRunLoop.currentRunLoop().addTimer(timerForTwitterTrendCheck!, forMode: NSRunLoopCommonModes)
//        self.operationQueueCheckTrend = NSOperationQueue()

        
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
        let dividendLabel = UILabel()
        
        let titleRange = UILabel()
        let titleFiftyDay = UILabel()
        let titleMarketCap = UILabel()
        let titlePrice = UILabel()
        let titleChange = UILabel()
        let titleVolAvg = UILabel()
        let titlePE = UILabel()
        let titleEPS = UILabel()
        let titleDividend = UILabel()
        
        
        func setTitleLabel(label: UILabel, text: String) {
            label.font = UIFont(name: "HelveticaNeue", size: 12)
            label.textColor = UIColor.grayColor()
            label.text = text
        }
        func setValueLabel(label: UILabel, text: String, font: UIFont = UIFont(name: "HelveticaNeue", size: 16)!) {
            label.font = font
            label.text = text
        }

        setTitleLabel(titleRange, "Days Range")
        setTitleLabel(titleFiftyDay, "50 Day Average")
        setTitleLabel(titleMarketCap, "Market Cap")
        setTitleLabel(titlePrice, "Price")
        setTitleLabel(titleChange, "Change")
        setTitleLabel(titleVolAvg, "Volume Average")
        setTitleLabel(titlePE, "P/E")
        setTitleLabel(titleEPS, "EPS")
        setTitleLabel(titleDividend, "Dividend")

        setValueLabel(companyLabel,         self.stock.getName(), font: UIFont( name: "HelveticaNeue-Bold", size: 18)!)

           var commaPrice : String        = self.stock.getFormattedStringValue( self.stock.getPrice() )!
        setValueLabel(priceLabel,           commaPrice,   font: UIFont(name: "HelveticaNeue-Bold", size: 16)!)

        setValueLabel(peLabel,              self.stock.getPERatio())                  // ( "PERatio" )!)

           var commaDaysRange : String    = self.stock.getFormattedRangeStringValue( self.stock.getDaysRange() )!
        setValueLabel(daysRangeLabel,       self.stock.getDaysRange())                // ("DaysRange")!)

           var commaPrice50DayAv : String = self.stock.getFormattedStringValue( self.stock.getFiftyDayAverage() )!
        setValueLabel(fiftyDayAverageLabel, commaPrice50DayAv )                       // ("FiftydayMovingAverage")!)

        setValueLabel(marketCapLabel,       self.stock.getMarketCapitalization())     // ("MarketCapitalization")!)

           var commaVolAverage : String  =  self.stock.getFormattedStringValueNoDecimal( self.stock.getAverageDailyVolume() )!
        setValueLabel(volAverageLabel,      commaVolAverage )       // ("AverageDailyVolume")!)
        println( "\(self.stock.getAverageDailyVolume())  --> \(volAverageLabel) --> \(commaVolAverage)" )

        setValueLabel(epsLabel,             self.stock.getEPSEstimateCurrentYear())

        setValueLabel(dividendLabel,        self.stock.getDividendYield())

           var commaChange : String       = self.stock.getFormattedStringValue( self.stock.getChange()  )!
        setValueLabel(changeLabel,          commaChange )

        let floatChange   = self.stock.getChangeFloat()
        let greenColor    = UIColor(red: 31/255, green: 153/255, blue: 43/255, alpha: 1.0)
        if floatChange == 0.0 {
            changeLabel.textColor = UIColor.blackColor()
        } else if floatChange  > 0.0 {
            changeLabel.textColor = greenColor
            setValueLabel(changeLabel, "+" + commaChange )
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
        readyAutoLayout(dividendLabel)
        readyAutoLayout(titleRange)
        readyAutoLayout(titleFiftyDay)
        readyAutoLayout(titleMarketCap)
        readyAutoLayout(titlePrice)
        readyAutoLayout(titleChange)
        readyAutoLayout(titleVolAvg)
        readyAutoLayout(titlePE)
        readyAutoLayout(titleEPS)
        readyAutoLayout(titleDividend)

        
        let views = ["companyLabel": companyLabel,
                    "priceLabel": priceLabel,
                    "peLabel": peLabel,
                    "changeLabel": changeLabel,
                    "daysRangeLabel" : daysRangeLabel,
                    "fiftyDayAverageLabel" : fiftyDayAverageLabel,
                    "marketCapLabel" : marketCapLabel,
                    "volAverageLabel" : volAverageLabel,
                    "epsLabel" : epsLabel,
                    "dividendLabel" : dividendLabel,
                    "titleRange" : titleRange,
                    "titleFiftyDay" : titleFiftyDay,
                    "titleMarketCap" : titleMarketCap,
                    "titlePrice" : titlePrice,
                    "titleChange" : titleChange,
                    "titleVolAvg" : titleVolAvg,
                    "titlePE" : titlePE,
                    "titleEPS" : titleEPS,
                    "titleDividend" : titleDividend
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
            "V:|-4-[titlePrice][priceLabel]-8-[titleChange][changeLabel]-8-[titlePE][peLabel]-8-[titleEPS][epsLabel]-8-[titleDividend][dividendLabel]-8-|",
            options: NSLayoutFormatOptions.AlignAllRight, metrics: nil, views: views))
    }
  
  
//    func checkForTrend(){
//      operationQueueCheckTrend!.addOperationWithBlock { () -> Void in
//        
//        self.trendMagnitude = self.trendEngine.checkForTrend()
//        self.isTrending = self.trendEngine.isTrending
//      }
//    }

    func layoutTwitterView_empty() {
        let twitterBlueColor = UIColor(red: 166/255, green: 232/255, blue: 255/255, alpha: 0.8)
        self.twitterView.backgroundColor = twitterBlueColor //UIColor.whiteColor()
        
        let message = UILabel()
        message.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        message.text = "No Twitter Activity Found"
        message.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.twitterView.addSubview(message)
        
        let views = ["message" : message]
        
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[message]",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-16-[message]",
            options: nil, metrics: nil, views: views))
        
    }
  
  func layOutTwitterViewNotLoggedIn(){
    let twitterBlueColor = UIColor(red: 166/255, green: 232/255, blue: 255/255, alpha: 0.8)
    self.twitterView.backgroundColor = twitterBlueColor //UIColor.whiteColor()
    
    let message = UILabel()
    message.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
    message.text = "You Need to log into Twitter in your account setting."
    message.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.twitterView.addSubview(message)
    
    let views = ["message" : message]
    
    self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-16-[message]",
      options: nil, metrics: nil, views: views))
    self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-16-[message]",
      options: nil, metrics: nil, views: views))

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
    func moreButtonPressed(sender: UIBarButtonItem) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if let popoverController = self.alertController.popoverPresentationController {
                popoverController.barButtonItem = sender
            }
            self.alertController.popoverPresentationController
        }
        self.presentViewController(self.alertController, animated: true, completion: nil)
    }

    
}

