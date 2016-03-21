//
//  Aqua.swift
//  FrameworkTest
//
//  Created by Daniel Hall on 3/20/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation
import UIKit

class Aqua : Theme {
    static func styleNamed(name: String) -> Style? {
        var style = Style()
        switch name {
        case "PrimaryBackgroundColor" :
            
            style.set(Stylish.UIView.BackgroundColor, to: UIColor(red:0.18, green:0.51, blue:0.72, alpha:1.0))
            
        case "SecondaryBackgroundColor" :
            
            style.set(Stylish.UIView.BackgroundColor, to: UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0))
            
        case "HeaderText" :
            
            style.set(Stylish.UILabel.Font, to: UIFont(name: "Futura-Medium", size: 20.0)!)
            style.set(Stylish.UILabel.TextColor, to: UIColor.whiteColor())
            style.set(Stylish.UILabel.TextAlignment, to:.Center)
            
        case "BodyText" :
            
            style.set(Stylish.UILabel.Font, to: UIFont(name: "Futura-Medium", size: 16.0)!)
            style.set(Stylish.UILabel.TextColor, to: UIColor.whiteColor())
            style.set(Stylish.UILabel.TextAlignment, to:.Justified)
            
        case "ProgressBar" :
            
            let context = CIContext()
            let stripesFilter = CIFilter(name: "CIStripesGenerator", withInputParameters: ["inputColor0" : CIColor(color: UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0)), "inputColor1" : CIColor(color: UIColor(red:0.60, green:0.89, blue:0.99, alpha:1.0)), "inputWidth" : 4])!
            let stripes = context.createCGImage(stripesFilter.outputImage!, fromRect: CGRect(origin: CGPointZero, size: CGSize(width: 32.0, height: 32.0)))
            let rotateFilter = CIFilter(name: "CIStraightenFilter", withInputParameters: ["inputImage" : CIImage(CGImage: stripes), "inputAngle" : 2.35])!
            let rotated = context.createCGImage(rotateFilter.outputImage!, fromRect: rotateFilter.outputImage!.extent)
            style.set(Stylish.ProgressBar.ProgressColor, to: UIColor(patternImage: UIImage(CGImage: rotated)))
            style.set(Stylish.ProgressBar.TrackColor, to: UIColor.whiteColor())
            style.set(Stylish.ProgressBar.ProgressCornerRadiusPercentage, to: 0.55)
            style.set(Stylish.UIView.CornerRadiusPercentage, to: 0.55)
            style.set(Stylish.UIView.BorderWidth, to:2.0)
            style.set(Stylish.UIView.BorderColor, to: UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0))
            
        case "DefaultButton" :
            
            style.set(Stylish.UIView.BackgroundColor, to: UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0))
            style.set(Stylish.UIView.CornerRadiusPercentage, to: 0.5)
            style.set(Stylish.UIButton.TitleColorForNormalState, to: UIColor.whiteColor())
            style.set(Stylish.UIButton.TitleColorForHighlightedState, to: UIColor(red:0.60, green:0.89, blue:0.99, alpha:1.0))
            
        case "ThemeTitle" :
            
            style.set(Stylish.UILabel.Text, to: "Aqua")
            
        case "ThemeImage" :
            
            let bundle = NSBundle(forClass: self)
            let image =  UIImage(named: "water", inBundle: bundle, compatibleWithTraitCollection: UIScreen.mainScreen().traitCollection)!
            style.set(Stylish.UIImageView.Image, to: image)
            
        default :
            return nil
        }
        
        return style
    }
}
