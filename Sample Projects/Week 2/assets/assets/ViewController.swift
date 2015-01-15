//
//  ViewController.swift
//  assets
//
//  Created by Bradley Johnson on 1/15/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView.image = UIImage(named: "richard.jpg")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

