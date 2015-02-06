//
//  HelpViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    let helpText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Help"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(helpText)

        self.setHelpText()
        
        self.helpText.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.helpText.font = UIFont.systemFontOfSize(16)
        self.helpText.scrollEnabled = true
        
        let views = ["helpText":helpText]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[helpText]|",
            options: nil, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[helpText]|",
            options: nil, metrics: nil, views: views))
    }

    func setHelpText() {
        helpText.text = "ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasvausdnvasvausdnvasv ausdnvasv ausdnvasv ausdnvasv ausdnvasv"
    }

}
