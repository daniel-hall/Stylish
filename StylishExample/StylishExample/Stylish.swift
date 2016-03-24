//
//  Stylish.swift
//  Stylish
//
//  Created by Daniel Hall on 3/19/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation
import UIKit


// MARK: - =? Operator -

infix operator =? { associativity right precedence 90 } // Optional assignment operator. Assigns the optional value on the right (if not nil) to the variable on the left. If the optional on the right is nil, then no action is performed

func =?<T>(inout left:T, @autoclosure right:() -> T?) {
    if let value = right() {
        left = value
    }
}

func =?<T>(inout left:T!, @autoclosure right:() -> T?) {
    if let value = right() {
        left = value
    }
}

func =?<T>(inout left:T?, @autoclosure right:() -> T?) {
    if let value = right() {
        left = value
    }
}

// MARK: - Style -

protocol Style { }

protocol MutableStyle : Style {
    var properties:[String:Any] { get set }
}

extension MutableStyle {
    mutating func setValue<T>(value:T, forStyle:String) {
        properties[forStyle] = value
    }
}

extension Style {
    func getValue<T>(forStyle:String)->T? {
        return (self as? MutableStyle)?.properties[forStyle] as? T
    }
}


// MARK: - Styleable -

typealias StyleApplicator = (Style, Any)->()

protocol Styleable {
    static var StyleApplicators:[StyleApplicator] { get }
}

extension Styleable {
    func applyStyle(style:Style) {
        for applicator in Self.StyleApplicators {
            applicator(style, self)
        }
    }
}


extension Styleable where Self:UIView {
    
    func parseAndApplyStyles(styles:String, usingTheme themeName:String) {
        let components = styles.stringByReplacingOccurrencesOfString(", ", withString: ",").stringByReplacingOccurrencesOfString(" ,", withString: ",").componentsSeparatedByString(",")
        
        if let moduleName = String(BundleMarker()).componentsSeparatedByString(".").first, let themeType = NSClassFromString("\(moduleName).\(themeName)") as? Theme.Type {
            let theme = themeType.init()
            for string in components where string != "" {
                if let style = theme[string] {
                    self.applyStyle(style)
                }
            }
        }
        else {
            if let info = NSBundle(forClass:BundleMarker.self).infoDictionary, let moduleName = String(BundleMarker()).componentsSeparatedByString(".").first, themeName = info["Theme"] as? String, let themeType = NSClassFromString("\(moduleName).\(themeName)") as? Theme.Type {
                let theme = themeType.init()
                for string in components where string != "" {
                    if let style = theme[string] {
                        self.applyStyle(style)
                    }
                }
            }
        }
    }
    
    func showErrorIfInvalidStyles(styles:String, usingTheme themeName:String) {
        let components = styles.stringByReplacingOccurrencesOfString(", ", withString: ",").stringByReplacingOccurrencesOfString(" ,", withString: ",").componentsSeparatedByString(",")
        
        var invalidStyle = false
        for subview in subviews {
            if subview.tag == Stylish.ErrorViewTag {
                subview.removeFromSuperview()
            }
        }
        
        if let moduleName = String(BundleMarker()).componentsSeparatedByString(".").first, let themeType = NSClassFromString("\(moduleName).\(themeName)") as? Theme.Type {
            let theme = themeType.init()
            for string in components where string != "" {
                if theme[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else {
            if let info = NSBundle(forClass:BundleMarker.self).infoDictionary, let moduleName = String(BundleMarker()).componentsSeparatedByString(".").first, themeName = info["Theme"] as? String, let themeType = NSClassFromString("\(moduleName).\(themeName)") as? Theme.Type {
                let theme = themeType.init()
                for string in components where string != "" {
                    if theme[string] == nil {
                        invalidStyle = true
                    }
                }
            }
            else {
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

protocol Theme : class {
    func styleNamed(name:String)->Style?
    init()
}

extension Theme {
    subscript(styleName:String)->Style? {
        get {
            return styleNamed(styleName)
        }
    }
}

extension String {
    func isVariantOf(string:String) -> Bool {
        let components = string.componentsSeparatedByString(" ")
        return self == string  //"Example Test String"
            || self == string.lowercaseString //"example test string"
            || self == string.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "") //"exampleteststring"
            || self == string.stringByReplacingOccurrencesOfString(" ", withString: "") //"ExampleTestString"
            || self == string.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "-") //"example-test-string
            || self == (components.count > 1 ? components.first!.lowercaseString + components[1..<components.count].flatMap{$0.capitalizedString}.joinWithSeparator("") : string) //"exampleTestString"
    }
}

private class BundleMarker {}


// MARK: - Stylish Error View -

struct Stylish {
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


extension Style {
    var backgroundColor:UIColor? { get { return getValue(#function) } }
    var contentMode:UIViewContentMode? { get { return getValue(#function) } }
    var userInteractionEnabled:Bool? { get { return getValue(#function) } }
    var hidden:Bool? { get { return getValue(#function) } }
    var borderColor:UIColor? { get { return getValue(#function) } }
    var borderWidth:CGFloat? { get { return getValue(#function) } }
    var cornerRadius:CGFloat? { get { return getValue(#function) } }
    var cornerRadiusPercentage:CGFloat? { get { return getValue(#function) } }
    var alpha:CGFloat? { get { return getValue(#function) } }
    var layoutMargins:UIEdgeInsets? { get { return getValue(#function) } }
    var tintColor:UIColor? { get { return getValue(#function) } }
    var customUIViewStyleBlock:(UIView->())? { get { return getValue(#function) } }
}

extension MutableStyle {
    var backgroundColor:UIColor? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var contentMode:UIViewContentMode? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var userInteractionEnabled:Bool? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var hidden:Bool? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var borderColor:UIColor? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var borderWidth:CGFloat? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var cornerRadius:CGFloat? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var cornerRadiusPercentage:CGFloat? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var alpha:CGFloat? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var layoutMargins:UIEdgeInsets? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var tintColor:UIColor? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var customUIViewStyleBlock:(UIView->())? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
}


@IBDesignable class StyleableUIView : UIView, Styleable {
    
    class var StyleApplicators:[StyleApplicator] {
        return [{
            (style:Style, target:Any) in
            if let view = target as? UIView {
                view.backgroundColor =? style.backgroundColor
                view.contentMode =? style.contentMode
                view.userInteractionEnabled =? style.userInteractionEnabled
                view.hidden =? style.hidden
                view.layer.borderColor =? style.borderColor?.CGColor
                view.layer.borderWidth =? style.borderWidth
                if let percentage = style.cornerRadiusPercentage { view.layer.cornerRadius = percentage * view.bounds.height }
                view.layer.cornerRadius =? style.cornerRadius
                view.alpha =? style.alpha
                view.tintColor =? style.tintColor
                view.layoutMargins =? style.layoutMargins
                if let customBlock = style.customUIViewStyleBlock { customBlock(view) }
            }
        }]
    }
    
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
}


// MARK: UILabel


extension Style {
    var textColor:UIColor? { get { return getValue(#function) } }
    var font:UIFont? { get { return getValue(#function) } }
    var enabled:Bool? { get { return getValue(#function) } }
    var textAlignment:NSTextAlignment? { get { return getValue(#function) } }
    var text:String? { get { return getValue(#function) } }
    var highlighted:Bool? { get { return getValue(#function) } }
    var highlightedTextColor:UIColor? { get { return getValue(#function) } }
    var customUILabelStyleBlock:(UIView->())? { get { return getValue(#function) } }
}

extension MutableStyle {
    var textColor:UIColor? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var font:UIFont? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var enabled:Bool? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var textAlignment:NSTextAlignment? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var text:String? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var highlighted:Bool? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var highlightedTextColor:UIColor? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var customUILabelStyleBlock:(UIView->())? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
}

@IBDesignable class StyleableUILabel : UILabel, Styleable {
    
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:Style, target:Any) in
            if let label = target as? UILabel {
                label.textColor =? style.textColor
                label.font =? style.font
                label.enabled =? style.enabled
                label.textAlignment =? style.textAlignment
                label.text =? style.text
                label.highlighted =? style.highlighted
                label.highlightedTextColor =? style.highlightedTextColor
                if let customStyleBlock = style.customUILabelStyleBlock { customStyleBlock(label) }
            }
        }]
    }
    
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
}


// MARK: UIButton

extension Style {
    var contentEdgeInsets:UIEdgeInsets? { get { return getValue(#function) } }
    var titleEdgeInsets:UIEdgeInsets? { get { return getValue(#function) } }
    var imageEdgeInsets:UIEdgeInsets? { get { return getValue(#function) } }
    var titleForNormalState:String? { get { return getValue(#function) } }
    var titleForHighlightedState:String? { get { return getValue(#function) } }
    var titleForDisabledState:String? { get { return getValue(#function) } }
    var titleColorForNormalState:UIColor? { get { return getValue(#function) } }
    var titleColorForHighlightedState:UIColor? { get { return getValue(#function) } }
    var titleColorForDisabledState:UIColor? { get { return getValue(#function) } }
    var imageForNormalState:UIImage? { get { return getValue(#function) } }
    var imageForHighlightedState:UIImage? { get { return getValue(#function) } }
    var imageForDisabledState:UIImage? { get { return getValue(#function) } }
    var backgroundImageForNormalState:UIImage? { get { return getValue(#function) } }
    var backgroundImageForHighlightedState:UIImage? { get { return getValue(#function) } }
    var backgroundImageForDisabledState:UIImage? { get { return getValue(#function) } }
    var customUIButtonStyleBlock:(UIButton->())? { get { return getValue(#function) } }
}

extension MutableStyle {
    var contentEdgeInsets:UIEdgeInsets? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var titleEdgeInsets:UIEdgeInsets? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var imageEdgeInsets:UIEdgeInsets? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var titleForNormalState:String? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var titleForHighlightedState:String? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var titleForDisabledState:String? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var titleColorForNormalState:UIColor? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var titleColorForHighlightedState:UIColor? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var titleColorForDisabledState:UIColor? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var imageForNormalState:UIImage? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var imageForHighlightedState:UIImage? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var imageForDisabledState:UIImage? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var backgroundImageForNormalState:UIImage? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var backgroundImageForHighlightedState:UIImage? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var backgroundImageForDisabledState:UIImage? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var customUIButtonStyleBlock:(UIButton->())? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
}

@IBDesignable class StyleableUIButton : UIButton, Styleable {
    
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:Style, target:Any) in
            if let button = target as? UIButton {
                button.contentEdgeInsets =? style.contentEdgeInsets
                button.titleEdgeInsets =? style.titleEdgeInsets
                button.imageEdgeInsets =? style.imageEdgeInsets
                if let title = style.titleForNormalState { button.setTitle(title, forState:.Normal) }
                if let title = style.titleForHighlightedState { button.setTitle(title, forState:.Highlighted) }
                if let title = style.titleForDisabledState { button.setTitle(title, forState:.Disabled) }
                if let titleColor = style.titleColorForNormalState { button.setTitleColor(titleColor, forState:.Normal) }
                if let titleColor = style.titleColorForHighlightedState { button.setTitleColor(titleColor, forState:.Highlighted) }
                if let titleColor = style.titleColorForDisabledState { button.setTitleColor(titleColor, forState:.Disabled) }
                if let image = style.imageForNormalState { button.setImage(image, forState:.Normal) }
                if let image = style.imageForHighlightedState { button.setImage(image, forState:.Highlighted) }
                if let image = style.imageForDisabledState { button.setImage(image, forState:.Disabled) }
                if let backgroundImage = style.backgroundImageForNormalState { button.setBackgroundImage(backgroundImage, forState:.Normal) }
                if let backgroundImage = style.backgroundImageForHighlightedState { button.setBackgroundImage(backgroundImage, forState:.Highlighted) }
                if let backgroundImage = style.backgroundImageForDisabledState { button.setBackgroundImage(backgroundImage, forState:.Disabled) }
                if let customStyleBlock = style.customUIButtonStyleBlock { customStyleBlock(button) }
            }
        }]
    }
    
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
}

// MARK: UIImageView


extension Style {
    var image:UIImage? { get { return getValue(#function) } }
    var customUIImageViewStyleBlock:(UIImageView->())? { get { return getValue(#function) } }
}

extension MutableStyle {
    var image:UIImage? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
    var customUIImageViewStyleBlock:(UIImageView->())? { get { return getValue(#function) } set { setValue(newValue, forStyle: #function) } }
}

@IBDesignable class StyleableUIImageView : UIImageView, Styleable {
    
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:Style, target:Any) in
            if let imageView = target as? UIImageView {
                imageView.image =? style.image
                if let customStyleBlock = style.customUIImageViewStyleBlock { customStyleBlock(imageView) }
            }
        }]
    }
    
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
}

