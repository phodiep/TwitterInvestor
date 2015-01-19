//
//  ViewController.swift
//  assets
//
//  Created by Bradley Johnson on 1/15/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var myButton: UIButton!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    println(myButton.layoutMargins.top)
    myButton.contentEdgeInsets.top = 40
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

