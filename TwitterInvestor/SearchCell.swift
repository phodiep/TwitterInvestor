//
//  SearchCell.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    var tickerLabel = UILabel()
    var companyNameLabel = UILabel()
    var changeLabel = UILabel()
    var change: Float!

    override init() {
        super.init()
        
        self.tickerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.companyNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.changeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(self.tickerLabel)
        contentView.addSubview(self.companyNameLabel)
        contentView.addSubview(self.changeLabel)
        
        let views = ["tickerLabel" : self.tickerLabel,
            "companyNameLabel" : self.companyNameLabel,
            "changeLabel" : self.changeLabel]

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[tickerLabel]-(16)-[changeLabel]",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[companyNameLabel]-16-|",
            options: nil, metrics: nil, views: views))

        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[tickerLabel]|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[changeLabel]|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[companyNameLabel]|",
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
