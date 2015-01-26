//
//  Extensions.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/24/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import Foundation

extension String {
    
    func validateForTicker() -> Bool {
        let regex = NSRegularExpression(pattern: "[^A-Za-z0-9\n]", options: nil, error: nil)
        let elements = countElements(self)
        let range = NSMakeRange(0, elements)
        
        let matches = regex?.numberOfMatchesInString(self, options: nil, range: range)
        
        if matches > 0 {
            return false
        }
        return true
    }
    
}