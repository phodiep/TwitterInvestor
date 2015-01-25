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


        
        // Do any additional setup after loading the view.
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        self.layoutRootView()
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
        self.stockView.backgroundColor = UIColor.blueColor()
        
        let symbolLabel = UILabel()
        let companyLabel = UILabel()
        let newsButton = UIButton()
        
        symbolLabel.text = self.stock.ticker
        companyLabel.text = self.stock.companyName
        newsButton.setTitle("News", forState: .Normal)
        newsButton.addTarget(self, action: "newsButtonPressed:", forControlEvents: .TouchUpInside)
        
        symbolLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        companyLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        newsButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.stockView.addSubview(symbolLabel)
        self.stockView.addSubview(companyLabel)
        self.stockView.addSubview(newsButton)

        let views = ["symbolLabel": symbolLabel,
                    "companyLabel": companyLabel,
                    "newsButton": newsButton]
        
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[companyLabel]-8-[symbolLabel]",
            options: nil, metrics: nil, views: views))
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-8-[companyLabel]",
            options: nil, metrics: nil, views: views))
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-8-[symbolLabel]",
            options: nil, metrics: nil, views: views))

        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[newsButton]-16-|",
            options: nil, metrics: nil, views: views))
        self.stockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-8-[newsButton]",
            options: nil, metrics: nil, views: views))

        
    }
    
    func layoutTwitterView() {
        self.twitterView.backgroundColor = UIColor.purpleColor()
        
        let trendLabel = UILabel()
        trendLabel.text = "Trending Data..."
        
        
        trendLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.twitterView.addSubview(trendLabel)
        
        let views = ["trendLabel" : trendLabel]
        
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[trendLabel]",
            options: nil, metrics: nil, views: views))
        self.twitterView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-8-[trendLabel(30)]",
            options: nil, metrics: nil, views: views))
        
    }
    
    func newsButtonPressed(sender: UIButton) {
        let webVC = WebViewController()
        webVC.ticker = self.stock.ticker
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }

}
