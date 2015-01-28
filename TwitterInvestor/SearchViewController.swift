//
//  SearchViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var tableView = UITableView()
    let searchBar = UISearchBar()
    
    var watchList = [Stock]()
    var engines = [TrendEngineForTicker]()
   // var stocks = [Stock]()

    override func loadView() {
        self.tableView.frame = UIScreen.mainScreen().bounds
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()

        self.tableView.tableHeaderView = searchBar

        self.view = self.tableView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search"
        self.tableView.registerClass(SearchCell.self, forCellReuseIdentifier: "SEARCH_CELL")
        
//        self.watchList.append(Stock(
//            ticker: "AAPL",
//            companyName: "Apple Inc.",
//            change: 0.58,
//            price: 112.98,
//            pe: 17.52))
//        self.watchList.append(Stock(
//            ticker: "BA",
//            companyName: "Boeing",
//            change: -1.02,
//            price: 134.62,
//            pe: 19.36))
//        self.watchList.append(Stock(
//            ticker: "GOOG",
//            companyName: "Google Inc",
//            change: 5.56,
//            price: 539.95,
//            pe: 28.42))

        self.tableView.reloadData()
    }

    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("SEARCH_CELL", forIndexPath: indexPath) as SearchCell

        let cell = SearchCell()
        let stockQuote = self.watchList[indexPath.row]

        cell.tickerLabel.text = stockQuote.getStringValue("Symbol")  // self.watchList[indexPath.row].ticker

        cell.companyNameLabel.text = self.watchList[indexPath.row].companyName
        cell.change = self.watchList[indexPath.row].change
        cell.priceLabel.text = "\(self.watchList[indexPath.row].price!)"
        
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
        detailVC.trendEngine = self.engines[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    
    }
    
    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let ticker = searchBar.text
        NetworkController.sharedInstance.getStockInfoFromYahoo(ticker, stockLookup: { (Stock, error) -> () in
        self.watchList.insert(Stock!, atIndex: 0)
        NetworkController.sharedInstance.getInitialTwitterRequest(ticker, trailingClosure: { (returnedTrendEngine, error) -> Void in
          if returnedTrendEngine != nil{
            self.engines.append(returnedTrendEngine!)
          }
        })
        self.tableView.reloadData()
      })
     
      
        searchBar.showsCancelButton = false
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
    
    //MARK: UIActionAlert
    func invalidTickerAlert() {
        let alertController = UIAlertController(title: "Ticker is not valid", message: "enter a valid ticker for search", preferredStyle: .Alert)
    
        let okButton = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            //dismiss alert and reset search bar text
            self.searchBar.text = ""
        }
        
        alertController.addAction(okButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }


}
