//
//  MenuViewController.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let rootView = UIView()
    
    override func loadView() {
        self.rootView.frame = UIScreen.mainScreen().bounds
        
        
        
        self.view = self.rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Main Menu"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func applyAutolayoutConstraints() {
        
    }


}
