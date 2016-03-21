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
    static func styleNamed(name: String) -> Style? {
        var style = Style()
        switch name {
        case "PrimaryBackgroundColor" :
            
            style.set(Stylish.UIView.BackgroundColor, to: UIColor(white: 0.9, alpha: 1.0))
            
        case "SecondaryBackgroundColor" :
            
            style.set(Stylish.UIView.BackgroundColor, to: UIColor(white: 0.75, alpha: 1.0))
            
        case "HeaderText" :
            
            style.set(Stylish.UILabel.Font, to: UIFont.systemFontOfSize(20.0))
            style.set(Stylish.UILabel.TextColor, to: UIColor.darkGrayColor())
            style.set(Stylish.UILabel.TextAlignment, to:.Left)
            
        case "BodyText" :
            
            style.set(Stylish.UILabel.Font, to: UIFont.systemFontOfSize(16.0))
            style.set(Stylish.UILabel.TextColor, to: UIColor.grayColor())
            style.set(Stylish.UILabel.TextAlignment, to:.Left)
            
        case "ProgressBar" :
            
            style.set(Stylish.ProgressBar.ProgressColor, to: UIColor.grayColor())
            style.set(Stylish.ProgressBar.TrackColor, to: UIColor(white: 0.9, alpha: 1.0))
            style.set(Stylish.ProgressBar.ProgressCornerRadiusPercentage, to: 0.16)
            style.set(Stylish.UIView.CornerRadiusPercentage, to: 0.16)
            style.set(Stylish.UIView.BorderWidth, to:1.0)
            style.set(Stylish.UIView.BorderColor, to: UIColor.grayColor())
            
        case "DefaultButton" :
            
            style.set(Stylish.UIButton.TitleColorForNormalState, to: UIColor(red:0.21, green:0.29, blue:0.36, alpha:1.0))
            style.set(Stylish.UIButton.TitleColorForHighlightedState, to: UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0))
            style.set(Stylish.UIButton.TitleColorForDisabledState, to: UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0))
            style.set(Stylish.UIView.CornerRadiusPercentage, to: 0.16)
            style.set(Stylish.UIView.BorderWidth, to:1.0)
            style.set(Stylish.UIView.BorderColor, to: UIColor(red:0.21, green:0.29, blue:0.36, alpha:1.0))
            
        case "ThemeTitle" :
            
            style.set(Stylish.UILabel.Text, to: "Graphite")
            
        case "ThemeImage" :
            
            let bundle = NSBundle(forClass: self)
            let image =  UIImage(named: "stone", inBundle: bundle, compatibleWithTraitCollection: UIScreen.mainScreen().traitCollection)!
            style.set(Stylish.UIImageView.Image, to: image)
            
        default :
            
            return nil
            
        }
        
        return style
    }
}
