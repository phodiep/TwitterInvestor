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
        
        self.watchList.append(Stock(ticker: "AAPL", companyName: "Apple Inc.", change: 0.58))
        self.watchList.append(Stock(ticker: "BA", companyName: "Boeing", change: -1.02))
        self.watchList.append(Stock(ticker: "GOOG", companyName: "Google Inc", change: 5.56))
        
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
            cell.changeLabel.textColor = UIColor.greenColor()
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
        self.watchList.insert(Stock(ticker: searchBar.text, companyName: "???", change: 0), atIndex: 0)
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
    
}
