//
//  SearchViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    var watchList = [Stock]()
    var engines = [TrendEngineForTicker]()

    override func loadView() {
        self.tableView.frame = UIScreen.mainScreen().bounds
        
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()

        self.tableView.tableHeaderView = searchBar

        self.view = self.tableView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search"
        self.tableView.registerClass(SearchCell.self, forCellReuseIdentifier: "SEARCH_CELL")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.watchList.append(Stock(
            ticker: "AAPL",
            companyName: "Apple Inc.",
            change: 0.58,
            price: 112.98,
            pe: 17.52))
        self.watchList.append(Stock(
            ticker: "BA",
            companyName: "Boeing",
            change: -1.02,
            price: 134.62,
            pe: 19.36))
        self.watchList.append(Stock(
            ticker: "GOOG",
            companyName: "Google Inc",
            change: 5.56,
            price: 539.95,
            pe: 28.42))
        
    }

    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("SEARCH_CELL", forIndexPath: indexPath) as SearchCell
        let cell = SearchCell()
        cell.tickerLabel.text = self.watchList[indexPath.row].ticker
        cell.companyNameLabel.text = self.watchList[indexPath.row].companyName
        cell.change = self.watchList[indexPath.row].change
        
        if cell.change == 0.0 {
            cell.changeLabel.textColor = UIColor.blackColor()
            cell.changeLabel.text = "\(cell.change)"
        }
        if cell.change > 0.0 {
            let greenColor = UIColor(red: 31/255, green: 153/255, blue: 43/255, alpha: 1.0)
            cell.changeLabel.textColor = greenColor
            cell.changeLabel.text = "+\(cell.change)"
        }
        if cell.change < 0.0 {
            cell.changeLabel.textColor = UIColor.redColor()
            cell.changeLabel.text = "\(cell.change)"
        }

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //swipe left to delete
            self.watchList.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DetailViewController()
        detailVC.stock = self.watchList[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    
    }
    
    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.watchList.insert(Stock(ticker: searchBar.text, companyName: "???"), atIndex: 0)
      
      NetworkController.sharedInstance.getJSONTocheckforTrend(searchBar.text, trailingClosure: { (returnedTrendEngine, error) -> Void in
        if returnedTrendEngine != nil{
          self.engines.append(returnedTrendEngine!)
        }
        
        
      })
      
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.tableView.reloadData()
        
    }

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsCancelButton = true
        return true
    }
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return text.validateForTicker()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        
    }
    
}
