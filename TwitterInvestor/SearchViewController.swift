//
//  SearchViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit
import Accounts
import Social

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var tableView = UITableView()
    let searchBar = UISearchBar()
    
    var watchList = [Stock]()
    var engines   = [TrendEngineForTicker]()
    var isLoggedInToTwitter: Bool?

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
      self.checkForAccountLogin()
      
    }

    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SEARCH_CELL", forIndexPath: indexPath) as SearchCell

        let stockQuote      = self.watchList[indexPath.row]
        var price : String  = ""
        var change : String = ""

        cell.tickerLabel.text      = stockQuote.getSymbol()
        cell.companyNameLabel.text = stockQuote.getName()
        cell.change                = stockQuote.convertToFloat("Change")    // Float value
        change                     = stockQuote.getChange()                 // String value
        price                      = stockQuote.getPrice()                  // String value 
        cell.priceLabel.text       = stockQuote.getFormattedStringValue( price )!
        println( "priceLabel[\(cell.priceLabel.text)] change[\(cell.change)] price[\(price)]" )

        var commaChange : String = stockQuote.getFormattedStringValue( change )!

        if cell.change == 0.0 {
            cell.changeLabel.textColor = UIColor.blackColor()
            
        //  cell.changeLabel.text = NSString(format: "%.2f", commaChange)
            cell.changeLabel.text = commaChange
        }

        if cell.change > 0.0 {
            let greenColor = UIColor(red: 31/255, green: 153/255, blue: 43/255, alpha: 1.0)
            cell.changeLabel.textColor = greenColor
        //  cell.changeLabel.text = "+" + NSString(format: "%.2f", commaChange)
            cell.changeLabel.text = "+" + commaChange
        }
        if cell.change < 0.0 {
           cell.changeLabel.textColor = UIColor.redColor()
        // cell.changeLabel.text = NSString(format: "%.2f", commaChange)
           cell.changeLabel.text = commaChange
        }
        return cell
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Symbol        Price     Change"
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
      if self.isLoggedInToTwitter == true{
        detailVC.trendEngine = self.engines[indexPath.row]
      }else{
        detailVC.trendEngine = TrendEngineForTicker(tickerSymbol: "EMPTY", JSONBlob: [[String:AnyObject]]())
      }
        detailVC.isLoggedinToTwitter = self.isLoggedInToTwitter
        self.navigationController?.pushViewController(detailVC, animated: true)
    
    }
    
    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let input = searchBar.text
        let ticker = input.uppercaseString

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height * 2)
        activityIndicator.color = UIColor.blackColor()
        activityIndicator.backgroundColor = UIColor.lightGrayColor()
        activityIndicator.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/3)
        activityIndicator.alpha = 0.5
        activityIndicator.hidden = false

        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        self.view.addSubview(activityIndicator)
        
        let message = UILabel()
        message.text = "Hang on... Getting Twitter Info"
        message.textColor = UIColor.grayColor()
        message.textAlignment = NSTextAlignment.Center
        message.numberOfLines = 0
        message.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(message)
        let views = ["message" : message]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[message(\(UIScreen.mainScreen().bounds.width))]|",
            options: nil, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-250-[message]",
            options: nil, metrics: nil, views: views))
        


        

        
        NetworkController.sharedInstance.getStockInfoFromYahoo(ticker, stockLookup: { (stockJSON, error) -> () in
            if stockJSON != nil {
                self.watchList.insert(stockJSON!, atIndex: 0)
                let testForEmpty = self.watchList.first!.quote.isEmpty
                if  testForEmpty {
                    self.invalidTickerAlert( ticker )
                    self.watchList.removeAtIndex(0)
                    activityIndicator.stopAnimating()
                    message.hidden = true
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.tableView.reloadData()

                } else {
                  if self.isLoggedInToTwitter == true{
                    NetworkController.sharedInstance.overloadTwitter(ticker, trailingClosure: { (returnedTrendEngine, error) -> Void in
                       // if returnedTrendEngine != nil {
                            //returnedTrendEngine!.buildData()
                            self.engines.insert(returnedTrendEngine!, atIndex: 0)
                            activityIndicator.stopAnimating()
                            message.hidden = true
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            self.tableView.reloadData()
                       // }
                    })
                  }else{
                    activityIndicator.stopAnimating()
                    message.hidden = true
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    self.tableView.reloadData()
                  }
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
        return text.validateForTicker()
  }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        
    }
    
    //MARK: UIActionAlert
    func invalidTickerAlert( ticker : String ) {
        let alertController = UIAlertController(title: "\(ticker) is not a valid ticker", message: "Enter a valid ticker for search", preferredStyle: .Alert)
    
        let okButton = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            //dismiss alert and reset search bar text
            self.searchBar.text = ""
        }
        
        alertController.addAction(okButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
  
  
  func checkForAccountLogin(){
    let myAccountStore = ACAccountStore()
    //Create a variable of type ACAccountType by using the method accountTypeWithAccountTypeIdentifier thats in ACAccountStore
    let myAccountType = myAccountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    //this starts a new thread to access the account and do something with it in the clsure statement
    myAccountStore.requestAccessToAccountsWithType(myAccountType, options: nil) { (gotit: Bool , error: NSError!) -> Void in
      //If ACAccountStore was able to access the account the gotit boolean in the cluses will be true or false
      if gotit{
        
        //A user can have multiple accounts with each of these services, we load them all into the array.
        let accountsArray = myAccountStore.accountsWithAccountType(myAccountType)
        //make sure we got at least one account
        if accountsArray.isEmpty == true{
        
          self.isLoggedInToTwitter = false
        let alertForNoAccount = UIAlertController(title: "No Twitter Account!", message: "Please go to settings then navigate to the settings for your twitter account and sign in, thanks. ", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alertForNoAccount, animated: true, completion: { () -> Void in
          
          
          
        })
        let goToSettings = UIAlertAction(title: "Go To Setting", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        
          let goToSettingsBool = UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        
          
          
        })
          
          let cancelAction = UIAlertAction(title: "Umm.... Ok", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
            
            
            
          })
        alertForNoAccount.addAction(goToSettings)
          alertForNoAccount.addAction(cancelAction)
        }else{
          self.isLoggedInToTwitter = true
        }
      }
    }
    
  }


}
