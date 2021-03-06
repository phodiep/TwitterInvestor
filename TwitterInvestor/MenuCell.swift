//
//  MenuCell.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/23/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    var cellLabel = UILabel()
    
    override init() {
        super.init()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.cellLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(self.cellLabel)
        
        let views = ["cellLabel" : self.cellLabel]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[cellLabel]-16-|", options: nil, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[cellLabel]-|", options: nil, metrics: nil, views: views))

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
