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
        

        
        self.watchList.append(Stock(ticker: "AAPL", companyName: "Apple Inc."))
        self.watchList.append(Stock(ticker: "BA", companyName: "Boeing"))
        self.watchList.append(Stock(ticker: "GOOG", companyName: "Google Inc"))
        
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
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
        
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.tableView.reloadData()
        
    }
}
