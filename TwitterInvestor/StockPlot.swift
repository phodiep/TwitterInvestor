//
//  StockPlot.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

import UIKit
import QuartzCore

class StockPlot: UIView {
    
    var data = NSMutableArray()
    var context: CGContextRef?
    
    // sizes
    let padding = CGFloat(30)
    var graphWidth = CGFloat(0)
    var graphHeight = CGFloat(0)
    var axisWidth = CGFloat(0)
    var axisHeight = CGFloat(0)
    
    //graph style
    var showLines = true
    var showPoints = true
    var linesColor = UIColor.lightGrayColor()
    var axisColor = UIColor.grayColor()
    var graphColor = UIColor.blackColor()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, data: NSArray) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.data = data.mutableCopy() as NSMutableArray
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        context = UIGraphicsGetCurrentContext()
        
        //set size of graph
        self.graphWidth = rect.size.width
        self.graphHeight = rect.size.height
        self.axisWidth = rect.size.width
        self.axisHeight = rect.size.height
        
        //draw x/y axis of graph
        let axisPath = CGPathCreateMutable()
        CGPathMoveToPoint(axisPath, nil, 0, 0)  //start at 0,0
        CGPathMoveToPoint(axisPath, nil, 0, axisHeight)  //draw y-axis
        CGPathAddLineToPoint(axisPath, nil, axisWidth, axisHeight)  //draw x-axis
        CGContextAddPath(context, axisPath)
        CGContextSetStrokeColorWithColor(context, self.axisColor.CGColor)
        CGContextStrokePath(context)

        // label y axis and ticks
        var yLabelInterval = 1
        for i in 0...5 {
            let label = UILabel()
            label.text = "\(i)"
            label.backgroundColor = UIColor.whiteColor()
            label.textColor = UIColor.blackColor()
            label.textAlignment = NSTextAlignment.Right
            
            let yTickBuffer = floor(self.axisHeight) - (floor(self.axisHeight)/6 * CGFloat(i))
            label.frame = CGRectMake(0, yTickBuffer, 20, 20)
            addSubview(label)
            
            if i != 0 {
                let line = CGPathCreateMutable()
                CGPathMoveToPoint(line, nil, 0, yTickBuffer)
                CGPathAddLineToPoint(line, nil, axisWidth, yTickBuffer)
                CGContextAddPath(context, line)
                CGContextSetStrokeColorWithColor(context, self.linesColor.CGColor)
                CGContextStrokePath(context)
            }
        }
        
        // plot points
        let pointPath = CGPathCreateMutable()
        let firstPoint = (data[0] as NSDictionary).objectForKey("value") as NSNumber
        let initialY = CGFloat(firstPoint.floatValue)
        let initialX = CGFloat(showPoints ? 10:0)
        CGPathMoveToPoint(pointPath, nil, initialX, CGFloat(graphHeight) - initialY)
        
        
        for point in data {
            let interval = Int(graphWidth) / (data.count - 1)
            let pointValue = point.objectForKey("value") as NSNumber
            
            var yPosition = CGFloat(pointValue.floatValue)
            var xPosition = CGFloat(interval * data.indexOfObject(point))
            
            if data.indexOfObject(point) == 0 {
                xPosition += 10
            }
            
            let xLabel = UILabel()
            xLabel.text = point.objectForKey("label") as? String
            xLabel.frame = CGRectMake(xPosition - 10, graphHeight, 30, 20)
            xLabel.textAlignment = NSTextAlignment.Center
            addSubview(xLabel)
            
            //make point for plotting
            let pointMarker = CALayer()
            pointMarker.backgroundColor = backgroundColor?.CGColor
            pointMarker.cornerRadius = 8
            pointMarker.masksToBounds = true
            
            let markerInner = CALayer()
            markerInner.frame = CGRectMake(3, 3, 10, 10)
            markerInner.cornerRadius = 5
            markerInner.masksToBounds = true
            markerInner.backgroundColor = graphColor.CGColor
            pointMarker.addSublayer(markerInner)
            
            pointMarker.frame = CGRectMake(xPosition - 8, graphHeight - yPosition, 16,16)
            layer.addSublayer(pointMarker)
            
        }

        CGContextAddPath(context, pointPath)
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, graphColor.CGColor)
        CGContextStrokePath(context)
    
    
    
    }
    
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    

