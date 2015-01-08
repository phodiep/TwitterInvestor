//
//  TweetCell.swift
//  TweetFellows
//
//  Created by Bradley Johnson on 1/5/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetLabel: UILabel!
  @IBOutlet weak var tweetImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  //fix for automatic height issue
  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.layoutIfNeeded()
    self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.width
  }

}
