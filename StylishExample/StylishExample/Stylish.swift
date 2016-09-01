//
//  Stylish.swift
//  Stylish
//
// Copyright (c) 2016 Daniel Hall
// Twitter: @_danielhall
// GitHub: https://github.com/daniel-hall
// Website: http://danielhall.io
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.




import Foundation
import UIKit



// MARK: - StyleClass -

// A StyleClass is a collection of values that should be assigned to the properties of any view that the StyleClass is applied to

protocol StyleClass {
    var stylePropertySets:StylePropertySetCollection { get set }
}

// Retrieve a specific StylePropertySet by name or by type
extension StyleClass {
    mutating func register(_ propertySet:StylePropertySet) {
        stylePropertySets.register(propertySet)
    }
    func retrieve<T:StylePropertySet>(_ propertySet:T.Type)->T {
        return stylePropertySets.retrieve(propertySet)
    }
    func retrieve(_ dynamicPropertySetName:String)->DynamicStylePropertySet? {
        return stylePropertySets.retrieve(dynamicPropertySetName)
    }
}



// MARK: - Stylesheet -

// A Stylesheet is a collection of StyleClasses. Changing Stylesheets is the equivalent of re-theming the app, since the StyleClasses with the same identifier in a new Stylesheet will most likely have different values for their properties.

protocol Stylesheet : class {
    var styleClasses:[(identifier:String, styleClass:StyleClass)] { get }
    func styleNamed(_ name:String)->StyleClass?
    init()
}

extension Stylesheet {
    
    func styleNamed(_ name: String) -> StyleClass? {
        for (identifier, styleClass) in styleClasses {
            if name.isVariantOf(identifier) {
                return styleClass
            }
        }
        return nil
    }
    
    subscript(styleName:String)->StyleClass? {
        get {
            return styleNamed(styleName)
        }
    }
}

// MARK: String.isVariantOf() Extension

// String extensions for being forgiving of different styles of string representation and capitalization

extension String {
    func isVariantOf(_ string:String) -> Bool {
        let components = string.components(separatedBy: " ")
        return self == string  //"Example Test String"
            || self == string.lowercased() //"example test string"
            || self == string.lowercased().replacingOccurrences(of: " ", with: "") //"exampleteststring"
            || self == string.replacingOccurrences(of: " ", with: "") //"ExampleTestString"
            || self == string.lowercased().replacingOccurrences(of: " ", with: "-") //"example-test-string
            || self == string.lowercased().replacingOccurrences(of: " ", with: "_") //"example_test_string
            || self == (components.count > 1 ? components.first!.lowercased() + components[1..<components.count].flatMap{$0.capitalized}.joined(separator: "") : string) //"exampleTestString"
            || self.lowercased().replacingOccurrences(of: " ", with: "") == string.lowercased().replacingOccurrences(of: " ", with: "") //"EXample String" != "Example String" -> "examplestring" == "examplestring"
    }
}

private class BundleMarker {}



// MARK - StylePropertySet -

// A style property set is a way of organizing sets of properties that can be style by the type of iew they apple to.  For example, you may want a "tint" property on a custom class, which should not be confused with "tintColor" on a UIView.  The style property sets separate out the properties into logicial groupings, e.g. 'style.CustomView.tint' vs. 'style.UIView.tintColor'

protocol StylePropertySet {
    init()
}

// Adds support for setting style properties by name / string, instead of direct reference. Necessary only if you want your StylePropertySet to support being configured via JSON or other dynamic means.

protocol DynamicStylePropertySet : StylePropertySet {
    mutating func setStyleProperty<T>(named name:String, toValue value:T)
}


class StylePropertySetCollection {
    
    fileprivate var dictionary = [String : StylePropertySet]()
    
    fileprivate func retrieve<T:StylePropertySet>(_ propertySetType:T.Type) -> T {
        if let existing = dictionary[String(describing: propertySetType)] as? T {
            return existing
        }
        dictionary[String(describing: propertySetType)] = T.init()
        return dictionary[String(describing: propertySetType)] as! T
    }
    
    fileprivate func retrieve(_ dynamicPropertySetName:String)->DynamicStylePropertySet? {
        return dictionary[dynamicPropertySetName] as? DynamicStylePropertySet
    }
    
    fileprivate func register(_ propertySet:StylePropertySet) {
        dictionary[String(describing: type(of: propertySet))] = propertySet
    }
    
    // Optional: the collection can be initialized prepopulated with property sets.  This is only needed if using dynamic / string based lookup
    convenience init(sets:[StylePropertySet.Type]?) {
        self.init()
        guard let parameterSets = sets else {
            return
        }
        for type in parameterSets {
            dictionary[String(describing: type)] = type.init()
        }
    }
}



// MARK: - Styleable -

typealias StyleApplicator = (StyleClass, Any)->()

protocol Styleable {
    static var StyleApplicators:[StyleApplicator] { get }
    var styles:String { get set }
    var stylesheet:String { get set }
}

extension Styleable {
    func applyStyle(_ style:StyleClass) {
        for applicator in Self.StyleApplicators {
            applicator(style, self)
        }
    }
}

// Add default implementations for parsing and applying styles in UIView types
extension Styleable where Self:UIView {
    
    func parseAndApplyStyles() {
        parseAndApplyStyles(styles, usingStylesheet: stylesheet)
    }
    
    func parseAndApplyStyles(_ styles:String, usingStylesheet stylesheetName:String) {
        let components = styles.replacingOccurrences(of: ", ", with: ",").replacingOccurrences(of: " ,", with: ",").components(separatedBy: ",")
        
        if let moduleName = String(describing: BundleMarker()).components(separatedBy: ".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
            let stylesheet = useCachedJSON(stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.applyStyle(style)
                }
            }
        }
        else if let stylesheetType = Stylish.GlobalStylesheet {
            let stylesheet = useCachedJSON(stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.applyStyle(style)
                }
            }
        }
        else {
            if let info = Bundle(for:BundleMarker.self).infoDictionary, let moduleName = String(describing: BundleMarker()).components(separatedBy: ".").first, let stylesheetName = info["Stylesheet"] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
                let stylesheet = useCachedJSON(stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
                for string in components where string != "" {
                    if let style = stylesheet[string] {
                        self.applyStyle(style)
                    }
                }
            }
        }
    }
    
    fileprivate func useCachedJSON(_ forStylesheetType:Stylesheet.Type) -> Bool {
        let isJSON = forStylesheetType is JSONStylesheet.Type
        let cacheExists = JSONStylesheet.cachedStylesheet != nil
        let isCacheExpired = Date.timeIntervalSinceReferenceDate - JSONStylesheet.cacheTimestamp > 2
        return isJSON && cacheExists && !isCacheExpired
    }
    
    func showErrorIfInvalidStyles() {
        showErrorIfInvalidStyles(styles, usingStylesheet: stylesheet)
    }
    
    func showErrorIfInvalidStyles(_ styles:String, usingStylesheet stylesheetName:String) {
        let components = styles.replacingOccurrences(of: ", ", with: ",").replacingOccurrences(of: " ,", with: ",").components(separatedBy: ",")
        
        var invalidStyle = false
        for subview in subviews {
            if subview.tag == Stylish.ErrorViewTag {
                subview.removeFromSuperview()
            }
        }
        
        if let moduleName = String(describing: BundleMarker()).components(separatedBy: ".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
            let stylesheet = stylesheetType.init()
            for string in components where string != "" {
                if stylesheet[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else if let stylesheetType = Stylish.GlobalStylesheet {
            let stylesheet = stylesheetType.init()
            for string in components where string != "" {
                if stylesheet[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else {
            if let info = Bundle(for:BundleMarker.self).infoDictionary, let moduleName = String(describing: BundleMarker()).components(separatedBy: ".").first, let stylesheetName = info["Stylesheet"] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
                let stylesheet = stylesheetType.init()
                for string in components where string != "" {
                    if stylesheet[string] == nil {
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




// MARK: - Global Stylesheet -

struct Stylish {
    static var GlobalStylesheet:Stylesheet.Type? = nil
}

// MARK: - Stylish Error View -

extension Stylish {
    fileprivate static let ErrorViewTag = 7331
    
    class ErrorView:UIKit.UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        fileprivate func setup() {
            let context = CIContext()
            let stripesFilter = CIFilter(name: "CIStripesGenerator", withInputParameters: ["inputColor0" : CIColor(color: UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.4)), "inputColor1" : CIColor(color: UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.6)), "inputWidth" : 2])!
            let stripes = context.createCGImage(stripesFilter.outputImage!, from: CGRect(origin: CGPoint.zero, size: CGSize(width: 32.0, height: 32.0)))
            let rotateFilter = CIFilter(name: "CIStraightenFilter", withInputParameters: ["inputImage" : CIImage(cgImage: stripes!), "inputAngle" : 2.35])!
            let rotated = context.createCGImage(rotateFilter.outputImage!, from: rotateFilter.outputImage!.extent)
            let stripesView = UIKit.UIView()
            stripesView.backgroundColor = UIColor(patternImage: UIImage(cgImage: rotated!))
            stripesView.frame = bounds
            addSubview(stripesView)
        }
    }
}



// MARK: - =? Operator -

// Optional assignment operator. Assigns the optional value on the right (if not nil) to the variable on the left. If the optional on the right is nil, then no action is performed

infix operator =? { associativity right precedence 90 }

func =?<T>(left:inout T, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}

func =?<T>(left:inout T!, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}

func =?<T>(left:inout T?, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}



// MARK: - Styleable UIKit Subclasses -

// MARK: UIView

struct UIViewPropertySet : DynamicStylePropertySet {
    var backgroundColor:UIColor?
    var contentMode:UIViewContentMode?
    var userInteractionEnabled:Bool?
    var hidden:Bool?
    var borderColor:CGColor?
    var borderWidth:CGFloat?
    var cornerRadius:CGFloat?
    var cornerRadiusPercentage:CGFloat?
    var masksToBounds:Bool?
    var clipsToBounds:Bool?
    var alpha: CGFloat?
    var layoutMargins:UIEdgeInsets?
    var tintColor:UIColor?
    var customUIViewStyleBlock:((UIView)->())?
    mutating func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariantOf("Background Color"):
            backgroundColor = value as? UIColor
        case _ where name.isVariantOf("Content Mode"):
            contentMode = value as? UIViewContentMode
        case _ where name.isVariantOf("User Interaction Enabled"):
            userInteractionEnabled = value as? Bool
        case _ where name.isVariantOf("Hidden"):
            hidden = value as? Bool
        case _ where name.isVariantOf("Border Color"):
            borderColor = (value as! CGColor)
        case _ where name.isVariantOf("Border Width"):
            borderWidth = value as? CGFloat
        case _ where name.isVariantOf("Corner Radius"):
            cornerRadius = value as? CGFloat
        case _ where name.isVariantOf("Corner Radius Percentage"):
            cornerRadiusPercentage = value as? CGFloat
        case _ where name.isVariantOf("Alpha"):
            alpha = value as? CGFloat
        case _ where name.isVariantOf("Layout Margins"):
            layoutMargins = value as? UIEdgeInsets
        case _ where name.isVariantOf("Tint Color"):
            tintColor = value as? UIColor
        case _ where name.isVariantOf("Masks To Bounds"):
            masksToBounds = value as? Bool
        case _ where name.isVariantOf("Clips To Bounds"):
            clipsToBounds = value as? Bool
        default :
            return
        }
    }
}

extension StyleClass {
    var UIView:UIViewPropertySet { get { return self.retrieve(UIViewPropertySet.self) } set { self.register(newValue) } }
}


@IBDesignable class StyleableUIView : UIView, Styleable {
    
    class var StyleApplicators:[StyleApplicator] {
        return [{
            (style:StyleClass, target:Any) in
            if let view = target as? UIView {
                view.backgroundColor =? style.UIView.backgroundColor
                view.contentMode =? style.UIView.contentMode
                view.isUserInteractionEnabled =? style.UIView.userInteractionEnabled
                view.isHidden =? style.UIView.hidden
                view.layer.borderColor =? style.UIView.borderColor
                view.layer.borderWidth =? style.UIView.borderWidth
                view.clipsToBounds =? style.UIView.clipsToBounds
                view.layer.masksToBounds =? style.UIView.masksToBounds
                if let percentage = style.UIView.cornerRadiusPercentage { view.layer.cornerRadius = percentage * view.bounds.height }
                view.layer.cornerRadius =? style.UIView.cornerRadius
                view.alpha =? style.UIView.alpha
                view.tintColor =? style.UIView.tintColor
                view.layoutMargins =? style.UIView.layoutMargins
                if let customBlock = style.UIView.customUIViewStyleBlock { customBlock(view) }
            }
            }]
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
}


// MARK: UILabel


struct UILabelPropertySet : DynamicStylePropertySet {
    var textColor:UIColor?
    var font:UIFont?
    var enabled:Bool?
    var textAlignment:NSTextAlignment?
    var text:String?
    var highlighted:Bool?
    var highlightedTextColor:UIColor?
    var customUILabelStyleBlock:((UILabel)->())?
    mutating func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariantOf("Text Color"):
            textColor = value as? UIColor
        case _ where name.isVariantOf("Font"):
            font = value as? UIFont
        case _ where name.isVariantOf("Enabled"):
            enabled = value as? Bool
        case _ where name.isVariantOf("Text Alignment"):
            textAlignment = value as? NSTextAlignment
        case _ where name.isVariantOf("Text"):
            text = value as? String
        case _ where name.isVariantOf("Highlighted"):
            highlighted = value as? Bool
        case _ where name.isVariantOf("Highlighted Text Color"):
            highlightedTextColor = value as? UIColor
        default :
            return
        }
    }
    
}


extension StyleClass {
    var UILabel:UILabelPropertySet { get { return self.retrieve(UILabelPropertySet.self) } set { self.register(newValue) } }
}

@IBDesignable class StyleableUILabel : UILabel, Styleable {
    
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let label = target as? UILabel {
                label.textColor =? style.UILabel.textColor
                label.font =? style.UILabel.font
                label.isEnabled =? style.UILabel.enabled
                label.textAlignment =? style.UILabel.textAlignment
                label.text =? style.UILabel.text
                label.isHighlighted =? style.UILabel.highlighted
                label.highlightedTextColor =? style.UILabel.highlightedTextColor
                if let customStyleBlock = style.UILabel.customUILabelStyleBlock { customStyleBlock(label) }
            }
            }]
    }
    
    override func didMoveToSuperview() {
        NotificationCenter.default.addObserver(self, selector: #selector(StyleableUILabel.refreshFont), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        super.didMoveToSuperview()
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    func refreshFont() {
        parseAndApplyStyles()
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: UIButton

struct UIButtonPropertySet : DynamicStylePropertySet {
    var contentEdgeInsets:UIEdgeInsets?
    var titleEdgeInsets:UIEdgeInsets?
    var imageEdgeInsets:UIEdgeInsets?
    var titleForNormalState:String?
    var titleForHighlightedState:String?
    var titleForDisabledState:String?
    var titleColorForNormalState:UIColor?
    var titleColorForHighlightedState:UIColor?
    var titleColorForDisabledState:UIColor?
    var imageForNormalState:UIImage?
    var imageForHighlightedState:UIImage?
    var imageForDisabledState:UIImage?
    var backgroundImageForNormalState:UIImage?
    var backgroundImageForHighlightedState:UIImage?
    var backgroundImageForDisabledState:UIImage?
    var customUIButtonStyleBlock:((UIButton)->())?
    mutating func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariantOf("Content Edge Insets"):
            contentEdgeInsets = value as? UIEdgeInsets
        case _ where name.isVariantOf("Title Edge Insets"):
            titleEdgeInsets = value as? UIEdgeInsets
        case _ where name.isVariantOf("Image Edge Insets"):
            imageEdgeInsets = value as? UIEdgeInsets
        case _ where name.isVariantOf("Title For Normal State"):
            titleForNormalState = value as? String
        case _ where name.isVariantOf("Title For Highlighted State"):
            titleForHighlightedState = value as? String
        case _ where name.isVariantOf("Title For Disabled State"):
            titleForDisabledState = value as? String
        case _ where name.isVariantOf("Title Color For Normal State"):
            titleColorForNormalState = value as? UIColor
        case _ where name.isVariantOf("Title Color For Highlighted State"):
            titleColorForHighlightedState = value as? UIColor
        case _ where name.isVariantOf("Title Color For Disabled State"):
            titleColorForDisabledState = value as? UIColor
        case _ where name.isVariantOf("Image For Normal State"):
            imageForNormalState = value as? UIImage
        case _ where name.isVariantOf("Image For Highlighted State"):
            imageForHighlightedState = value as? UIImage
        case _ where name.isVariantOf("Image For Disabled State"):
            imageForDisabledState = value as? UIImage
        case _ where name.isVariantOf("Background Image For Normal State"):
            backgroundImageForNormalState = value as? UIImage
        case _ where name.isVariantOf("Background Image For Highlighted State"):
            backgroundImageForHighlightedState = value as? UIImage
        case _ where name.isVariantOf("Background Image For Disabled State"):
            backgroundImageForDisabledState = value as? UIImage
        default :
            return
        }
    }
}

extension StyleClass {
    var UIButton:UIButtonPropertySet { get { return self.retrieve(UIButtonPropertySet.self) } set { self.register(newValue) } }
}

@IBDesignable class StyleableUIButton : UIButton, Styleable {
    
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let button = target as? UIButton {
                button.contentEdgeInsets =? style.UIButton.contentEdgeInsets
                button.titleEdgeInsets =? style.UIButton.titleEdgeInsets
                button.imageEdgeInsets =? style.UIButton.imageEdgeInsets
                if let title = style.UIButton.titleForNormalState { button.setTitle(title, for:UIControlState()) }
                if let title = style.UIButton.titleForHighlightedState { button.setTitle(title, for:.highlighted) }
                if let title = style.UIButton.titleForDisabledState { button.setTitle(title, for:.disabled) }
                if let titleColor = style.UIButton.titleColorForNormalState { button.setTitleColor(titleColor, for:UIControlState()) }
                if let titleColor = style.UIButton.titleColorForHighlightedState { button.setTitleColor(titleColor, for:.highlighted) }
                if let titleColor = style.UIButton.titleColorForDisabledState { button.setTitleColor(titleColor, for:.disabled) }
                if let image = style.UIButton.imageForNormalState { button.setImage(image, for:UIControlState()) }
                if let image = style.UIButton.imageForHighlightedState { button.setImage(image, for:.highlighted) }
                if let image = style.UIButton.imageForDisabledState { button.setImage(image, for:.disabled) }
                if let backgroundImage = style.UIButton.backgroundImageForNormalState { button.setBackgroundImage(backgroundImage, for:UIControlState()) }
                if let backgroundImage = style.UIButton.backgroundImageForHighlightedState { button.setBackgroundImage(backgroundImage, for:.highlighted) }
                if let backgroundImage = style.UIButton.backgroundImageForDisabledState { button.setBackgroundImage(backgroundImage, for:.disabled) }
                if let customStyleBlock = style.UIButton.customUIButtonStyleBlock { customStyleBlock(button) }
            }
            }]
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
}

// MARK: UIImageView


struct UIImageViewPropertySet : DynamicStylePropertySet {
    var image:UIImage?
    var customUIImageViewStyleBlock:((UIImageView)->())?
    mutating func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariantOf("Image"):
            image = value as? UIImage
        default :
            return
        }
    }
}

extension StyleClass {
    var UIImageView:UIImageViewPropertySet { get { return self.retrieve(UIImageViewPropertySet.self) } set { self.register(newValue) } }
}

@IBDesignable class StyleableUIImageView : UIImageView, Styleable {
    
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let imageView = target as? UIImageView {
                imageView.image =? style.UIImageView.image
                if let customStyleBlock = style.UIImageView.customUIImageViewStyleBlock { customStyleBlock(imageView) }
            }
            }]
    }
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
}




// MARK: - JSON Stylesheet Support -


// MARK: UIColor(hexString:) extension

private extension UIColor {
    
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.characters.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 || hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0xff000000) >> 24) / 255 : CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0x00ff0000) >> 16) / 255 : CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0x0000ff00) >> 8) / 255 : CGFloat(hexNumber & 0x000000ff) / 255
                    a = hexColor.characters.count == 8 ? CGFloat(hexNumber & 0x000000ff) / 255 : 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}


// MARK: JSONStyleProperty

// This enum type converts JSON dictionary values into the appropriate iOS types

enum JSONStyleProperty {
    case cgFloatProperty(value:CGFloat)
    case floatProperty(value:Float)
    case doubleProperty(value:Double)
    case intProperty(value:Int)
    case boolProperty(value:Bool)
    case uiEdgeInsetsProperty(value:UIEdgeInsets)
    case nsTextAlignmentProperty(value:NSTextAlignment)
    case stringProperty(value:String)
    case uiColorProperty(value:UIColor)
    case cgColorProperty(value:CGColor)
    case uiImageProperty(value:UIImage)
    case uiViewContentModeProperty(value:UIViewContentMode)
    case uiFontProperty(value:UIFont)
    
    init?(dictionary:[String : AnyObject]) {
        guard let type = dictionary["propertyType"] as? String else {
            return nil
        }
        switch type {
        case _ where type.isVariantOf("CG Float") :
            guard let value = dictionary["propertyValue"] as? CGFloat else {
                return nil
            }
            self = .cgFloatProperty(value: value)
        case _ where type.isVariantOf("Float") :
            guard let value = dictionary["propertyValue"] as? Float else {
                return nil
            }
            self = .floatProperty(value: value)
        case _ where type.isVariantOf("Double") :
            guard let value = dictionary["propertyValue"] as? Double else {
                return nil
            }
            self = .doubleProperty(value: value)
        case _ where type.isVariantOf("Int") :
            guard let value = dictionary["propertyValue"] as? Int else {
                return nil
            }
            self = .intProperty(value: value)
        case _ where type.isVariantOf("Bool") :
            guard let value = dictionary["propertyValue"] as? Bool else {
                return nil
            }
            self = .boolProperty(value: value)
        case _ where type.isVariantOf("UI Edge Insets") || type.isVariantOf("Edge Insets"):
            guard let top = (dictionary["propertyValue"]?["top"] as? NSNumber)?.floatValue, let left = (dictionary["propertyValue"]?["left"] as? NSNumber)?.floatValue, let bottom = (dictionary["propertyValue"]?["bottom"] as? NSNumber)?.floatValue, let right = (dictionary["propertyValue"]?["right"] as? NSNumber)?.floatValue else {
                return nil
            }
            self = .uiEdgeInsetsProperty(value: UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right)))
        case _ where type.isVariantOf("NS Text Alignment") || type.isVariantOf("Text Alignment"):
            guard let value = dictionary["propertyValue"] as? String else {
                return nil
            }
            switch value {
            case _ where value.isVariantOf("Left") :
                self = .nsTextAlignmentProperty(value: .left)
            case _ where value.isVariantOf("Center") :
                self = .nsTextAlignmentProperty(value: .center)
            case _ where value.isVariantOf("Right") :
                self = .nsTextAlignmentProperty(value: .right)
            case _ where value.isVariantOf("Justified") :
                self = .nsTextAlignmentProperty(value: .justified)
            case _ where value.isVariantOf("Natural") :
                self = .nsTextAlignmentProperty(value: .natural)
            default :
                return nil
            }
        case _ where type.isVariantOf("String") :
            guard let value = dictionary["propertyValue"] as? String else {
                return nil
            }
            self = .stringProperty(value: value)
        case _ where type.isVariantOf("UI Color") || type.isVariantOf("Color") :
            guard let hex = dictionary["propertyValue"] as? String, let value = UIColor(hexString:hex) else {
                return nil
            }
            self = .uiColorProperty(value: value)
        case _ where type.isVariantOf("CG Color") :
            guard let hex = dictionary["propertyValue"] as? String, let value = UIColor(hexString:hex)?.cgColor else {
                return nil
            }
            self = .cgColorProperty(value: value)
        case _ where type.isVariantOf("UI Image") || type.isVariantOf("Image"):
            let bundle = Bundle(for: JSONStylesheet.self)
            guard let name = dictionary["propertyValue"] as? String, let value = UIImage(named: name, in: bundle, compatibleWith: UIScreen.main.traitCollection) else {
                return nil
            }
            self = .uiImageProperty(value:value)
        case _ where type.isVariantOf("UI View Content Mode") || type.isVariantOf("View Content Mode") || type.isVariantOf("Content Mode") :
            guard let value = dictionary["propertyValue"] as? String else {
                return nil
            }
            switch value {
            case _ where value.isVariantOf("Scale To Fill") :
                self = .uiViewContentModeProperty(value: .scaleToFill)
            case _ where value.isVariantOf("Scale Aspect Fit") :
                self = .uiViewContentModeProperty(value: .scaleAspectFit)
            case _ where value.isVariantOf("Scale Aspect Fill") :
                self = .uiViewContentModeProperty(value: .scaleAspectFill)
            case _ where value.isVariantOf("Redraw") :
                self = .uiViewContentModeProperty(value: .redraw)
            case _ where value.isVariantOf("Center") :
                self = .uiViewContentModeProperty(value: .center)
            case _ where value.isVariantOf("Top") :
                self = .uiViewContentModeProperty(value: .top)
            case _ where value.isVariantOf("Bottom") :
                self = .uiViewContentModeProperty(value: .bottom)
            case _ where value.isVariantOf("Left") :
                self = .uiViewContentModeProperty(value: .left)
            case _ where value.isVariantOf("Right") :
                self = .uiViewContentModeProperty(value: .right)
            case _ where value.isVariantOf("Top Left") :
                self = .uiViewContentModeProperty(value: .topLeft)
            case _ where value.isVariantOf("Top Right") :
                self = .uiViewContentModeProperty(value: .topRight)
            case _ where value.isVariantOf("Bottom Left") :
                self = .uiViewContentModeProperty(value: .bottomLeft)
            case _ where value.isVariantOf("Bottom Right") :
                self = .uiViewContentModeProperty(value: .bottomRight)
            default :
                return nil
            }
        case _ where type.isVariantOf("UI Font") || type.isVariantOf("Font"):
            guard let fontName = dictionary["propertyValue"]?["name"] as? String, let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue, let font = UIFont(name: fontName, size: CGFloat(fontSize)) else {
                return nil
            }
            self = .uiFontProperty(value: font)
        case _ where type.isVariantOf("System Font") :
            if let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue, let fontWeight = dictionary["propertyValue"]?["weight"] as? String {
                var font:UIFont?
                switch(fontWeight) {
                case _ where fontWeight.isVariantOf("Ultra Light") || fontWeight.isVariantOf("UI Font Weight Ultra Light") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightUltraLight)
                case _ where fontWeight.isVariantOf("Thin") || fontWeight.isVariantOf("UI Font Weight Thin") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightThin)
                case _ where fontWeight.isVariantOf("Light") || fontWeight.isVariantOf("UI Font Weight Light") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightLight)
                case _ where fontWeight.isVariantOf("Regular") || fontWeight.isVariantOf("UI Font Weight Regular") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightRegular)
                case _ where fontWeight.isVariantOf("Medium") || fontWeight.isVariantOf("UI Font Weight Medium") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightMedium)
                case _ where fontWeight.isVariantOf("Semibold") || fontWeight.isVariantOf("UI Font Weight Semibold") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightSemibold)
                case _ where fontWeight.isVariantOf("Bold") || fontWeight.isVariantOf("UI Font Weight Bold") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightBold)
                case _ where fontWeight.isVariantOf("Heavy") || fontWeight.isVariantOf("UI Font Weight Heavy") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightHeavy)
                case _ where fontWeight.isVariantOf("Black") || fontWeight.isVariantOf("UI Font Weight Black") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightBlack)
                default :
                    return nil
                }
                if let resolvedFont = font {
                    self = .uiFontProperty(value: resolvedFont)
                }
                else {
                    return nil
                }
            }
            else if let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue {
                self = .uiFontProperty(value: UIFont.systemFont(ofSize: CGFloat(fontSize)))
            }
            else {
                return nil
            }
        case _ where type.isVariantOf("Bold System Font") :
            if let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue {
                self = .uiFontProperty(value: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)))
            }
            else {
                return nil
            }
        case _ where type.isVariantOf("Italic System Font") :
            if let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue {
                self = .uiFontProperty(value: UIFont.italicSystemFont(ofSize: CGFloat(fontSize)))
            }
            else {
                return nil
            }
        case _ where type.isVariantOf("Preferred Font") :
            if let textStyle = dictionary["propertyValue"]?["textStyle"] as? String {
                var font:UIFont?
                switch(textStyle) {
                case _ where textStyle.isVariantOf("Title 1") || textStyle.isVariantOf("UI Font Text Style Title 1") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
                case _ where textStyle.isVariantOf("Title 2") || textStyle.isVariantOf("UI Font Text Style Title 2") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
                case _ where textStyle.isVariantOf("Title 3") || textStyle.isVariantOf("UI Font Text Style Title 3") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3)
                case _ where textStyle.isVariantOf("Headline") || textStyle.isVariantOf("UIFontTextStyleHeadline") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
                case _ where textStyle.isVariantOf("Subheadline") || textStyle.isVariantOf("UI Font Text Style Subheadline") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                case _ where textStyle.isVariantOf("Body") || textStyle.isVariantOf("UI Font Text Style Body") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
                case _ where textStyle.isVariantOf("Callout") || textStyle.isVariantOf("UI Font Text Style Callout") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)
                case _ where textStyle.isVariantOf("Footnote") || textStyle.isVariantOf("UI Font Text Style Footnote") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
                case _ where textStyle.isVariantOf("Caption 1") || textStyle.isVariantOf("UI Font Text Style Caption 1") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
                case _ where textStyle.isVariantOf("Caption 2") || textStyle.isVariantOf("UI Font Text Style Caption 2") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
                default :
                    return nil
                }
                if let resolvedFont = font {
                    self = .uiFontProperty(value: resolvedFont)
                }
                else {
                    return nil
                }
            }
            else {
                return nil
            }
        default :
            return nil
        }
    }
    
    var value:Any {
        switch self {
        case .cgFloatProperty(let value) :
            return value
        case .floatProperty(let value) :
            return value
        case .doubleProperty(let value) :
            return value
        case .intProperty(let value) :
            return value
        case .boolProperty(let value) :
            return value
        case .uiEdgeInsetsProperty(let value) :
            return value
        case .nsTextAlignmentProperty(let value) :
            return value
        case .stringProperty(let value) :
            return value
        case .uiColorProperty(let value) :
            return value
        case .cgColorProperty(let value) :
            return value
        case .uiImageProperty(let value) :
            return value
        case .uiViewContentModeProperty(let value) :
            return value
        case .uiFontProperty(let value) :
            return value
        }
    }
}


// MARK: JSONStylesheet


class JSONStylesheet : Stylesheet {
    
    static fileprivate var cachedStylesheet:JSONStylesheet?
    static fileprivate var cacheTimestamp:TimeInterval = 0
    
    struct DynamicStyleClass : StyleClass {
        var stylePropertySets:StylePropertySetCollection
        init(jsonArray:[[String : AnyObject]], dynamicPropertySets:[StylePropertySet.Type]? = nil) {
            stylePropertySets = StylePropertySetCollection(sets: dynamicPropertySets)
            for dictionary in jsonArray {
                if let propertySetName = dictionary["propertySetName"] as? String, let property = dictionary["propertyName"] as? String, let style = JSONStyleProperty(dictionary:dictionary) {
                    var propertySet = retrieve(propertySetName)
                    propertySet?.setStyleProperty(named:property, toValue:style.value)
                    if let modified = propertySet {
                        register(modified)
                    }
                }
            }
        }
    }
    
    var styleClasses = [(identifier: String, styleClass: StyleClass)]()
    var dynamicPropertySets:[StylePropertySet.Type] { get { return [UIViewPropertySet.self, UILabelPropertySet.self, UIButtonPropertySet.self, UIImageViewPropertySet.self] } }
    
    required init() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filename = documentsDirectory + "stylesheet.json"
        let bundle = Bundle(for: JSONStylesheet.self)
        
        // First try loading stylesheet.json from documents directory.  If that fails, try to load stylesheet.json from bundle, and move a copy of that to documents directory. In order to dynamically update styling via the web at runtime, create code somewhere in your app that downloads the current stylesheet and writes it to the documents directory as "stylesheet.json"  If running in Interface Builder, only the bundle version is loaded, never the cached version.
        
        #if TARGET_INTERFACE_BUILDER
            if let path = bundle.pathForResource("stylesheet", ofType: "json"), let data = NSData(contentsOfFile:path), let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
                parse(json)
            }
            return
        #endif
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: filename)), let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
            parse(json)
        } else if let path = bundle.path(forResource: "stylesheet", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)), let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
            if let stringJSON = String(data:data, encoding: String.Encoding.utf8) {
                do {
                    try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                }
                catch {}
            }
            parse(json)
        }
    }
    
    fileprivate func parse(_ json:[[String : AnyObject]]) {
        for dictionary in json {
            if let styleClass = dictionary["styleClass"] as? String, let array = dictionary["properties"] as? [[String : AnyObject]] {
                styleClasses.append((identifier: styleClass, styleClass: DynamicStyleClass(jsonArray: array, dynamicPropertySets: dynamicPropertySets)))
            }
        }
        JSONStylesheet.cacheTimestamp = Date.timeIntervalSinceReferenceDate
        JSONStylesheet.cachedStylesheet = self
    }
}
