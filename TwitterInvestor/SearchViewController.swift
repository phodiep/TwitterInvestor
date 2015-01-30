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
    var engines   = [TrendEngineForTicker]()

    //MARK: UIViewController Lifecycle
    override func loadView() {
        self.tableView.frame = UIScreen.mainScreen().bounds
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.searchBar.sizeToFit()

        self.tableView.tableHeaderView = searchBar

        self.view = self.tableView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search"
        self.tableView.registerClass(SearchCell.self, forCellReuseIdentifier: "SEARCH_CELL")
        
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

        cell.companyNameLabel.text = stockQuote.getStringValue( "Name" )
        cell.change = stockQuote.convertToFloat( "Change" ) // self.watchList[indexPath.row].change
        cell.priceLabel.text = stockQuote.getStringValue( "AskRealtime" )   // "\(self.watchList[indexPath.row].price!)"
        
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

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Symbol      Price   Change"
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
        let input = searchBar.text
        let ticker = input.uppercaseString

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 2, UIScreen.mainScreen().bounds.height * 2)
        activityIndicator.color = UIColor.blackColor()
        activityIndicator.backgroundColor = UIColor.lightGrayColor()
        activityIndicator.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activityIndicator.alpha = 0.5
        activityIndicator.hidden = false
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        NetworkController.sharedInstance.getStockInfoFromYahoo(ticker, stockLookup: { (Stock, error) -> () in
            // println( "Stock[\(Stock)] error[\(error)]" )
            if Stock != nil {
                // println( "Stock: \(Stock)" )
                self.watchList.insert(Stock!, atIndex: 0)
                let testForEmpty = self.watchList.first!.quoteData.isEmpty
                if  testForEmpty {
                    self.invalidTickerAlert( ticker )
                    self.watchList.removeAtIndex(0)
//                    println( "Count[\(self.watchList.count)]" )
//                    println( "First[\(self.watchList.first?.quoteData)]" )
//                    println( "First[\(self.watchList.first?.quoteData.isEmpty)]" )
//                    println( "Count[\(self.watchList.first?.quoteData.count)]" )
                    activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.tableView.reloadData()

                } else {

                    NetworkController.sharedInstance.overloadTwitter(ticker, trailingClosure: { (returnedTrendEngine, error) -> Void in
                        if returnedTrendEngine != nil {
                            //returnedTrendEngine!.buildData()
                            self.engines.insert(returnedTrendEngine!, atIndex: 0)
                            activityIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            self.tableView.reloadData()
                        }
                    })

                }
            }
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
        //return text.validateForTicker()
        return true
  }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        
    }
    
    //MARK: UIActionAlert
    func invalidTickerAlert( ticker : String ) {
        let alertController = UIAlertController(title: "Ticker, \(ticker), is not valid", message: "Enter a valid ticker for search", preferredStyle: .Alert)
    
        let okButton = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            //dismiss alert and reset search bar text
            self.searchBar.text = ""
        }
        
        alertController.addAction(okButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }


}
