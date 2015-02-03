//
//  InterfaceController.swift
//  TweetFellows WatchKit Extension
//
//  Created by Bradley Johnson on 2/2/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

  @IBOutlet weak var myLabel: WKInterfaceLabel!
  @IBAction func didPressButton() {
    
    WKInterfaceController.openParentApplication(["Brad" : "Johnson"], reply: { (userInfo, error) -> Void in
      self.myLabel.setText("Replied")
    })
  }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
