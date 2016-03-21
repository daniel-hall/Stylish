//
//  Stylish.swift
//  Stylish
//
//  Created by Daniel Hall on 3/19/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Style -

struct Style {
    private var properties = [String:Any]()
    
    mutating func set<T:StyleProperty>(property:T.Type, to:T.ValueType) {
        properties[String(T)] = property.self.init(value:to)
    }
    
    func valueFor<T:StyleProperty>(property:T.Type)->T.ValueType? {
        if let result = properties[String(T)] as? T {
            return result.value
        }
        return nil
    }
}

func +(left:Style, right:Style) -> Style {
    var newStyle = Style()
    newStyle.properties = left.properties
    for (key, value) in right.properties {
        newStyle.properties.updateValue(value, forKey: key)
    }
    return newStyle
}


// MARK: - Styleable -

protocol Styleable {
    func applyStyle(style:Style)
}

extension Styleable where Self:UIView {
    
    func parseAndApplyStyles(styles:String, usingTheme themeName:String) {
        var theme:Theme.Type? = themeName == "" ? Stylish.DefaultTheme.self : nil
        print(theme)
        if let moduleName = _stdlib_getDemangledTypeName(Stylish.BundleMarker()).componentsSeparatedByString(".").first where theme == nil {
            theme = NSClassFromString("\(moduleName).\(themeName)") as? Theme.Type
        }
        let components = styles.stringByReplacingOccurrencesOfString(" ", withString: "").componentsSeparatedByString(",")
        var composedStyle = Style()
        for string in components where string != "" {
            if let style = theme?.styleNamed(string) {
                composedStyle = composedStyle + style
            }
        }
        self.applyStyle(composedStyle)
    }
    
    func showErrorIfInvalidStyles(styles:String, usingTheme themeName:String) {
        var theme:Theme.Type? = themeName == "" ? Stylish.DefaultTheme.self : nil
        if let moduleName = _stdlib_getDemangledTypeName(Stylish.BundleMarker()).componentsSeparatedByString(".").first where theme == nil {
            theme = NSClassFromString("\(moduleName).\(themeName)") as? Theme.Type
        }
        var invalidStyle = false
        for subview in subviews {
            if subview.tag == Stylish.ErrorViewTag {
                subview.removeFromSuperview()
            }
        }
        let components = styles.stringByReplacingOccurrencesOfString(" ", withString: "").componentsSeparatedByString(",")
        for string in components where string != "" {
            if theme?.styleNamed(string) == nil {
                invalidStyle = true
            }
        }
        if invalidStyle {
            let errorView = Stylish.ErrorView(frame: bounds)
            errorView.tag = Stylish.ErrorViewTag
            addSubview(errorView)
        }
    }
}


// MARK: - Theme -

protocol Theme {
    static func styleNamed(name:String)->Style?
}

struct Stylish {
    
    private class BundleMarker {}
    
    struct DefaultTheme : Theme {
        static func styleNamed(name:String)->Style? {
            if let info = NSBundle(forClass:Stylish.BundleMarker.self).infoDictionary, let moduleName = _stdlib_getDemangledTypeName(Stylish.BundleMarker()).componentsSeparatedByString(".").first, themeName = info["Theme"] as? String, let theme = NSClassFromString("\(moduleName).\(themeName)") as? Theme.Type {
                return theme.styleNamed(name)
            }
            return nil
        }
    }
}

// MARK: - Style Property -

protocol StyleProperty {
    typealias ValueType
    var value:ValueType { get }
    init(value:ValueType)
}


// MARK: - Stylish Error View -

extension Stylish {
    private static let ErrorViewTag = 7331
    
    class ErrorView:UIKit.UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        private func setup() {
            let context = CIContext()
            let stripesFilter = CIFilter(name: "CIStripesGenerator", withInputParameters: ["inputColor0" : CIColor(color: UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.4)), "inputColor1" : CIColor(color: UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.6)), "inputWidth" : 2])!
            let stripes = context.createCGImage(stripesFilter.outputImage!, fromRect: CGRect(origin: CGPointZero, size: CGSize(width: 32.0, height: 32.0)))
            let rotateFilter = CIFilter(name: "CIStraightenFilter", withInputParameters: ["inputImage" : CIImage(CGImage: stripes), "inputAngle" : 2.35])!
            let rotated = context.createCGImage(rotateFilter.outputImage!, fromRect: rotateFilter.outputImage!.extent)
            let stripesView = UIKit.UIView()
            stripesView.backgroundColor = UIColor(patternImage: UIImage(CGImage: rotated))
            stripesView.frame = bounds
            addSubview(stripesView)
        }
    }
}


// MARK: - Styleable UIKit Subclasses -

// MARK: UIView

extension Stylish {
    
    struct UIView {
        
        static func ApplyStyle(style:Style, toView view:UIKit.UIView) {
            view.backgroundColor = style.valueFor(Stylish.UIView.BackgroundColor) ?? view.backgroundColor
            view.contentMode = style.valueFor(Stylish.UIView.ContentMode) ?? view.contentMode
            view.userInteractionEnabled = style.valueFor(Stylish.UIView.UserInteractionEnabled) ?? view.userInteractionEnabled
            view.hidden = style.valueFor(Stylish.UIView.Hidden) ?? view.hidden
            view.layer.borderColor = style.valueFor(Stylish.UIView.BorderColor)?.CGColor ?? view.layer.backgroundColor
            view.layer.borderWidth = style.valueFor(Stylish.UIView.BorderWidth) ?? view.layer.borderWidth
            if let percentage = style.valueFor(Stylish.UIView.CornerRadiusPercentage) {
                view.layer.cornerRadius = view.bounds.height * percentage
            }
            view.layer.cornerRadius = style.valueFor(Stylish.UIView.CornerRadius) ?? view.layer.cornerRadius
            view.alpha = style.valueFor(Stylish.UIView.Alpha) ?? view.alpha
            view.tintColor = style.valueFor(Stylish.UIView.TintColor) ?? view.tintColor
            view.layoutMargins = style.valueFor(Stylish.UIView.LayoutMargins) ?? view.layoutMargins
            if let customStyleBlock = style.valueFor(Stylish.UIView.CustomStyleBlock) {
                customStyleBlock(view)
            }
        }
        
        static var CustomStyleBlock:Properties.CustomStyleBlock.Type { get { return Properties.CustomStyleBlock.self } }
        static var BackgroundColor:Properties.BackgroundColor.Type { get { return Properties.BackgroundColor.self } }
        static var ContentMode:Properties.ContentMode.Type { get { return Properties.ContentMode.self } }
        static var UserInteractionEnabled:Properties.UserInteractionEnabled.Type { get { return Properties.UserInteractionEnabled.self } }
        static var Hidden:Properties.Hidden.Type { get { return Properties.Hidden.self } }
        static var BorderColor:Properties.BorderColor.Type { get { return Properties.BorderColor.self } }
        static var BorderWidth:Properties.BorderWidth.Type { get { return Properties.BorderWidth.self } }
        static var CornerRadius:Properties.CornerRadius.Type { get { return Properties.CornerRadius.self } }
        static var CornerRadiusPercentage:Properties.CornerRadiusPercentage.Type { get { return Properties.CornerRadiusPercentage.self } }
        static var Alpha:Properties.Alpha.Type { get { return Properties.Alpha.self } }
        static var LayoutMargins:Properties.LayoutMargins.Type { get { return Properties.LayoutMargins.self } }
        static var TintColor:Properties.TintColor.Type { get { return Properties.TintColor.self } }
        
        struct Properties {
            struct CustomStyleBlock:StyleProperty {
                let value:UIKit.UIView->()
                init(value:UIKit.UIView->()) {
                    self.value = value
                }
            }
            struct BackgroundColor:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct ContentMode:StyleProperty {
                let value:UIViewContentMode
                init(value:UIViewContentMode) {
                    self.value = value
                }
            }
            struct UserInteractionEnabled:StyleProperty {
                let value:Bool
                init(value:Bool) {
                    self.value = value
                }
            }
            struct Hidden:StyleProperty {
                let value:Bool
                init(value:Bool) {
                    self.value = value
                }
            }
            struct BorderColor:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct BorderWidth:StyleProperty {
                let value:CGFloat
                init(value:CGFloat) {
                    self.value = value
                }
            }
            struct CornerRadius:StyleProperty {
                let value:CGFloat
                init(value:CGFloat) {
                    self.value = value
                }
            }
            struct CornerRadiusPercentage:StyleProperty {
                let value:CGFloat
                init(value:CGFloat) {
                    self.value = value
                }
            }
            struct Alpha:StyleProperty {
                let value:CGFloat
                init(value:CGFloat) {
                    self.value = value
                }
            }
            struct TintColor:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct LayoutMargins:StyleProperty {
                let value:UIEdgeInsets
                init(value:UIEdgeInsets) {
                    self.value = value
                }
            }
        }
    }
}

@IBDesignable class StyleableUIView : UIView, Styleable {
    
    @IBInspectable var styles:String! = "" {
        didSet {
            parseAndApplyStyles(styles, usingTheme: theme)
        }
    }
    
    @IBInspectable var theme:String! = "" {
        didSet {
            parseAndApplyStyles(styles, usingTheme: theme)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles(styles, usingTheme: theme)
    }
    
    func applyStyle(style: Style) {
        Stylish.UIView.ApplyStyle(style, toView: self)
    }
}


// MARK: UILabel

extension Stylish {
    
    struct UILabel {
        
        static func ApplyStyle(style:Style, toLabel label:UIKit.UILabel) {
            Stylish.UIView.ApplyStyle(style, toView:label)
            label.textColor = style.valueFor(Stylish.UILabel.TextColor) ?? label.textColor
            label.font = style.valueFor(Stylish.UILabel.Font) ?? label.font
            label.enabled = style.valueFor(Stylish.UILabel.Enabled) ?? label.enabled
            label.textAlignment = style.valueFor(Stylish.UILabel.TextAlignment) ?? label.textAlignment
            label.text = style.valueFor(Stylish.UILabel.Text) ?? label.text
            label.highlighted = style.valueFor(Stylish.UILabel.Highlighted) ?? label.highlighted
            label.highlightedTextColor = style.valueFor(Stylish.UILabel.HighlightedTextColor) ?? label.highlightedTextColor
            if let customStyleBlock = style.valueFor(Stylish.UILabel.CustomStyleBlock) {
                customStyleBlock(label)
            }
        }
        
        static var CustomStyleBlock:Properties.CustomStyleBlock.Type { get { return Properties.CustomStyleBlock.self } }
        static var TextColor:Properties.TextColor.Type { get { return Properties.TextColor.self } }
        static var Font:Properties.Font.Type { get { return Properties.Font.self } }
        static var Enabled:Properties.Enabled.Type { get { return Properties.Enabled.self } }
        static var TextAlignment:Properties.TextAlignment.Type { get { return Properties.TextAlignment.self } }
        static var Text:Properties.Text.Type { get { return Properties.Text.self } }
        static var Highlighted:Properties.Highlighted.Type { get { return Properties.Highlighted.self } }
        static var HighlightedTextColor:Properties.HighlightedTextColor.Type { get { return Properties.HighlightedTextColor.self } }
        
        struct Properties {
            struct CustomStyleBlock:StyleProperty {
                let value:UIKit.UILabel->()
                init(value:UIKit.UILabel->()) {
                    self.value = value
                }
            }
            struct TextColor:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct Font:StyleProperty {
                let value:UIFont
                init(value:UIFont) {
                    self.value = value
                }
            }
            struct Enabled:StyleProperty {
                let value:Bool
                init(value:Bool) {
                    self.value = value
                }
            }
            struct TextAlignment:StyleProperty {
                let value:NSTextAlignment
                init(value:NSTextAlignment) {
                    self.value = value
                }
            }
            struct Text:StyleProperty {
                let value:String
                init(value:String) {
                    self.value = value
                }
            }
            struct Highlighted:StyleProperty {
                let value:Bool
                init(value:Bool) {
                    self.value = value
                }
            }
            struct HighlightedTextColor:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
        }
    }
}


@IBDesignable class StyleableUILabel : UILabel, Styleable {
    
    @IBInspectable var styles:String! = "" {
        didSet {
            parseAndApplyStyles(styles, usingTheme: theme)
        }
    }
    
    @IBInspectable var theme:String! = "" {
        didSet {
            parseAndApplyStyles(styles, usingTheme: theme)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles(styles, usingTheme: theme)
    }
    
    func applyStyle(style: Style) {
        Stylish.UILabel.ApplyStyle(style, toLabel: self)
    }
}


// MARK: UIButton

extension Stylish {
    
    struct UIButton {
        
        static func ApplyStyle(style:Style, toButton button:UIKit.UIButton) {
            Stylish.UIView.ApplyStyle(style, toView:button)
            button.contentEdgeInsets = style.valueFor(Stylish.UIButton.ContentEdgeInsets) ?? button.contentEdgeInsets
            button.titleEdgeInsets = style.valueFor(Stylish.UIButton.TitleEdgeInsets) ?? button.titleEdgeInsets
            button.imageEdgeInsets = style.valueFor(Stylish.UIButton.ImageEdgeInsets) ?? button.imageEdgeInsets
            button.setTitle(style.valueFor(Stylish.UIButton.TitleForNormalState) ?? button.titleForState(.Normal), forState: .Normal)
            button.setTitle(style.valueFor(Stylish.UIButton.TitleForHighlightedState) ?? button.titleForState(.Highlighted), forState: .Highlighted)
            button.setTitle(style.valueFor(Stylish.UIButton.TitleForDisabledState) ?? button.titleForState(.Disabled), forState: .Disabled)
            button.setTitleColor(style.valueFor(Stylish.UIButton.TitleColorForNormalState) ?? button.titleColorForState(.Normal), forState: .Normal)
            button.setTitleColor(style.valueFor(Stylish.UIButton.TitleColorForHighlightedState) ?? button.titleColorForState(.Highlighted), forState: .Highlighted)
            button.setTitleColor(style.valueFor(Stylish.UIButton.TitleColorForDisabledState) ?? button.titleColorForState(.Disabled), forState: .Disabled)
            button.setImage(style.valueFor(Stylish.UIButton.ImageForNormalState) ?? button.imageForState(.Normal), forState: .Normal)
            button.setImage(style.valueFor(Stylish.UIButton.ImageForHighlightedState) ?? button.imageForState(.Highlighted), forState: .Highlighted)
            button.setImage(style.valueFor(Stylish.UIButton.ImageForDisabledState) ?? button.imageForState(.Disabled), forState: .Disabled)
            button.setBackgroundImage(style.valueFor(Stylish.UIButton.BackgroundImageForNormalState) ?? button.backgroundImageForState(.Normal), forState: .Normal)
            button.setBackgroundImage(style.valueFor(Stylish.UIButton.BackgroundImageForHighlightedState) ?? button.backgroundImageForState(.Highlighted), forState: .Highlighted)
            button.setBackgroundImage(style.valueFor(Stylish.UIButton.BackgroundImageForDisabledState) ?? button.backgroundImageForState(.Disabled), forState: .Disabled)
            if let customStyleBlock = style.valueFor(Stylish.UIButton.CustomStyleBlock) {
                customStyleBlock(button)
            }
        }
        
        static var CustomStyleBlock:Properties.CustomStyleBlock.Type { get { return Properties.CustomStyleBlock.self } }
        static var ContentEdgeInsets:Properties.ContentEdgeInsets.Type { get { return Properties.ContentEdgeInsets.self } }
        static var TitleEdgeInsets:Properties.TitleEdgeInsets.Type { get { return Properties.TitleEdgeInsets.self } }
        static var ImageEdgeInsets:Properties.ImageEdgeInsets.Type { get { return Properties.ImageEdgeInsets.self } }
        static var TitleForNormalState:Properties.TitleForNormalState.Type { get { return Properties.TitleForNormalState.self } }
        static var TitleForHighlightedState:Properties.TitleForHighlightedState.Type { get { return Properties.TitleForHighlightedState.self } }
        static var TitleForDisabledState:Properties.TitleForDisabledState.Type { get { return Properties.TitleForDisabledState.self } }
        static var TitleColorForNormalState:Properties.TitleColorForNormalState.Type { get { return Properties.TitleColorForNormalState.self } }
        static var TitleColorForHighlightedState:Properties.TitleColorForHighlightedState.Type { get { return Properties.TitleColorForHighlightedState.self } }
        static var TitleColorForDisabledState:Properties.TitleColorForDisabledState.Type { get { return Properties.TitleColorForDisabledState.self } }
        static var ImageForNormalState:Properties.ImageForNormalState.Type { get { return Properties.ImageForNormalState.self } }
        static var ImageForHighlightedState:Properties.ImageForHighlightedState.Type { get { return Properties.ImageForHighlightedState.self } }
        static var ImageForDisabledState:Properties.ImageForDisabledState.Type { get { return Properties.ImageForDisabledState.self } }
        static var BackgroundImageForNormalState:Properties.BackgroundImageForNormalState.Type { get { return Properties.BackgroundImageForNormalState.self } }
        static var BackgroundImageForHighlightedState:Properties.BackgroundImageForHighlightedState.Type { get { return Properties.BackgroundImageForHighlightedState.self } }
        static var BackgroundImageForDisabledState:Properties.BackgroundImageForDisabledState.Type { get { return Properties.BackgroundImageForDisabledState.self } }
        
        struct Properties {
            struct CustomStyleBlock:StyleProperty {
                let value:UIKit.UIButton->()
                init(value:UIKit.UIButton->()) {
                    self.value = value
                }
            }
            struct ContentEdgeInsets:StyleProperty {
                let value:UIEdgeInsets
                init(value:UIEdgeInsets) {
                    self.value = value
                }
            }
            struct TitleEdgeInsets:StyleProperty {
                let value:UIEdgeInsets
                init(value:UIEdgeInsets) {
                    self.value = value
                }
            }
            struct ImageEdgeInsets:StyleProperty {
                let value:UIEdgeInsets
                init(value:UIEdgeInsets) {
                    self.value = value
                }
            }
            struct TitleForNormalState:StyleProperty {
                let value:String
                init(value:String) {
                    self.value = value
                }
            }
            struct TitleForHighlightedState:StyleProperty {
                let value:String
                init(value:String) {
                    self.value = value
                }
            }
            struct TitleForDisabledState:StyleProperty {
                let value:String
                init(value:String) {
                    self.value = value
                }
            }
            struct TitleColorForNormalState:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct TitleColorForHighlightedState:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct TitleColorForDisabledState:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct ImageForNormalState:StyleProperty {
                let value:UIImage
                init(value:UIImage) {
                    self.value = value
                }
            }
            struct ImageForHighlightedState:StyleProperty {
                let value:UIImage
                init(value:UIImage) {
                    self.value = value
                }
            }
            struct ImageForDisabledState:StyleProperty {
                let value:UIImage
                init(value:UIImage) {
                    self.value = value
                }
            }
            struct BackgroundImageForNormalState:StyleProperty {
                let value:UIImage
                init(value:UIImage) {
                    self.value = value
                }
            }
            struct BackgroundImageForHighlightedState:StyleProperty {
                let value:UIImage
                init(value:UIImage) {
                    self.value = value
                }
            }
            struct BackgroundImageForDisabledState:StyleProperty {
                let value:UIImage
                init(value:UIImage) {
                    self.value = value
                }
            }
        }
    }
}

@IBDesignable class StyleableUIButton : UIButton, Styleable {
    
    @IBInspectable var styles:String! = "" {
        didSet {
            parseAndApplyStyles(styles, usingTheme: theme)
        }
    }
    
    @IBInspectable var theme:String! = "" {
        didSet {
            parseAndApplyStyles(styles, usingTheme: theme)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles(styles, usingTheme: theme)
    }
    
    func applyStyle(style: Style) {
        Stylish.UIButton.ApplyStyle(style, toButton: self)
    }
}

// MARK: UIImageView

extension Stylish {
    
    struct UIImageView {
        
        static func ApplyStyle(style:Style, toImageView imageView:UIKit.UIImageView) {
            Stylish.UIView.ApplyStyle(style, toView:imageView)
            imageView.image = style.valueFor(Stylish.UIImageView.Image) ?? imageView.image
            if let customStyleBlock = style.valueFor(Stylish.UIImageView.CustomStyleBlock) {
                customStyleBlock(imageView)
            }
        }
        
        static var CustomStyleBlock:Properties.CustomStyleBlock.Type { get { return Properties.CustomStyleBlock.self } }
        static var Image:Properties.Image.Type { get { return Properties.Image.self } }
        
        struct Properties {
            struct CustomStyleBlock:StyleProperty {
                let value:UIKit.UIImageView->()
                init(value:UIKit.UIImageView->()) {
                    self.value = value
                }
            }
            struct Image:StyleProperty {
                let value:UIImage
                init(value:UIImage) {
                    self.value = value
                }
            }
        }
    }
}


@IBDesignable class StyleableUIImageView : UIImageView, Styleable {
    
    @IBInspectable var styles:String! = "" {
        didSet {
            parseAndApplyStyles(styles, usingTheme: theme)
        }
    }
    
    @IBInspectable var theme:String! = "" {
        didSet {
            parseAndApplyStyles(styles, usingTheme: theme)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles(styles, usingTheme: theme)
    }
    
    func applyStyle(style: Style) {
        Stylish.UIImageView.ApplyStyle(style, toImageView: self)
    }
}

