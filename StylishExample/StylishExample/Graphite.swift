//
//  Graphite.swift
//  FrameworkTest
//
//  Created by Daniel Hall on 3/20/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation
import UIKit

class Graphite : Stylesheet {
    
    struct PrimaryBackgroundColor : MutableStyleClass {
        var properties = [String : Any]()
        init() {
            backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        }
    }
    
    struct SecondaryBackgroundColor : MutableStyleClass {
        var properties = [String : Any]()
        init() {
            backgroundColor = UIColor(white: 0.75, alpha: 1.0)
        }
    }
    
    struct HeaderText : MutableStyleClass {
        var properties = [String : Any]()
        init() {
            font = UIFont.systemFontOfSize(20.0)
            textColor = UIColor.darkGrayColor()
            textAlignment = .Left
        }
    }
    
    struct BodyText : MutableStyleClass {
        var properties = [String : Any]()
        init() {
            font = UIFont.systemFontOfSize(16.0)
            textColor = UIColor.grayColor()
            textAlignment = .Left
        }
    }
    
    struct ProgressBar : MutableStyleClass {
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
    
    struct DefaultButton : MutableStyleClass {
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
    
    struct StylesheetTitle : MutableStyleClass {
        var properties = [String : Any]()
        init() {
            text = "Graphite"
        }
    }
    
    struct ThemeImage : MutableStyleClass {
        var properties = [String : Any]()
        init() {
            let bundle = NSBundle(forClass: Aqua.self)
            image = UIImage(named: "stone", inBundle: bundle, compatibleWithTraitCollection: UIScreen.mainScreen().traitCollection)!
        }
    }
    
    
    let styleClasses:[(identifier:String, styleClass:StyleClass)]
    
    required init() {
        styleClasses = [("Primary Background Color", PrimaryBackgroundColor()), ("Secondary Background Color", SecondaryBackgroundColor()), ("Header Text", HeaderText()), ("Body Text", BodyText()), ("Progress Bar", ProgressBar()), ("Default Button", DefaultButton()), ("Stylesheet Title", StylesheetTitle()), ("Theme Image", ThemeImage())]
    }
    
}
