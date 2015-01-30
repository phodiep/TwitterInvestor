//
//  TweetCell.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/29/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    var tweetLabel = UILabel()
    var usernameLabel = UILabel()
    var dateLabel = UILabel()
    
    override init() {
        super.init()
        
        self.tweetLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        self.tweetLabel.textAlignment = NSTextAlignment.Left
        self.tweetLabel.numberOfLines = 0
        self.usernameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        self.usernameLabel.textAlignment = NSTextAlignment.Right
        self.dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        self.dateLabel.textAlignment = NSTextAlignment.Right

        
        self.tweetLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.usernameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.dateLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(self.tweetLabel)
        contentView.addSubview(self.usernameLabel)
        contentView.addSubview(self.dateLabel)
        
        let views = ["tweetLabel" : self.tweetLabel,
                    "usernameLabel" : self.usernameLabel,
                    "dateLabel" : self.dateLabel]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[tweetLabel]-16-|", options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[usernameLabel]", options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[dateLabel]-16-|", options: nil, metrics: nil, views: views))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[tweetLabel(50)]-[usernameLabel(30)]-|", options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[tweetLabel(50)]-[dateLabel(30)]-|", options: nil, metrics: nil, views: views))

    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
