//
//  MenuViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let menuTableView = UITableView()
    
    let menu = [["Search", SearchViewController()],
        ["Help", HelpViewController()]]
    
    
    override func loadView() {
        self.menuTableView.frame = UIScreen.mainScreen().bounds
        
        self.view = self.menuTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        self.title = "Main Menu"
        
        clearNotificationBadgeNumbers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MenuCell()
        cell.cellLabel.text = self.menu[indexPath.row][0] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45 as CGFloat
    }

    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVC = self.menu[indexPath.row][1] as? UIViewController
        self.navigationController?.pushViewController(newVC!, animated: true)
        
    }


}
