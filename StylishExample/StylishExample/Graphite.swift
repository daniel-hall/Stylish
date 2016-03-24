//
//  Graphite.swift
//  FrameworkTest
//
//  Created by Daniel Hall on 3/20/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation
import UIKit

class Graphite : Theme {
    
    struct PrimaryBackgroundColor : MutableStyle {
        var properties = [String : Any]()
        init() {
            backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        }
    }
    
    struct SecondaryBackgroundColor : MutableStyle {
        var properties = [String : Any]()
        init() {
            backgroundColor = UIColor(white: 0.75, alpha: 1.0)
        }
    }
    
    struct HeaderText : MutableStyle {
        var properties = [String : Any]()
        init() {
            font = UIFont.systemFontOfSize(20.0)
            textColor = UIColor.darkGrayColor()
            textAlignment = .Left
        }
    }
    
    struct BodyText : MutableStyle {
        var properties = [String : Any]()
        init() {
            font = UIFont.systemFontOfSize(16.0)
            textColor = UIColor.grayColor()
            textAlignment = .Left
        }
    }
    
    struct ProgressBar : MutableStyle {
        var properties = [String : Any]()
        init() {
            progressColor = UIColor.grayColor()
            progressTrackColor = UIColor(white: 0.9, alpha: 1.0)
            progressCornerRadiusPercentage = 0.16
            cornerRadiusPercentage = 0.16
            borderWidth = 1.0
            borderColor = UIColor.grayColor()
        }
    }
    
    struct DefaultButton : MutableStyle {
        var properties = [String : Any]()
        init() {
            titleColorForNormalState = UIColor(red:0.21, green:0.29, blue:0.36, alpha:1.0)
            titleColorForHighlightedState = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
            titleColorForDisabledState = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
            cornerRadiusPercentage = 0.16
            borderWidth = 1.0
            borderColor = UIColor(red:0.21, green:0.29, blue:0.36, alpha:1.0)
        }
    }
    
    struct ThemeTitle : MutableStyle {
        var properties = [String : Any]()
        init() {
            text = "Graphite"
        }
    }
    
    struct ThemeImage : MutableStyle {
        var properties = [String : Any]()
        init() {
            let bundle = NSBundle(forClass: Aqua.self)
            image = UIImage(named: "stone", inBundle: bundle, compatibleWithTraitCollection: UIScreen.mainScreen().traitCollection)!
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
