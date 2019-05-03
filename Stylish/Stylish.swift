//
//  Stylish.swift
//  Stylish
//
// Copyright (c) 2017 Daniel Hall
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


import UIKit

/// A protocol that view types conform to in order to participate in the Stylish styling process. Requires a "styles" String property which can hold a comma-separated list of style names and "stylesheet" property which can hold an optional override stylesheet other than the global one, which will then be used by this Styleable instance and inherited by its children.  Usually both required vars are implemented as IBInspectable properties
public protocol Styleable: class {
    var styles: String { get set }
    var stylesheet: String? { get set }
}

/// A protocol that a type conforms to in order to be considered a Style.  Essentially, a style is a collection of value changes that will be applied to specific properties, so a Style is composed of a set of these property specific stylers.
public protocol Style {
    var propertyStylers: [AnyPropertyStyler] { get }
}

/// The protocol a type must conform to in order to be used as a Stylesheet. A Stylesheet is simply a dictionary of Styles, each associated with a name. A Stylesheet must also return the bundle it is associated with, in order for Styles / Property Stylers to know what bundle to retrieve images, colors, or other assets from
public protocol Stylesheet: class {
    var styles: [String: Style] { get }
    var bundle: Bundle { get }
}

extension Stylesheet {
    /// The default implementation returns the Bundle that the Stylesheet class itself is a member of
    public var bundle: Bundle { return Bundle(for: type(of: self)) }
    subscript(_ styleName: String) -> Style? {
        return styles[styleName]
    }
    /// If there are additional styles you would like to include or override in an existing Stylesheet instance, pass in a dictionary of them here.  Any style names that match existing styles in the stylesheet instance will be overridden with these new values
    public func addingAdditionalStyles(_ styles: [String: Style]) -> Stylesheet {
        return AnyStylesheet(styles: self.styles + styles)
    }
}

/// A type that defines a propertyKey that will be parsed from a stylsheet (typically a JSON stylsheet), an associated type for that key (which must conform to StylesheetParseable) and a static method which specifies how to apply that value to an instance of a specific type
public protocol PropertyStyler: AnyPropertyStylerType {
    associatedtype PropertyType: StylesheetParseable
    associatedtype TargetType
    static var propertyKey: String { get }
    static func apply(value: PropertyType?, to target: TargetType, using bundle: Bundle)
}

public extension PropertyStyler {
    static func set(value: PropertyType?) -> AnyPropertyStyler {
        return AnyPropertyStyler {
            if let target = $0 as? TargetType {
                Self.apply(value: value, to: target, using: $1)
            }
        }
    }
    
    static func set(value: @escaping (Bundle, UITraitCollection?) -> PropertyType?) -> AnyPropertyStyler {
        return AnyPropertyStyler {
            if let target = $0 as? TargetType {
                let value = value($1, (target as? UITraitEnvironment)?.traitCollection)
                Self.apply(value: value, to: target, using: $1)
            }
        }
    }
}

/// A non-generic protocol that is used as a common type for holding different generic Property Stylers in a singel array.  The wrapped static var already has a default implementation and should not be reimplemented
public protocol AnyPropertyStylerType {
    static var wrapped: Any { get }
}

public extension PropertyStyler  {
    static var wrapped: Any {
        return AnyPropertyStylerTypeWrapper(Self.self)
    }
}

/// Type-erased property styler, needed to hold arrays of them
public struct AnyPropertyStyler {
    private let propertyValueApplicator: (Styleable, Bundle) -> ()
    internal init(propertyValueApplicator: @escaping (Styleable, Bundle) -> ()) {
        self.propertyValueApplicator = propertyValueApplicator
    }
    internal func apply(to target: Styleable, using bundle: Bundle) {
        propertyValueApplicator(target, bundle)
    }
}

/// Protocol that any type must conform to in order to be used as the value that a PropertyStyler will set.  For example, in order to create a PropertyStyler that sets the alpha property on a UIView (alpha is a CGFloat type), CGFloat must be made to conform to this protocol, so it can be parsed out of a stylesheet (typically in JSON format) and then applied.
public protocol StylesheetParseable {
    static func parse(from stylesheetValue: Any) -> Self?
}

// MARK: - Operators Overloads -

/// Convenience operator to combine [String: Style] dictionaries. The merge strategy is that a duplicate key in the second / right side dictionary will overwrite the value for that same key in the left dictionary
public func +(left: [String: Style], right: [String: Style]) -> [String: Style] {
    return left.merging(right, uniquingKeysWith: { return $1 })
}

/// Convenience operator to combine two Styles. The resulting style will have all the PropertyStylers from the right Style appended to all the PropertyStylers from the left Style.  When the resulting Style is applied, it will apply every property styler in order from first to last.
public func +(left: Style, right: Style) ->  Style {
    return AnyStyle(propertyStylers: left.propertyStylers + right.propertyStylers)
}

/// Convenience operator to combine two Styles. The resulting style will have all the PropertyStylers from the right Style appended to all the PropertyStylers from the left Style.  When the resulting Style is applied, it will apply every property styler in order from first to last.
public func +(left: Stylesheet, right: Stylesheet) ->  Stylesheet {
    return left.addingAdditionalStyles(right.styles)
}


// MARK: - Internal Type Erasers -


/// A way to hold a reference to a Property Styler type itself, in a type-erased manner (for holding in arrays), and then creating a type-erased instance of the Property Styler Type as an AnyPropertyStyler on demand from either json data or an initial value.
internal struct AnyPropertyStylerTypeWrapper {
    private let jsonInitializer:(String, Any) -> AnyPropertyStyler?
    private let applicator: (Any?, Styleable, Bundle) -> ()
    internal let propertyKey: String
    internal init<T: PropertyStyler>(_ propertyStylerType: T.Type) {
        self.propertyKey = propertyStylerType.propertyKey
        let applicator: (Any?, Styleable, Bundle) -> () = {
            value, target, bundle in
            if let value = value as? T.PropertyType?, let target = target as? T.TargetType {
                T.apply(value: value, to: target, using: bundle)
            }
        }
        self.jsonInitializer = {
            propertyName, propertyValue in
            guard propertyName == T.propertyKey else { return nil }
            if propertyValue is NSNull { return AnyPropertyStyler { applicator(nil, $0, $1) } }
            if let parsedValue = T.PropertyType.parse(from: propertyValue) { return AnyPropertyStyler { applicator(parsedValue, $0, $1) } }
            return nil
        }
        self.applicator = applicator
    }
    internal func propertyStyler(jsonPropertyName: String, jsonPropertyValue: Any) -> AnyPropertyStyler? {
        return jsonInitializer(jsonPropertyName, jsonPropertyValue)
    }
}

/// A generic Style type, used as a result when combining two Style instances with different concrete types
internal struct AnyStyle: Style {
    let propertyStylers: [AnyPropertyStyler]
}

/// A generic Stylesheet type, used as a result when combining two Stylesheet instances with different concrete types
internal class AnyStylesheet: Stylesheet {
    let styles: [String : Style]
    init(styles: [String: Style]) {
        self.styles = styles
    }
}

/// Global type which exposes the core Stylish functionality methods
public struct Stylish {
    
    private static var registeredStylesheets = [String: Stylesheet]()
    
    public static func register(stylesheet: Stylesheet, named name: String) {
        registeredStylesheets[name] = stylesheet
    }
    
    /// Get or set the current global stylesheet for the application. Setting a new Stylesheet will cause the entire view hierarchy to reapply any styles using the new stylesheet
    public static var stylesheet: Stylesheet? = nil {
        didSet {
            #if !TARGET_INTERFACE_BUILDER
            switch (oldValue, stylesheet) {
            case (.some(let old), .some(let new)):
                if ObjectIdentifier(old) != ObjectIdentifier(new) {
                    refreshAllStyles()
                }
            case (.none, .some):
                refreshAllStyles()
            case (.some, .none):
                refreshAllStyles()
            default:
                break
            }
            #endif
        }
    }
    
    /// The set of built-in PropertyStyler types, such as UIView.BackgroundColor, UILabel.Text, etc. each of which knows how to apply a specific type of value to a specific property of a specific type (UIView, UILabel, etc.). Each one also specifies which property key it will handle inside a json stylesheet file, e.g. "backgroundColor"
    public static let builtInPropertyStylerTypes: [AnyPropertyStylerType.Type] = {
        var types: [AnyPropertyStylerType.Type] = [Style.backgroundColor.self, Style.contentMode.self, Style.cornerRadius.self, Style.cornerRadiusRatio.self, Style.isUserInteractionEnabled.self, Style.isHidden.self, Style.borderColor.self, Style.borderWidth.self, Style.alpha.self, Style.clipsToBounds.self, Style.masksToBounds.self, Style.tintColor.self, Style.layoutMargins.self, Style.shadowColor.self, Style.shadowOffset.self, Style.shadowOpacity.self, Style.shadowRadius.self, Style.isEnabled.self, Style.adjustsFontSizeToFitWidth.self, Style.textAlignment.self, Style.text.self, Style.textColor.self,Style.font.self,Style.isHighlighted.self, Style.baselineAdjustment.self, Style.allowsDefaultTighteningForTruncation.self, Style.lineBreakMode.self, Style.numberOfLines.self, Style.minimumScaleFactor.self, Style.preferredMaxLayoutWidth.self, Style.highlightedTextColor.self, Style.allowsEditingTextAttributes.self, Style.autocapitalizationType.self, Style.autocorrectionType.self, Style.enablesReturnKeyAutomatically.self, Style.clearsOnInsertion.self, Style.keyboardAppearance.self, Style.spellCheckingType.self, Style.keyboardType.self, Style.returnKeyType.self, Style.isSecureTextEntry.self, Style.background.self, Style.disabledBackground.self, Style.borderStyle.self, Style.clearButtonMode.self, Style.leftViewMode.self, Style.rightViewMode.self, Style.minimumFontSize.self, Style.placeholder.self, Style.clearsOnBeginEditing.self, Style.isEditable.self, Style.isSelectable.self, Style.dataDetectorTypes.self, Style.textContainerInset.self, Style.adjustsImageWhenDisabled.self, Style.adjustsImageWhenHighlighted.self, Style.showsTouchWhenHighlighted.self, Style.contentEdgeInsets.self, Style.titleEdgeInsets.self, Style.imageEdgeInsets.self, Style.titleForNormalState.self, Style.titleForHighlightedState.self, Style.titleForDisabledState.self, Style.titleColorForNormalState.self, Style.titleColorForHighlightedState.self, Style.titleColorForDisabledState.self, Style.imageForNormalState.self, Style.imageForHighlightedState.self, Style.imageForDisabledState.self, Style.backgroundImageForNormalState.self, Style.backgroundImageForHighlightedState.self, Style.backgroundImageForDisabledState.self, Style.image.self, Style.imageURL.self, Style.highlightedImage.self, Style.animationDuration.self, Style.animationRepeatCount.self, Style.animationImages.self, Style.highlightedAnimationImages.self, Style.isAnimating.self]
        if #available(iOS 10.0, *) {
            types = types + [Style.textContentType.self, Style.adjustsFontForContentSizeCategory.self]
        }
        if #available(iOS 11.0, *) {
            types = types + [Style.smartDashesType.self, Style.smartInsertDeleteType.self, Style.smartQuotesType.self, Style.adjustsImageSizeForAccessibilityContentSizeCategory.self]
        }
        return types
    }()
    
    /// Accepts a comma-separated list of style names and attempts to retrieve them from the current global stylesheet, and having done so will apply them to the target Styleable instance.
    public static func applyStyleNames(_ styles: String, to target: Styleable, using stylesheet: String?) {
        #if TARGET_INTERFACE_BUILDER
        UIView().prepareForInterfaceBuilder()
        #endif
        let targetView = target as? UIView
        let previousStylesheet = targetView?.inheritedStylesheet
        
        // If we have a non-nil stylesheet name to use for styling, or if the stylesheet name is nil and it was previously non-nil, set the inherited stylesheet property on the target view (and trigger a cascade of inheritance down its subviews)
        if stylesheet != nil || previousStylesheet != nil { targetView?.inheritedStylesheet = stylesheet }
        
        // Resolve the correct stylesheet as follows: if there is an inherited stylesheet name, retrieve the registered stylesheet with that name (it may return nil). If there is no specified or inherited stylsheet name, use the default global stylesheet
        let resolvedStylesheet = targetView?.inheritedStylesheet != nil ? registeredStylesheets[targetView!.inheritedStylesheet!] : Stylish.stylesheet
        
        var hasInvalidStyleName = false
        var combinedStyle = styles.components(separatedBy: ",").reduce(AnyStyle(propertyStylers: []) as Style) {
            let name = $1.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let style = resolvedStylesheet?[name] else {
                hasInvalidStyleName = true
                return $0
            }
            return $0 + style
        }
        #if TARGET_INTERFACE_BUILDER
        if hasInvalidStyleName { combinedStyle = combinedStyle + ErrorStyle() }
        #endif
        
        applyStyle(combinedStyle, to: target, using: resolvedStylesheet)
        
        // Don't attempt the view hierarchy refresh if rendering in Interface Builder as an IBDesignable, since IB doesn't maintain the same kind of view hierarchy
        #if !TARGET_INTERFACE_BUILDER
        // If the stylesheet for the target we are styling was changed from what it was previously, refresh the style applications for the entire view hierarchy under the target, since some of the subviews will likely have inherited the new stylesheet
        if previousStylesheet != targetView?.inheritedStylesheet {
            targetView?.subviews.forEach { Stylish.refreshStyles(for: $0) }
        }
        #endif
    }
    
    /// Applies a single Style instance to the target Stylable object
    public static func applyStyle(_ style: Style, to target: Styleable, using stylesheet: Stylesheet?) {
        style.propertyStylers.forEach { $0.apply(to: target, using: stylesheet?.bundle ?? Bundle.main) }
    }
    
    /// Refreshes the styles of all views in the app, in the event of a stylesheet change or update, etc.
    public static func refreshAllStyles() {
        for window in UIApplication.shared.windows {
            refreshStyles(for: window)
        }
    }
    
    /// Refreshes / reapplies the styling for a single view
    public static func refreshStyles(for view: UIView) {
        if let styleable = view as? Styleable {
            applyStyleNames(styleable.styles, to: styleable, using: view.inheritedStylesheet)
        }
        for subview in view.subviews {
            refreshStyles(for: subview)
        }
    }
}

/// A private framework extension that manages the cascading of stylsheets through a hierarchy of UIViews
fileprivate extension UIView {
    struct StylishAssociatedObjectKeys {
        static var inheritedStylesheet = "Stylish.inheritedStylesheet"
    }
    var inheritedStylesheet: String? {
        get {
            return objc_getAssociatedObject(self, &StylishAssociatedObjectKeys.inheritedStylesheet) as? String
        }
        set {
            let previousStylesheet = inheritedStylesheet
            switch self {
            case let styleable as Styleable:
                switch styleable.stylesheet {
                // If we have an explicitly defined stylesheet name of our own, ignore the inherited value that has been passed in and save our own explicit stylsheet as our inherited stylesheet name
                case .some:
                    objc_setAssociatedObject(self, &StylishAssociatedObjectKeys.inheritedStylesheet, styleable.stylesheet, .OBJC_ASSOCIATION_RETAIN)
                    
                // If we don't have a stylesheet specifically defined and the inherited stylesheet value matches our superview, the save it as our own inherited stylesheet name
                case .none where newValue == superview?.inheritedStylesheet:
                    objc_setAssociatedObject(self, &StylishAssociatedObjectKeys.inheritedStylesheet, newValue, .OBJC_ASSOCIATION_RETAIN)
                    
                // In other cases we ignore the passed-in value (specifically, in cases where we don't have our own value, but the value passed in doesn't match our superview's stylesheet)
                default:
                    break
                }
            // If we don't conform to Styleable anyway, there's not much to worry about since we don't define a stylesheet for ourselves. Just set what is passed in as the inherited stylesheet name.
            default:
                objc_setAssociatedObject(self, &StylishAssociatedObjectKeys.inheritedStylesheet, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
            // Now decide whether to cascade our inherited stylsheet to our own children
            switch inheritedStylesheet {
            // In the case where our inherited stylesheet is nil, but it previously had a value we need to cascade the change to nil down to our subviews
            case .none where previousStylesheet != nil:
                fallthrough
            // In the case where we the inherited stylesheet is nil, but we aren't styleable and don't need to factor in a possible explicit stylesheet, just go ahead and pass the nil through as the inheritedStylesheet to our subviews
            case .none where !(self is Styleable):
                fallthrough
            // If the inheritedStylesheet isn't nil, cascade it down to our subviews
            case .some:
                subviews.forEach { $0.inheritedStylesheet = inheritedStylesheet }
            // For other scenarios (when inheritedStylesheet is nil, but we ARE Styleable and don't have a previous value), do nothing
            default:
                break
            }
        }
    }
}
