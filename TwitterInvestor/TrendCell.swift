//
//  TrendCell.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/27/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class TrendCell: UITableViewCell {
    
    var startLabel = UILabel()
    var endLabel = UILabel()
    var magnitudeLabel = UILabel()
    var averageLabel = UILabel()
    
    override init() {
        super.init()
        
        //set fonts
        
        //set transmask = false
        self.startLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.endLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.magnitudeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.averageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        //add to view
        contentView.addSubview(self.startLabel)
        contentView.addSubview(self.endLabel)
        contentView.addSubview(self.magnitudeLabel)
        contentView.addSubview(self.averageLabel)
        
        //autolayout
        let views = ["startLabel" : self.startLabel,
            "endLabel" : self.endLabel,
            "magnitudeLabel" : self.magnitudeLabel,
            "averageLabel" : self.averageLabel]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[startLabel]",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[endLabel]",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[magnitudeLabel]-16-[averageLabel]-16-|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[startLabel]-8-[endLabel]|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[startLabel]|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[endLabel]|",
            options: nil, metrics: nil, views: views))

        
        
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
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
}
