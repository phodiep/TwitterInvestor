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
    var priceLabel = UILabel()

    override init() {
        super.init()
        


        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tickerLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        companyNameLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        priceLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        changeLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        
        tickerLabel.textAlignment = NSTextAlignment.Left
        companyNameLabel.textAlignment = NSTextAlignment.Left
        priceLabel.textAlignment = NSTextAlignment.Right
        changeLabel.textAlignment = NSTextAlignment.Right
        
        
        self.tickerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.companyNameLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.changeLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.priceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(self.tickerLabel)
        contentView.addSubview(self.companyNameLabel)
        contentView.addSubview(self.changeLabel)
        contentView.addSubview(self.priceLabel)
        
        let views = ["tickerLabel" : self.tickerLabel,
            "companyNameLabel" : self.companyNameLabel,
            "changeLabel" : self.changeLabel,
            "priceLabel" : self.priceLabel]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-18-[tickerLabel(55)]-8-[priceLabel(75)]-8-[changeLabel(75)]-8-[companyNameLabel]",
            options: nil, metrics: nil, views: views))
        
        //        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        //            "H:|-115-[priceLabel]-16-[changeLabel]",
        //            options: nil, metrics: nil, views: views))
        
        
        //        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        //            "H:[companyNameLabel]-16-|",
        //            options: nil, metrics: nil, views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[tickerLabel]|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[changeLabel]|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[companyNameLabel]|",
            options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[priceLabel]|",
            options: nil, metrics: nil, views: views))
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
