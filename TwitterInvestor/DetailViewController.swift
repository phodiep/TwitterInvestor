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

    let rootView = UIView()
    let stockView = UIView()
    let twitterView = UIView()
    
    var newsButton: UIBarButtonItem!
    var orientation: UIDeviceOrientation!
    
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

    

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.rootView.setNeedsLayout()
        self.rootView.layoutIfNeeded()
        
//        self.layoutRootView()

    }
    
    
    func layoutRootView() {
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        let stockViewHeight = (UIScreen.mainScreen().bounds.height - navBarHeight! - statusBarHeight) * 0.5
        let twitterViewHeight = (UIScreen.mainScreen().bounds.height - navBarHeight! - statusBarHeight) * 0.5
        
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
        let plotImage = UIImageView()
        let priceLabel = UILabel()
        let peLabel = UILabel()
        let changeLabel = UILabel()
        
        companyLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        priceLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        peLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        changeLabel.font = UIFont(name: "HelveticaNeue", size: 16)
        
        
        
        companyLabel.text = self.stock.companyName
        plotImage.image = UIImage(named: "stockPrice")
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

        
        companyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        plotImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        priceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        peLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        changeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.stockView.addSubview(companyLabel)
        self.stockView.addSubview(plotImage)
        self.stockView.addSubview(priceLabel)
        self.stockView.addSubview(peLabel)
        self.stockView.addSubview(changeLabel)
        
        
        
        let views = ["companyLabel": companyLabel,
                    "plotImage": plotImage,
                    "priceLabel": priceLabel,
                    "peLabel": peLabel,
                    "changeLabel": changeLabel]
        
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[companyLabel]",
            options: nil, metrics: nil, views: views))
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-16-[companyLabel]-16-[plotImage(120)]",
            options: nil, metrics: nil, views: views))
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[plotImage(180)]",
            options: nil, metrics: nil, views: views))
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[priceLabel]-16-|",
            options: nil, metrics: nil, views: views))

        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-16-[priceLabel]-8-[changeLabel]-8-[peLabel]",
            options: NSLayoutFormatOptions.AlignAllRight, metrics: nil, views: views))

        
    }
    
    func layoutTwitterView() {
        self.twitterView.backgroundColor = UIColor.whiteColor()
        
        let trendLabel = UILabel()
        let plotImage = UIImageView()
        
        trendLabel.text = "Tweets per hour"
        plotImage.image = UIImage(named: "twitterTrend")
        
        trendLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        plotImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.twitterView.addSubview(trendLabel)
        self.twitterView.addSubview(plotImage)
        
        let views = ["trendLabel" : trendLabel,
                "plotImage" : plotImage]
        
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[trendLabel]",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[plotImage(180)]",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-8-[trendLabel(30)]-16-[plotImage(120)]",
            options: nil, metrics: nil, views: views))
        
    }
    
    func newsButtonPressed(sender: UIButton) {
        let webVC = WebViewController()
        webVC.ticker = self.stock.ticker
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }

}
