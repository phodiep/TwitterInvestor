//
//  TrendViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/27/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class TrendTableView: UIView, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    var trends = [Trend]()
    
    override init() {
        super.init()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false

        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    

    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = TrendCell()
        
        cell.startLabel.text = "\(self.trends[indexPath.row].startTime)"
        cell.endLabel.text = "\(self.trends[indexPath.row].EndTime)"
        cell.magnitudeLabel.text = "\(self.trends[indexPath.row].trendMagnitude)"
        cell.averageLabel.text = "\(self.trends[indexPath.row].numberOfTweetsThatRepresentTheTrend)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trends.count
    }

    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
}
