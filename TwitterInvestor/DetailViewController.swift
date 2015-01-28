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
    
    var newsButton: UIBarButtonItem!
    var orientation: UIDeviceOrientation!
    //MARK: UIViewController Lifecycle

    var timerForTwitterTrendCheck: NSTimer?
    var operationQueueCheckTrend: NSOperationQueue?
    var isTrending: Bool?
    var trendMagnitude: Double?
  

    override func loadView() {
        self.rootView.frame = UIScreen.mainScreen().bounds
        
        self.stockView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.twitterView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.rootView.addSubview(stockView)
        self.rootView.addSubview(twitterView)
        
        self.view = self.rootView

        self.layoutRootView()
        self.layoutStockView()
        self.layoutTwitterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.orientation = UIDevice.currentDevice().orientation

        self.title = self.stock.ticker
        
        self.newsButton = UIBarButtonItem(title: "News", style: .Done, target: self, action: "newsButtonPressed:")
        self.navigationItem.rightBarButtonItem = self.newsButton
        
    }

    //MARK: Autolayout Views
    func layoutRootView() {
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        let stockViewHeight = (UIScreen.mainScreen().bounds.height - navBarHeight! - statusBarHeight) * 0.3
        let twitterViewHeight = (UIScreen.mainScreen().bounds.height - navBarHeight! - statusBarHeight) * 0.7
        
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
        self.stockView.backgroundColor = UIColor.whiteColor()
        
        let companyLabel = UILabel()
        let priceLabel = UILabel()
        let peLabel = UILabel()
        let changeLabel = UILabel()
        let daysRangeLabel = UILabel()
        let fiftyDayAverageLabel = UILabel()
        let marketCapLabel = UILabel()
        let volAverageLabel = UILabel()
        let epsLabel = UILabel()
        let sharesLabel = UILabel()
        
        companyLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        priceLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        peLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        changeLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        daysRangeLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        fiftyDayAverageLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        marketCapLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        volAverageLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        epsLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        sharesLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        
        timerForTwitterTrendCheck = NSTimer(timeInterval: 60, target: self, selector: "checkForTrend", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timerForTwitterTrendCheck!, forMode: NSRunLoopCommonModes)
        self.operationQueueCheckTrend = NSOperationQueue()
        
        companyLabel.text = "company"
        priceLabel.text = "\(self.stock.price!)"
        peLabel.text = "p/e: \(self.stock.pe!)"
        
        if self.stock.change == 0.0 {
            changeLabel.textColor = UIColor.blackColor()
            changeLabel.text = "\(self.stock.change!)"
        }
        if self.stock.change > 0.0 {
            let greenColor = UIColor(red: 31/255, green: 153/255, blue: 43/255, alpha: 1.0)
            changeLabel.textColor = greenColor
            changeLabel.text = "+\(self.stock.change!)"
        }
        if self.stock.change < 0.0 {
            changeLabel.textColor = UIColor.redColor()
            changeLabel.text = "\(self.stock.change!)"
        }

        daysRangeLabel.text = "days range"
        fiftyDayAverageLabel.text = "fifty"
        marketCapLabel.text = "market cap"
        volAverageLabel.text = "vol average"
        epsLabel.text = "eps"
        sharesLabel.text = "shares"
        
        
        companyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        priceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        peLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        changeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        daysRangeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        fiftyDayAverageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        marketCapLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        volAverageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        epsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        sharesLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.stockView.addSubview(companyLabel)
        self.stockView.addSubview(priceLabel)
        self.stockView.addSubview(peLabel)
        self.stockView.addSubview(changeLabel)
        self.stockView.addSubview(daysRangeLabel)
        self.stockView.addSubview(fiftyDayAverageLabel)
        self.stockView.addSubview(marketCapLabel)
        self.stockView.addSubview(volAverageLabel)
        self.stockView.addSubview(epsLabel)
        self.stockView.addSubview(sharesLabel)
        
        let views = ["companyLabel": companyLabel,
                    "priceLabel": priceLabel,
                    "peLabel": peLabel,
                    "changeLabel": changeLabel,
                    "daysRangeLabel" : daysRangeLabel,
                    "fiftyDayAverageLabel" : fiftyDayAverageLabel,
                    "marketCapLabel" : marketCapLabel,
                    "volAverageLabel" : volAverageLabel,
                    "epsLabel" : epsLabel,
                    "sharesLabel" : sharesLabel]
        
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[companyLabel]",
            options: nil, metrics: nil, views: views))
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[priceLabel]-16-|",
            options: nil, metrics: nil, views: views))

        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-16-[companyLabel]-16-[daysRangeLabel]-16-[fiftyDayAverageLabel]-16-[marketCapLabel]-16-[sharesLabel]",
            options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views))

        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-16-[priceLabel]-16-[changeLabel]-16-[volAverageLabel]-16-[peLabel]-16-[epsLabel]",
            options: NSLayoutFormatOptions.AlignAllRight, metrics: nil, views: views))
    }
  
  
    func checkForTrend(){
      
      
      operationQueueCheckTrend!.addOperationWithBlock { () -> Void in
        
        self.trendMagnitude = self.trendEngine.checkForTrend()
        self.isTrending = self.trendEngine.isTrending
      }
    }

    func layoutTwitterView() {
        self.twitterView.backgroundColor = UIColor.whiteColor()

        let trendLabel = UILabel()
        let plotImage = UIImageView()
        let averageLabel = UILabel()
        let latestTweet = UILabel()
        let isTrendingLabel = UILabel()
        
        trendLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        averageLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        latestTweet.font = UIFont(name: "HelveticaNeue", size: 16)
        isTrendingLabel.font = UIFont(name: "HelveticaNeue", size: 16)

        trendLabel.text = "TwitterTrends"
        plotImage.image = UIImage(named: "twitterTrend")
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
            "H:|-8-[plotImage]-8-|",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-8-[plotImage]",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[plotImage(150)]-8-[averageLabel(30)]-[latestTweet(30)]-[isTrendingLabel(30)]",
            options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views))

        
    }
    
    //MARK: Button Actions
    func newsButtonPressed(sender: UIButton) {
        let webVC = WebViewController()
        webVC.ticker = self.stock.ticker
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }

}
