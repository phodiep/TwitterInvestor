//
//  SearchRepositoriesViewController.swift
//  GithubClient
//
//  Created by Bradley Johnson on 1/19/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class SearchRepositoriesViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var searchBar: UISearchBar!
  var networkController : NetworkController!
  
  var repos = [Repository]()
    override func viewDidLoad() {
        super.viewDidLoad()
     self.tableView.dataSource = self
      self.searchBar.delegate = self
      
      
      let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
      self.networkController = appDelegate.networkController

        // Do any additional setup after loading the view.
    }
  
  //MARK: UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as UITableViewCell
    return cell
  }
    //MARK: UISearchBarDelegate
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    println(searchBar.text)
    self.networkController.fetchRepositoriesForSearchTerm(searchBar.text, callback: { (repositories, errorDescription) -> (Void) in
      self.repos = repositories!
      self.tableView.reloadData()
      //reload table view with new data
    })
    searchBar.resignFirstResponder()
    //make your network call here based on the search term
  }

  
    // MARK: - Navigationrl

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if segue.identifier == "SHOW_WEB" {
        let destinationVC = segue.destinationViewController as WebViewController
        let selectedIndexPath = self.tableView.indexPathForSelectedRow()
        let repo = self.repos[selectedIndexPath!.row]
        destinationVC.url = repo.url
      }
    }


}
