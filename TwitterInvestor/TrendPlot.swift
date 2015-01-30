//
//  TrendPlot.swift
//  TwitterInvestor
//
//  Created by Pho Diep on 1/29/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//
//  adopted from https://github.com/tmdvs/CoreGraphicsGraph
//  credit to Tim Davies

import UIKit
import QuartzCore

class TrendPlot: UIView {
    
    private var data = NSMutableArray()
    private var context : CGContextRef?
    
    // plot size
    private let padding     : CGFloat = 32
    private var graphWidth  : CGFloat = 0
    private var graphHeight : CGFloat = 0
    private var axisWidth   : CGFloat = 0
    private var axisHeight  : CGFloat = 0
    private var everest     : CGFloat = 0
    
    // style settings
    var linesColor  = UIColor(white: 0.9, alpha: 1)
    var axisColor   = UIColor.grayColor()
    var graphColor  = UIColor.blackColor()
    var labelFont   = UIFont.systemFontOfSize(8)
    var labelColor  = UIColor.blackColor()
    
    var xTickCount = 0
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, data: NSArray) {
        
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()//whiteColor()
        self.data = data.mutableCopy() as NSMutableArray
        
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        context = UIGraphicsGetCurrentContext()
        
        // Graph size
        graphWidth = (rect.size.width - padding) - 10
        graphHeight = rect.size.height - 40
        axisWidth = rect.size.width - 10
        axisHeight = (rect.size.height - padding) - 10
        
        //find max count for y-axis range
        for point in data {
            let n : Int = (point.objectForKey("count") as NSNumber).integerValue
            if CGFloat(n) > everest {
                everest = CGFloat(Int(ceilf(Float(n))))
            }
        }
        
        // Label y-axis
        let yAxisLabel = UILabel()
        yAxisLabel.text = "Tweets / Hour"
        yAxisLabel.font = UIFont.systemFontOfSize(10)
        yAxisLabel.textColor = UIColor.blackColor()

//        yAxisLabel.backgroundColor = UIColor.redColor()
        yAxisLabel.textAlignment = NSTextAlignment.Center
        yAxisLabel.layer.anchorPoint = CGPoint(x: 0, y: 0)
        yAxisLabel.transform = CGAffineTransformMakeRotation(4.7124)
        yAxisLabel.frame = CGRectMake(0, graphHeight, padding/2, axisHeight)
        addSubview(yAxisLabel)
        
        // Draw graph x/y axis
        let axisPath = CGPathCreateMutable()
        CGPathMoveToPoint(axisPath, nil, padding, 10)
        CGPathAddLineToPoint(axisPath, nil, padding, rect.size.height - 31)
        CGPathAddLineToPoint(axisPath, nil, axisWidth, rect.size.height - 31)
        CGContextAddPath(context, axisPath)
        
        CGContextSetStrokeColorWithColor(context, axisColor.CGColor)
        CGContextStrokePath(context)
        
        // Draw y axis labels and lines
        var yLabelInterval : Int = Int(ceil(everest / 5))
        for i in 0...5 {
            
            let label = axisLabel(NSString(format: "%d", i * yLabelInterval))
            label.frame = CGRectMake(0,
                floor((rect.size.height - padding) - CGFloat(i) * (axisHeight / 5) - 10)
                , 20, 20)
            addSubview(label)
            
            if i != 0 {
                let line = CGPathCreateMutable()
                CGPathMoveToPoint(line, nil, padding + 1, floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5)))
                CGPathAddLineToPoint(line, nil, axisWidth, floor(rect.size.height - padding) - (CGFloat(i) * (axisHeight / 5)))
                CGContextAddPath(context, line)
                CGContextSetStrokeColorWithColor(context, linesColor.CGColor)
                CGContextStrokePath(context)
            }
        }
        
        // Lets move to the first point
        let pointPath = CGPathCreateMutable()
        let firstPoint = (data[0] as NSDictionary).objectForKey("count") as NSNumber
        let initialY :
        CGFloat = ceil((CGFloat(firstPoint.integerValue as Int) * (axisHeight / everest))) - 10
        let initialX : CGFloat = padding
        CGPathMoveToPoint(pointPath, nil, initialX, graphHeight - initialY)
        
        // Loop over the remaining values
        for point in data {
            plotPoint(point as NSDictionary, path: pointPath)
        }
        
        // Set stroke colours and stroke the values path
        CGContextAddPath(context, pointPath)
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, graphColor.CGColor)
        CGContextStrokePath(context)
    }
    
    
    // Plot a point on the graph
    func plotPoint(point : NSDictionary, path: CGMutablePathRef) {
        
        // work out the distance to draw the remaining points at
        let interval = (axisWidth) / 120 //(data.count - 1)
        
        let pointValue = point.objectForKey("count") as NSNumber
        
        // Calculate X and Y positions
        var yposition : CGFloat = ceil((CGFloat(pointValue.integerValue as Int) * (axisHeight / everest))) - 10
        var xposition : CGFloat = CGFloat(Int(interval) * (data.indexOfObject(point))) + padding
        
        
        // Draw line to this value
        CGPathAddLineToPoint(path, nil, xposition, graphHeight - yposition);
        
        xTickCount += 1
        if xTickCount >= 10 {
            let xLabel = axisLabel(point.objectForKey("date") as NSString )
            xLabel.frame = CGRectMake(xposition - 17, graphHeight + 20, 38, 20)
            xLabel.textAlignment = NSTextAlignment.Center
            xLabel.transform = CGAffineTransformMakeRotation(0.785)
            addSubview(xLabel)
            xTickCount = 0
        }
        
    }
    
    
    // Returns an axis label
    func axisLabel(title: NSString) -> UILabel {
        let label = UILabel(frame: CGRectZero)
        label.text = title
        label.font = labelFont
        label.textColor = labelColor
        label.backgroundColor = UIColor.clearColor()  //backgroundColor
        label.textAlignment = NSTextAlignment.Right
        
        return label
    }
    
    
    // Returns a point for plotting
    func valueMarker() -> CALayer {
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
        
        return pointMarker
    }
    
}

