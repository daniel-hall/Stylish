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

// A StyleClass is a collection of values that should be assigned to the specified properties of any view that the StyleClass is applied to. Analagous in concept to a CSS style or style class

protocol StyleClass {
    var stylePropertySets:StylePropertySetCollection { get set }
}

// Retrieve a specific StylePropertySet by name or by type
extension StyleClass {
    mutating func register(propertySet:StylePropertySet) {
        if isKnownUniquelyReferenced(&stylePropertySets) {
            stylePropertySets.register(propertySet: propertySet)
        } else {
            stylePropertySets = StylePropertySetCollection(asCopyOf: stylePropertySets)
            stylePropertySets.register(propertySet: propertySet)
        }
    }
    func retrieve<T:StylePropertySet>(propertySet:T.Type)->T {
        return stylePropertySets.retrieve(propertySetType: propertySet)
    }
    func retrieve(dynamicPropertySetName:String)->DynamicStylePropertySet? {
        return stylePropertySets.retrieve(dynamicPropertySetName: dynamicPropertySetName)
    }
}



// MARK: - Stylesheet -

// A Stylesheet is a collection of StyleClasses. Changing Stylesheets is the equivalent of re-theming the app, since the StyleClasses with the same identifier in a new Stylesheet will most likely have different values for their properties. Analagous in concept to a CSS stylesheet

protocol Stylesheet : class {
    var styleClasses:[(identifier:String, styleClass:StyleClass)] { get }
    func style(named:String)->StyleClass?
    init()
}

extension Stylesheet {
    
    func style(named name: String) -> StyleClass? {
        for (identifier, styleClass) in styleClasses {
            if name.isVariant(of: identifier) {
                return styleClass
            }
        }
        return nil
    }
    
    subscript(styleName:String)->StyleClass? {
        get {
            return style(named: styleName)
        }
    }
}

// MARK: String.isVariantOf() Extension

// String extensions for being forgiving of different styles of string representation and capitalization

extension String {
    func isVariant(of string:String) -> Bool {
        let components = string.components(separatedBy: " ")
        return self == string  //"Example Test String"
            || self == string.lowercased() //"example test string"
            || self == string.lowercased().replacingOccurrences(of:" ", with: "") //"exampleteststring"
            || self == string.replacingOccurrences(of:" ", with: "") //"ExampleTestString"
            || self == string.lowercased().replacingOccurrences(of:" ", with: "-") //"example-test-string
            || self == string.lowercased().replacingOccurrences(of:" ", with: "_") //"example_test_string
            || self == (components.count > 1 ? components.first!.lowercased() + components[1..<components.count].flatMap{$0.capitalized}.joined(separator: "") : string) //"exampleTestString"
            || self.lowercased().replacingOccurrences(of:" ", with: "") == string.lowercased().replacingOccurrences(of:" ", with: "") //"EXample String" != "Example String" -> "examplestring" == "examplestring"
    }
}

// Just used to retrieve the Bundle that Stylish is located in
private class BundleMarker {}


// MARK: - StylePropertySet -

// A style property set is a way of organizing sets of style-enabled properties by the type of view they applu to.  For example, you may want a "tint" property on a custom class, which should not be confused with "tintColor" on a UIView.  The style property sets separate out the properties into logicial groupings, e.g. 'style.CustomView.tint' vs. 'style.UIView.tintColor'

protocol StylePropertySet {
    init()
}

// Adds support for setting style properties by name / string, instead of direct reference. Necessary only if you want your StylePropertySet to support being configured via JSON or other dynamic means.

protocol DynamicStylePropertySet : StylePropertySet {
    mutating func setStyleProperty<T>(named name:String, toValue value:T)
}


// MARK: - StylePropertySetCollection -

// A storage type used by StyleClasses to save values that will later be applied to a view

class StylePropertySetCollection {
    
    private var dictionary = [String : StylePropertySet]()
    
    fileprivate func retrieve<T:StylePropertySet>(propertySetType:T.Type) -> T {
        if let existing = dictionary[String(describing: propertySetType)] as? T {
            return existing
        }
        dictionary[String(describing: propertySetType)] = T.init()
        return dictionary[String(describing: propertySetType)] as! T
    }
    
    fileprivate func retrieve(dynamicPropertySetName:String)->DynamicStylePropertySet? {
        return dictionary[dynamicPropertySetName] as? DynamicStylePropertySet
    }
    
    fileprivate func register(propertySet:StylePropertySet) {
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
    
    convenience init(asCopyOf:StylePropertySetCollection) {
        self.init()
        self.dictionary = asCopyOf.dictionary
    }
}



// MARK: - Styleable -

// A closure that takes a Style, reads the values from it and sets the on a instance of the supplied view.  Every Styleable UIView subclass defines one or more StyleApplicators which know how to set values from a style onto an instance of that particular view.

typealias StyleApplicator = (StyleClass, Any)->()


// The protocol conformed to by any UIView subclass that wants to participate in styling

protocol Styleable {
    static var StyleApplicators:[StyleApplicator] { get }
    var styles:String { get set }
    var stylesheet:String { get set }
}

extension Styleable {
    func apply(style:StyleClass) {
        for applicator in Self.StyleApplicators {
            applicator(style, self)
        }
    }
}

// Add default implementations for parsing and applying styles in UIView types
extension Styleable where Self:UIView {
    
    func parseAndApplyStyles() {
        self.layoutIfNeeded()
        parseAndApply(styles: styles, usingStylesheet: stylesheet)
    }
    
    func parseAndApply(styles:String, usingStylesheet stylesheetName:String) {
        let components = styles.replacingOccurrences(of: ", ", with: ",").replacingOccurrences(of: " ,", with: ",").components(separatedBy:",")
        
        if let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.apply(style: style)
                }
            }
        }
        else if let stylesheetType = Stylish.GlobalStylesheet {
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.apply(style: style)
                }
            }
        }
        else {
            if let info = Bundle(for:BundleMarker.self).infoDictionary, let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetName = info["Stylesheet"] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
                let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
                for string in components where string != "" {
                    if let style = stylesheet[string] {
                        self.apply(style: style)
                    }
                }
            }
        }
    }
    
    private func useCachedJSON(forStylesheetType:Stylesheet.Type) -> Bool {
        let jsonCacheDuration = 3.0
        let isJSON = forStylesheetType is JSONStylesheet.Type
        let cacheExists = JSONStylesheet.cachedStylesheet != nil
        let isCacheExpired = NSDate.timeIntervalSinceReferenceDate - JSONStylesheet.cacheTimestamp > jsonCacheDuration
        return isJSON && cacheExists && !isCacheExpired
    }
    
    func showErrorIfInvalidStyles() {
        showErrorIfInvalid(styles: styles, usingStylesheet: stylesheet)
    }
    
    func showErrorIfInvalid(styles:String, usingStylesheet stylesheetName:String) {
        let components = styles.replacingOccurrences(of:", ", with: ",").replacingOccurrences(of:" ,", with: ",").components(separatedBy:",")
        
        var invalidStyle = false
        for subview in subviews {
            if subview.tag == Stylish.ErrorViewTag {
                subview.removeFromSuperview()
            }
        }
        
        if let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
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
            if let info = Bundle(for:BundleMarker.self).infoDictionary, let moduleName = String(describing:BundleMarker()).components(separatedBy:".").first, let stylesheetName = info["Stylesheet"] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
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
    static var GlobalStylesheet:Stylesheet.Type? = nil {
        didSet {
            refreshAllStyles()
        }
    }
    
    static func refreshAllStyles() {
        for window in UIApplication.shared.windows {
            refreshStyles(for: window)
        }
    }
    
    static func refreshStyles(for view:UIView) {
        for subview in view.subviews {
            refreshStyles(for: subview)
        }
        if let styleable = view as? Styleable {
            var styleableView = styleable
            styleableView.stylesheet = styleable.stylesheet
        }
    }
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
        
        private func setup() {
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

infix operator =? : AssignmentPrecedence

func =?<T>( left:inout T, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}

func =?<T>( left:inout T!, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}

func =?<T>( left:inout T?, right:@autoclosure () -> T?) {
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
        case _ where name.isVariant(of: "Background Color"):
            backgroundColor = value as? UIColor
        case _ where name.isVariant(of: "Content Mode"):
            contentMode = value as? UIViewContentMode
        case _ where name.isVariant(of: "User Interaction Enabled"):
            userInteractionEnabled = value as? Bool
        case _ where name.isVariant(of: "Hidden"):
            hidden = value as? Bool
        case _ where name.isVariant(of: "Border Color"):
            borderColor = (value as! CGColor)
        case _ where name.isVariant(of: "Border Width"):
            borderWidth = value as? CGFloat
        case _ where name.isVariant(of: "Corner Radius"):
            cornerRadius = value as? CGFloat
        case _ where name.isVariant(of: "Corner Radius Percentage"):
            cornerRadiusPercentage = value as? CGFloat
        case _ where name.isVariant(of: "Alpha"):
            alpha = value as? CGFloat
        case _ where name.isVariant(of: "Layout Margins"):
            layoutMargins = value as? UIEdgeInsets
        case _ where name.isVariant(of: "Tint Color"):
            tintColor = value as? UIColor
        case _ where name.isVariant(of: "Masks To Bounds"):
            masksToBounds = value as? Bool
        case _ where name.isVariant(of: "Clips To Bounds"):
            clipsToBounds = value as? Bool
        default :
            return
        }
    }
}

extension StyleClass {
    var UIView:UIViewPropertySet { get { return self.retrieve(propertySet: UIViewPropertySet.self) } set { self.register(propertySet: newValue) } }
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
        case _ where name.isVariant(of: "Text Color"):
            textColor = value as? UIColor
        case _ where name.isVariant(of: "Font"):
            font = value as? UIFont
        case _ where name.isVariant(of: "Enabled"):
            enabled = value as? Bool
        case _ where name.isVariant(of: "Text Alignment"):
            textAlignment = value as? NSTextAlignment
        case _ where name.isVariant(of: "Text"):
            text = value as? String
        case _ where name.isVariant(of: "Highlighted"):
            highlighted = value as? Bool
        case _ where name.isVariant(of: "Highlighted Text Color"):
            highlightedTextColor = value as? UIColor
        default :
            return
        }
    }
    
}


extension StyleClass {
    var UILabel:UILabelPropertySet { get { return self.retrieve(propertySet: UILabelPropertySet.self) } set { self.register(propertySet: newValue) } }
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
    var titleFont:UIFont?
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
        case _ where name.isVariant(of: "Content Edge Insets"):
            contentEdgeInsets = value as? UIEdgeInsets
        case _ where name.isVariant(of: "Title Edge Insets"):
            titleEdgeInsets = value as? UIEdgeInsets
        case _ where name.isVariant(of: "Image Edge Insets"):
            imageEdgeInsets = value as? UIEdgeInsets
        case _ where name.isVariant(of: "Title Font"):
            titleFont = value as? UIFont
        case _ where name.isVariant(of: "Title For Normal State"):
            titleForNormalState = value as? String
        case _ where name.isVariant(of: "Title For Highlighted State"):
            titleForHighlightedState = value as? String
        case _ where name.isVariant(of: "Title For Disabled State"):
            titleForDisabledState = value as? String
        case _ where name.isVariant(of: "Title Color For Normal State"):
            titleColorForNormalState = value as? UIColor
        case _ where name.isVariant(of: "Title Color For Highlighted State"):
            titleColorForHighlightedState = value as? UIColor
        case _ where name.isVariant(of: "Title Color For Disabled State"):
            titleColorForDisabledState = value as? UIColor
        case _ where name.isVariant(of: "Image For Normal State"):
            imageForNormalState = value as? UIImage
        case _ where name.isVariant(of: "Image For Highlighted State"):
            imageForHighlightedState = value as? UIImage
        case _ where name.isVariant(of: "Image For Disabled State"):
            imageForDisabledState = value as? UIImage
        case _ where name.isVariant(of: "Background Image For Normal State"):
            backgroundImageForNormalState = value as? UIImage
        case _ where name.isVariant(of: "Background Image For Highlighted State"):
            backgroundImageForHighlightedState = value as? UIImage
        case _ where name.isVariant(of: "Background Image For Disabled State"):
            backgroundImageForDisabledState = value as? UIImage
        default :
            return
        }
    }
}

extension StyleClass {
    var UIButton:UIButtonPropertySet { get { return self.retrieve(propertySet: UIButtonPropertySet.self) } set { self.register(propertySet: newValue) } }
}

@IBDesignable class StyleableUIButton : UIButton, Styleable {
    
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let button = target as? UIButton {
                button.contentEdgeInsets =? style.UIButton.contentEdgeInsets
                button.titleEdgeInsets =? style.UIButton.titleEdgeInsets
                button.imageEdgeInsets =? style.UIButton.imageEdgeInsets
                button.titleLabel?.font =? style.UIButton.titleFont
                if let title = style.UIButton.titleForNormalState { button.setTitle(title, for:.normal) }
                if let title = style.UIButton.titleForHighlightedState { button.setTitle(title, for:.highlighted) }
                if let title = style.UIButton.titleForDisabledState { button.setTitle(title, for:.disabled) }
                if let titleColor = style.UIButton.titleColorForNormalState { button.setTitleColor(titleColor, for:.normal) }
                if let titleColor = style.UIButton.titleColorForHighlightedState { button.setTitleColor(titleColor, for:.highlighted) }
                if let titleColor = style.UIButton.titleColorForDisabledState { button.setTitleColor(titleColor, for:.disabled) }
                if let image = style.UIButton.imageForNormalState { button.setImage(image, for:.normal) }
                if let image = style.UIButton.imageForHighlightedState { button.setImage(image, for:.highlighted) }
                if let image = style.UIButton.imageForDisabledState { button.setImage(image, for:.disabled) }
                if let backgroundImage = style.UIButton.backgroundImageForNormalState { button.setBackgroundImage(backgroundImage, for:.normal) }
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
        case _ where name.isVariant(of: "Image"):
            image = value as? UIImage
        default :
            return
        }
    }
}

extension StyleClass {
    var UIImageView:UIImageViewPropertySet { get { return self.retrieve(propertySet: UIImageViewPropertySet.self) } set { self.register(propertySet: newValue) } }
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
            let start = hexString.index(hexString.startIndex, offsetBy:1)
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
        self.init()
        return nil
    }
}


// MARK: JSONStyleProperty

// This enum type converts JSON dictionary values into the appropriate iOS types

enum JSONStyleProperty {
    case CGFloatProperty(value:CGFloat)
    case FloatProperty(value:Float)
    case DoubleProperty(value:Double)
    case IntProperty(value:Int)
    case BoolProperty(value:Bool)
    case UIEdgeInsetsProperty(value:UIEdgeInsets)
    case NSTextAlignmentProperty(value:NSTextAlignment)
    case StringProperty(value:String)
    case UIColorProperty(value:UIColor)
    case CGColorProperty(value:CGColor)
    case UIImageProperty(value:UIImage)
    case UIViewContentModeProperty(value:UIViewContentMode)
    case UIFontProperty(value:UIFont)
    case InvalidProperty(errorMessage:String)
    
    init(dictionary:[String : AnyObject]) {
        guard let type = dictionary["propertyType"] as? String else {
            self = .InvalidProperty(errorMessage: "Missing value for 'propertyType' in JSON")
            return
        }
        switch type {
        case _ where type.isVariant(of: "CG Float") :
            guard let value = dictionary["propertyValue"] as? CGFloat else {
                self = .InvalidProperty(errorMessage: "'propertyValue' for the was missing or could not be converted to CGFloat")
                return
            }
            self = .CGFloatProperty(value: value)
        case _ where type.isVariant(of: "Float") :
            guard let value = dictionary["propertyValue"] as? Float else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or could not be converted to Float")
                return
            }
            self = .FloatProperty(value: value)
        case _ where type.isVariant(of: "Double") :
            guard let value = dictionary["propertyValue"] as? Double else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or could not be converted to Double")
                return
            }
            self = .DoubleProperty(value: value)
        case _ where type.isVariant(of: "Int") :
            guard let value = dictionary["propertyValue"] as? Int else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or could not be converted to Int")
                return
            }
            self = .IntProperty(value: value)
        case _ where type.isVariant(of: "Bool") :
            guard let value = dictionary["propertyValue"] as? Bool else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or could not be converted to Bool")
                return
                
            }
            self = .BoolProperty(value: value)
        case _ where type.isVariant(of: "UI Edge Insets") || type.isVariant(of: "Edge Insets"):
            guard let top = (dictionary["propertyValue"]?["top"] as? NSNumber)?.floatValue, let left = (dictionary["propertyValue"]?["left"] as? NSNumber)?.floatValue, let bottom = (dictionary["propertyValue"]?["bottom"] as? NSNumber)?.floatValue, let right = (dictionary["propertyValue"]?["right"] as? NSNumber)?.floatValue else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain values for 'top', 'left', 'bottom', and 'right' that could be converted to Floats")
                return
            }
            self = .UIEdgeInsetsProperty(value: UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right)))
        case _ where type.isVariant(of: "NS Text Alignment") || type.isVariant(of: "Text Alignment"):
            guard let value = dictionary["propertyValue"] as? String else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or could not be converted to String")
                return
            }
            switch value {
            case _ where value.isVariant(of: "Left") :
                self = .NSTextAlignmentProperty(value: .left)
            case _ where value.isVariant(of: "Center") :
                self = .NSTextAlignmentProperty(value: .center)
            case _ where value.isVariant(of: "Right") :
                self = .NSTextAlignmentProperty(value: .right)
            case _ where value.isVariant(of: "Justified") :
                self = .NSTextAlignmentProperty(value: .justified)
            case _ where value.isVariant(of: "Natural") :
                self = .NSTextAlignmentProperty(value: .natural)
            default :
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for an NSTextAlignment property, i.e. 'Left', 'Center', 'Right', 'Justified', 'Natural'")
            }
        case _ where type.isVariant(of: "String") :
            guard let value = dictionary["propertyValue"] as? String else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or could not be converted to String")
                return
            }
            self = .StringProperty(value: value)
        case _ where type.isVariant(of: "UI Color") || type.isVariant(of: "Color") :
            guard let hex = dictionary["propertyValue"] as? String, let value = UIColor(hexString:hex) else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or was not a valid hex color string")
                return
            }
            self = .UIColorProperty(value: value)
        case _ where type.isVariant(of: "CG Color") :
            guard let hex = dictionary["propertyValue"] as? String, let value = UIColor(hexString:hex)?.cgColor else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or was not a valid hex color string")
                return
            }
            self = .CGColorProperty(value: value)
        case _ where type.isVariant(of: "UI Image") || type.isVariant(of:"Image"):
            let bundle = Bundle(for: JSONStylesheet.self)
            guard let name = dictionary["propertyValue"] as? String, let value = UIImage(named: name, in: bundle, compatibleWith: UIScreen.main.traitCollection) else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or was not a String value that matched the name of an image in your app bundle")
                return
            }
            self = .UIImageProperty(value:value)
        case _ where type.isVariant(of: "UI View Content Mode") || type.isVariant(of: "View Content Mode") || type.isVariant(of: "Content Mode") :
            guard let value = dictionary["propertyValue"] as? String else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or could not be converted to String")
                return
            }
            switch value {
            case _ where value.isVariant(of: "Scale To Fill") :
                self = .UIViewContentModeProperty(value: .scaleToFill)
            case _ where value.isVariant(of: "Scale Aspect Fit") :
                self = .UIViewContentModeProperty(value: .scaleAspectFit)
            case _ where value.isVariant(of: "Scale Aspect Fill") :
                self = .UIViewContentModeProperty(value: .scaleAspectFill)
            case _ where value.isVariant(of: "Redraw") :
                self = .UIViewContentModeProperty(value: .redraw)
            case _ where value.isVariant(of: "Center") :
                self = .UIViewContentModeProperty(value: .center)
            case _ where value.isVariant(of: "Top") :
                self = .UIViewContentModeProperty(value: .top)
            case _ where value.isVariant(of: "Bottom") :
                self = .UIViewContentModeProperty(value: .bottom)
            case _ where value.isVariant(of: "Left") :
                self = .UIViewContentModeProperty(value: .left)
            case _ where value.isVariant(of: "Right") :
                self = .UIViewContentModeProperty(value: .right)
            case _ where value.isVariant(of: "Top Left") :
                self = .UIViewContentModeProperty(value: .topLeft)
            case _ where value.isVariant(of: "Top Right") :
                self = .UIViewContentModeProperty(value: .topRight)
            case _ where value.isVariant(of: "Bottom Left") :
                self = .UIViewContentModeProperty(value: .bottomLeft)
            case _ where value.isVariant(of: "Bottom Right") :
                self = .UIViewContentModeProperty(value: .bottomRight)
            default :
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was not a String that matched valid values for a UIViewContentMode property, e.g. 'scaleToFill', 'scaleAspectFit', 'Center', 'topRight', etc.")
            }
        case _ where type.isVariant(of: "UI Font") || type.isVariant(of:"Font"):
            guard let fontName = dictionary["propertyValue"]?["name"] as? String, let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue, let font = UIFont(name: fontName, size: CGFloat(fontSize)) else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain values for 'name', and 'size' that could be converted to a valid iOS font name and font size")
                return
            }
            self = .UIFontProperty(value: font)
        case _ where type.isVariant(of: "System Font") :
            if let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue, let fontWeight = dictionary["propertyValue"]?["weight"] as? String {
                var font:UIFont?
                switch(fontWeight) {
                case _ where fontWeight.isVariant(of: "Ultra Light") || fontWeight.isVariant(of: "UI Font Weight Ultra Light") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightUltraLight)
                case _ where fontWeight.isVariant(of: "Thin") || fontWeight.isVariant(of: "UI Font Weight Thin") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightThin)
                case _ where fontWeight.isVariant(of: "Light") || fontWeight.isVariant(of: "UI Font Weight Light") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightLight)
                case _ where fontWeight.isVariant(of: "Regular") || fontWeight.isVariant(of: "UI Font Weight Regular") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightRegular)
                case _ where fontWeight.isVariant(of: "Medium") || fontWeight.isVariant(of: "UI Font Weight Medium") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightMedium)
                case _ where fontWeight.isVariant(of: "Semibold") || fontWeight.isVariant(of: "UI Font Weight Semibold") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightSemibold)
                case _ where fontWeight.isVariant(of: "Bold") || fontWeight.isVariant(of: "UI Font Weight Bold") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightBold)
                case _ where fontWeight.isVariant(of: "Heavy") || fontWeight.isVariant(of: "UI Font Weight Heavy") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightHeavy)
                case _ where fontWeight.isVariant(of: "Black") || fontWeight.isVariant(of: "UI Font Weight Black") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightBlack)
                default :
                    font = nil
                }
                if let resolvedFont = font {
                    self = .UIFontProperty(value: resolvedFont)
                }
                else {
                    self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain values for 'size' and 'weight' that could be converted to a Float and a String that matches valid UIFontWeight constants such as 'UIFontWithRegular', 'UIFontWeightLight', 'UIFontWeightBold', etc.")
                }
            }
            else if let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue {
                self = .UIFontProperty(value: UIFont.systemFont(ofSize: CGFloat(fontSize)))
            }
            else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain a value for 'size' that could be converted to a Float")
            }
        case _ where type.isVariant(of: "Bold System Font") :
            if let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue {
                self = .UIFontProperty(value: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)))
            }
            else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain a value for 'size' that could be converted to a Float")
            }
        case _ where type.isVariant(of: "Italic System Font") :
            if let fontSize = (dictionary["propertyValue"]?["size"] as? NSNumber)?.floatValue {
                self = .UIFontProperty(value: UIFont.italicSystemFont(ofSize: CGFloat(fontSize)))
            }
            else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain a value for 'size' that could be converted to a Float")
            }
        case _ where type.isVariant(of: "Preferred Font") :
            if let textStyle = dictionary["propertyValue"]?["textStyle"] as? String {
                var font:UIFont?
                switch(textStyle) {
                case _ where textStyle.isVariant(of: "Title 1") || textStyle.isVariant(of: "UI Font Text Style Title 1") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
                case _ where textStyle.isVariant(of: "Title 2") || textStyle.isVariant(of: "UI Font Text Style Title 2") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
                case _ where textStyle.isVariant(of: "Title 3") || textStyle.isVariant(of: "UI Font Text Style Title 3") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3)
                case _ where textStyle.isVariant(of: "Headline") || textStyle.isVariant(of: "UIFontTextStyleHeadline") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
                case _ where textStyle.isVariant(of: "Subheadline") || textStyle.isVariant(of: "UI Font Text Style Subheadline") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
                case _ where textStyle.isVariant(of: "Body") || textStyle.isVariant(of: "UI Font Text Style Body") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
                case _ where textStyle.isVariant(of: "Callout") || textStyle.isVariant(of: "UI Font Text Style Callout") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)
                case _ where textStyle.isVariant(of: "Footnote") || textStyle.isVariant(of: "UI Font Text Style Footnote") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
                case _ where textStyle.isVariant(of: "Caption 1") || textStyle.isVariant(of: "UI Font Text Style Caption 1") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
                case _ where textStyle.isVariant(of: "Caption 2") || textStyle.isVariant(of: "UI Font Text Style Caption 2") :
                    font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
                default :
                    font = nil
                }
                if let resolvedFont = font {
                    self = .UIFontProperty(value: resolvedFont)
                }
                else {
                    self = .InvalidProperty(errorMessage: "'propertyValue' dictionary in JSON did not contain a value for 'textStyle' that could be converted to a String that matches a valid text style constant such as 'UIFontTextStyleBody', or 'UIFontTextStyleCaption2'")
                }
            }
            else {
                self = .InvalidProperty(errorMessage: "'propertyValue' in JSON was missing or or did not contain a value for 'textStyle' that could be converted to a String")
            }
        default :
            self = .InvalidProperty(errorMessage: "'propertyType' value in JSON did match match an expected property type such as 'color', 'font', 'double', etc.")
        }
    }
    
    var value:Any {
        switch self {
        case .CGFloatProperty(let value) :
            return value
        case .FloatProperty(let value) :
            return value
        case .DoubleProperty(let value) :
            return value
        case .IntProperty(let value) :
            return value
        case .BoolProperty(let value) :
            return value
        case .UIEdgeInsetsProperty(let value) :
            return value
        case .NSTextAlignmentProperty(let value) :
            return value
        case .StringProperty(let value) :
            return value
        case .UIColorProperty(let value) :
            return value
        case .CGColorProperty(let value) :
            return value
        case .UIImageProperty(let value) :
            return value
        case .UIViewContentModeProperty(let value) :
            return value
        case .UIFontProperty(let value) :
            return value
        case .InvalidProperty(let value) :
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
        init(jsonArray:[[String : AnyObject]], styleClass:String, dynamicPropertySets:[StylePropertySet.Type]? = nil) {
            stylePropertySets = StylePropertySetCollection(sets: dynamicPropertySets)
            for dictionary in jsonArray {
                if let propertySetName = dictionary["propertySetName"] as? String, let property = dictionary["propertyName"] as? String {
                    let style = JSONStyleProperty(dictionary:dictionary)
                    switch style {
                    case .InvalidProperty :
                        assert(false, "The '\(property)' property in '\(propertySetName)' for the style class '\(styleClass)' has the following error: \(style.value)")
                        break
                    default :
                        var propertySet = retrieve(dynamicPropertySetName: propertySetName)
                        propertySet?.setStyleProperty(named:property, toValue:style.value)
                        if let modified = propertySet {
                            register(propertySet: modified)
                        }
                    }
                }
            }
        }
    }
    
    var styleClasses = [(identifier: String, styleClass: StyleClass)]()
    var dynamicPropertySets:[StylePropertySet.Type] { get { return [UIViewPropertySet.self, UILabelPropertySet.self, UIButtonPropertySet.self, UIImageViewPropertySet.self] } }
    
    required init() {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let savedDirectory = paths[0]
        let filename = savedDirectory.appending("/stylesheet.json")
        let bundle = Bundle(for: JSONStylesheet.self)
        let fileManager = FileManager.default
        
        // Compare the file modification date of the downloaded / copied version of stylesheet.json in the Documents directory, and the original version of stylesheet.json included in the app bundle. If the Documents version is more recent, load and parse that version.  Otherwise, use the bundle version and then copy it to the Documents directory.
        
        if let savedAttributes = try? fileManager.attributesOfItem(atPath: filename), let savedDate = savedAttributes[FileAttributeKey.modificationDate] as? NSDate, let path = bundle.path(forResource: "stylesheet", ofType: "json"), let bundledAttributes = try? fileManager.attributesOfItem(atPath: path), let bundledDate = bundledAttributes[FileAttributeKey.modificationDate] as? NSDate  {
            
            if let data = NSData(contentsOfFile:filename), let json = (try? JSONSerialization.jsonObject(with: data as Data, options:[])) as? [[String : AnyObject]], savedDate.timeIntervalSinceReferenceDate >= bundledDate.timeIntervalSinceReferenceDate {
                parse(json: json)
            } else if let path = bundle.path(forResource: "stylesheet", ofType: "json"), let data = NSData(contentsOfFile:path), let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
                if let stringJSON = String(data:data as Data, encoding: String.Encoding.utf8) {
                    do {
                        try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                    }
                    catch {}
                }
                
                parse(json: json)
            }
        }
        else if let path = bundle.path(forResource: "stylesheet", ofType: "json"), let data = NSData(contentsOfFile:path), let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
            if let stringJSON = String(data:data as Data, encoding: String.Encoding.utf8) {
                do {
                    try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                }
                catch {}
            }
            parse(json: json)
        }
        
        return
    }
    
    private func parse(json:[[String : AnyObject]]) {
        for dictionary in json {
            if let styleClass = dictionary["styleClass"] as? String, let array = dictionary["properties"] as? [[String : AnyObject]] {
                styleClasses.append((identifier: styleClass, styleClass: DynamicStyleClass(jsonArray: array, styleClass:styleClass, dynamicPropertySets: dynamicPropertySets)))
            } else {
                assert(false, "Error in JSON stylesheet, possibly missing a 'styleClass' String value, or a 'properties' array for one of the included style classes")
            }
        }
        JSONStylesheet.cacheTimestamp = NSDate.timeIntervalSinceReferenceDate
        JSONStylesheet.cachedStylesheet = self
    }
}


