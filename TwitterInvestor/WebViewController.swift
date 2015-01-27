//
//  WebViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()
    var ticker: String!
    var url: String!
    
    var shareButton: UIBarButtonItem!

    override func loadView() {
        self.webView.frame = UIScreen.mainScreen().bounds
        self.url = "https://www.google.com/search?q=ticker+\(self.ticker)&tbm=nws"
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        self.webView.loadRequest(request)
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "News"
        
        self.shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonPressed:")
        self.navigationItem.rightBarButtonItem = self.shareButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    func shareButtonPressed(sender: UIBarButtonItem) {
        let shareAlertController = UIAlertController(title: "Share", message: "", preferredStyle: .ActionSheet)
        
        let safariOption = UIAlertAction(title: "Open Link in Safari", style: .Default) { (action) -> Void in
            self.openLinkInSafari()
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            //close actionsheet
        }
        
        shareAlertController.addAction(safariOption)
        shareAlertController.addAction(cancelOption)
        
        self.presentViewController(shareAlertController, animated: true, completion: nil)

    }
    
    func openLinkInSafari() {
        UIApplication.sharedApplication().openURL(self.webView.URL!)
    }

}
