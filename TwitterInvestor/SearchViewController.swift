//
//  SearchViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    let tableView = UITableView()
    let searchBar = UISearchBar()

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
