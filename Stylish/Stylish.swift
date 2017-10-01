//
//  Stylish.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import UIKit


// MARK: - Global Stylish Settings -

public struct Stylish {
    
    /// The app bundle that Stylish uses to prefix style classes when dynamically instantiating them, to load stylesheet json from, etc. By default, Stylish will look for the first bundle it finds that has a png resource that with the string "AppIcon" in its name (a good guess for what the main bundle will ultimately be for the app).  If this guess is wrong, you can set this global static var directly from your app delegate for runtime resolution, and from an extension on UIView that overrides prepareForInterfaceBuilder for design-time resolution (and to see live storyboard previews work).
    public static var appBundle: Bundle = Bundle.allBundles.first(where: {
        guard let resourceURL = $0.resourceURL else { return false }
        let urls = try? FileManager.default.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys:[], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
        return urls?.contains{ $0.absoluteString.hasSuffix(".png") == true && $0.absoluteString.range(of:"AppIcon") != nil } == true
    }) ?? Bundle.main
    
    
    /// The default global stylehseet that will be used when no specific stylsheet is specificed on a Styleable UIView.  If this is nil, Stylish will try to load the stylesheet specified in the Info.plist if one has been specified
    public static var globalStylesheet:Stylesheet.Type? = nil {
        didSet {
            refreshAllStyles()
        }
    }
    
    internal static var sharedStyleClasses: [(identifier: String, styleClass: StyleClass)] = []
    
    /// A method that allows client apps to register style classes that should be added to ALL stylesheets. This is useful for common styles that should always remain the same and be available, regardless of which stylesheet is currently applied in the app
    public static func registerSharedStyleClasses(_ styleClasses:[(identifier: String, styleClass: StyleClass)]) {
        let nonDuplicates = styleClasses.filter{ styleClass in !sharedStyleClasses.contains{ $0.identifier == styleClass.identifier }}
        sharedStyleClasses += nonDuplicates
    }
    
    /// Refreshes the styles of all views in the app, in the event of a stylesheet =change or update, etc.
    public static func refreshAllStyles() {
        for window in UIApplication.shared.windows {
            refreshStyles(for: window)
        }
    }
    
    /// Refreshes / reapplies the styling for a single view
    public static func refreshStyles(for view:UIView) {
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

public extension Stylish {
    fileprivate static let ErrorViewTag = 7331
    
    public class ErrorView:UIKit.UIView {
        
        override public init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required public init?(coder aDecoder: NSCoder) {
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

public func =?<T>( left:inout T, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}

public func =?<T>( left:inout T!, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}

public func =?<T>( left:inout T?, right:@autoclosure () -> T?) {
    if let value = right() {
        left = value
    }
}




// MARK: - Styleable Protocol -

// A closure that takes a Style, reads the values from it and sets the on a instance of the supplied view.  Every Styleable UIView subclass defines one or more StyleApplicators which know how to set values from a style onto an instance of that particular view.

public typealias StyleApplicator = (StyleClass, Any)->()


// The protocol conformed to by any UIView subclass that wants to participate in styling

public protocol Styleable {
    static var StyleApplicators:[StyleApplicator] { get }
    var styles:String { get set }
    var stylesheet:String { get set }
}

public extension Styleable {
    public func apply(style:StyleClass) {
        for applicator in Self.StyleApplicators {
            applicator(style, self)
        }
    }
}

// Add default implementations for parsing and applying styles in UIView types
public extension Styleable where Self:UIView {
    
    public func parseAndApplyStyles() {
        self.layoutIfNeeded()
        parseAndApply(styles: styles, usingStylesheet: stylesheet)
    }
    
    public func parseAndApply(styles:String, usingStylesheet stylesheetName:String) {
        let components = styles.replacingOccurrences(of: ", ", with: ",").replacingOccurrences(of: " ,", with: ",").components(separatedBy:",")
        if stylesheetName.lowercased() == "jsonstylesheet" {
            let stylesheetType = JSONStylesheet.self
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.apply(style: style)
                }
            }
        }
        else if let moduleName = Stylish.appBundle.infoDictionary?[String(kCFBundleNameKey)] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.apply(style: style)
                }
            }
        }
        else if let stylesheetType = Stylish.globalStylesheet {
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.apply(style: style)
                }
            }
        }
        else if let info = Stylish.appBundle.infoDictionary, let stylesheetName = info["Stylesheet"] as? String, stylesheetName.lowercased() == "jsonstylesheet" {
            let stylesheetType = JSONStylesheet.self
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if let style = stylesheet[string] {
                    self.apply(style: style)
                }
            }
        }
        else {
            if let info = Stylish.appBundle.infoDictionary, let moduleName = Stylish.appBundle.infoDictionary?[String(kCFBundleNameKey)] as? String, let stylesheetName = info["Stylesheet"] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
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
    
    public func showErrorIfInvalidStyles() {
        showErrorIfInvalid(styles: styles, usingStylesheet: stylesheet)
    }
    
    public func showErrorIfInvalid(styles:String, usingStylesheet stylesheetName:String) {
        let components = styles.replacingOccurrences(of:", ", with: ",").replacingOccurrences(of:" ,", with: ",").components(separatedBy:",")
        
        var invalidStyle = false
        for subview in subviews {
            if subview.tag == Stylish.ErrorViewTag {
                subview.removeFromSuperview()
            }
        }
        if stylesheetName.lowercased() == "jsonstylesheet" {
            let stylesheetType = JSONStylesheet.self
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if stylesheet[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else if let moduleName = Stylish.appBundle.infoDictionary?[String(kCFBundleNameKey)] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
            let stylesheet = stylesheetType.init()
            for string in components where string != "" {
                if stylesheet[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else if let stylesheetType = Stylish.globalStylesheet {
            let stylesheet = stylesheetType.init()
            for string in components where string != "" {
                if stylesheet[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else if let info = Stylish.appBundle.infoDictionary, let stylesheetName = info["Stylesheet"] as? String, stylesheetName.lowercased() == "jsonstylesheet" {
            let stylesheetType = JSONStylesheet.self
            let stylesheet = useCachedJSON(forStylesheetType: stylesheetType) ? JSONStylesheet.cachedStylesheet! : stylesheetType.init()
            for string in components where string != "" {
                if stylesheet[string] == nil {
                    invalidStyle = true
                }
            }
        }
        else {
            if let info = Stylish.appBundle.infoDictionary, let moduleName = Stylish.appBundle.infoDictionary?[String(kCFBundleNameKey)] as? String, let stylesheetName = info["Stylesheet"] as? String, let stylesheetType = NSClassFromString("\(moduleName).\(stylesheetName)") as? Stylesheet.Type {
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

// MARK: String.isVariantOf() Extension

// String extensions for being forgiving of different styles of string representation and capitalization

public extension String {
    public func isVariant(of string:String) -> Bool {
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
