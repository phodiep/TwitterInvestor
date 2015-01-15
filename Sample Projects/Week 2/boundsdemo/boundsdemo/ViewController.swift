//
//  ViewController.swift
//  boundsdemo
//
//  Created by Bradley Johnson on 1/15/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let blueView = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 400))
    blueView.backgroundColor = UIColor.blueColor()
    self.view.addSubview(blueView)
    
    let redView = UIView(frame: CGRect(x: 100, y: 50, width: 25, height: 25))
    redView.backgroundColor = UIColor.redColor()
    blueView.addSubview(redView)
    
    blueView.bounds = CGRect(x: -50, y: 0, width: 200, height: 400)
    self.view.bounds = CGRect(x: 0, y: -150, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
    
    
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

