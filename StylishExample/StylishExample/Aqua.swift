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
    
    struct PrimaryBackgroundColor : MutableStyle {
        var properties = [String : Any]()
        init() {
            backgroundColor = UIColor(red:0.18, green:0.51, blue:0.72, alpha:1.0)
        }
    }
    
    struct SecondaryBackgroundColor : MutableStyle {
        var properties = [String : Any]()
        init() {
            backgroundColor = UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0)
        }
    }
    
    struct HeaderText : MutableStyle {
        var properties = [String : Any]()
        init() {
            font = UIFont(name: "Futura-Medium", size: 20.0)!
            textColor = UIColor.whiteColor()
            textAlignment = .Center
        }
    }
    
    struct BodyText : MutableStyle {
        var properties = [String : Any]()
        init() {
            font = UIFont(name: "Futura-Medium", size: 16.0)!
            textColor = UIColor.whiteColor()
            textAlignment = .Justified
        }
    }
    
    struct ProgressBar : MutableStyle {
        var properties = [String : Any]()
        init() {
            let context = CIContext()
            let stripesFilter = CIFilter(name: "CIStripesGenerator", withInputParameters: ["inputColor0" : CIColor(color: UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0)), "inputColor1" : CIColor(color: UIColor(red:0.60, green:0.89, blue:0.99, alpha:1.0)), "inputWidth" : 4])!
            let stripes = context.createCGImage(stripesFilter.outputImage!, fromRect: CGRect(origin: CGPointZero, size: CGSize(width: 32.0, height: 32.0)))
            let rotateFilter = CIFilter(name: "CIStraightenFilter", withInputParameters: ["inputImage" : CIImage(CGImage: stripes), "inputAngle" : 2.35])!
            let rotated = context.createCGImage(rotateFilter.outputImage!, fromRect: rotateFilter.outputImage!.extent)
            progressColor = UIColor(patternImage: UIImage(CGImage: rotated))
            progressTrackColor = UIColor.whiteColor()
            progressCornerRadiusPercentage = 0.55
            cornerRadiusPercentage = 0.55
            borderWidth = 2.0
            borderColor = UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0)
        }
    }
    
    struct DefaultButton : MutableStyle {
        var properties = [String : Any]()
        init() {
            backgroundColor = UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0)
            cornerRadiusPercentage = 0.5
            titleColorForNormalState = UIColor.whiteColor()
            titleColorForHighlightedState = UIColor(red:0.60, green:0.89, blue:0.99, alpha:1.0)
        }
    }
    
    struct ThemeTitle : MutableStyle {
        var properties = [String : Any]()
        init() {
            text = "Aqua"
        }
    }
    
    struct ThemeImage : MutableStyle {
        var properties = [String : Any]()
        init() {
            let bundle = NSBundle(forClass: Aqua.self)
            image = UIImage(named: "water", inBundle: bundle, compatibleWithTraitCollection: UIScreen.mainScreen().traitCollection)!
        }
    }
    

    required init() {}

    func styleNamed(name: String) -> Style? {
        switch name {
        case _ where name.isVariantOf("Primary Background Color") :
            return PrimaryBackgroundColor()
        case _ where name.isVariantOf("Secondary Background Color") :
            return SecondaryBackgroundColor()
        case _ where name.isVariantOf("Header Text") :
            return HeaderText()
        case _ where name.isVariantOf("Body Text") :
            return BodyText()
        case _ where name.isVariantOf("Progress Bar") :
            return ProgressBar()
        case _ where name.isVariantOf("Default Button") :
            return DefaultButton()
        case _ where name.isVariantOf("Theme Title") :
            return ThemeTitle()
        case _ where name.isVariantOf("Theme Image") :
            return ThemeImage()
        default :
            return nil
        }
    }
}
