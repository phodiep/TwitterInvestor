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
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
