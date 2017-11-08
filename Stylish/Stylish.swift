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

/// A protocol that view types conform to in order to participate in the Stylish styling process. Requires a "styles" String property which can hold a comma-separated list of style names. Usually implemented as an IBInspectable property
public protocol Styleable: class {
    var styles: String { get set }
}

/// A protocol that a type conforms to in order to be considered a Style.  Essentially, a style is a collection of value changes that will be applied to specific properties, so a Style is composed of a set of these property specific stylers.
public protocol Style {
    var propertyStylers: [AnyPropertyStyler] { get }
}

/// The protocol a type must conform to in order to be used as a Stylesheet. A Stylesheet is simply a dictionary of Styles, each associated with a name
public protocol Stylesheet: class {
    var styles: [String: Style] { get }
}

extension Stylesheet {
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
    static func apply(value: PropertyType?, to target: TargetType)
}

public extension PropertyStyler {
    public static func set(value: PropertyType?) -> AnyPropertyStyler {
        return AnyPropertyStyler{ if let target = $0 as? TargetType { Self.apply(value: value, to: target) } }
    }
}

/// A non-generic protocol that is used as a common type for holding different generic Property Stylers in a singel array.  The wrapped static var already has a default implementation and should not be reimplemented
public protocol AnyPropertyStylerType {
    static var wrapped: Any { get }
}

public extension PropertyStyler  {
    public static var wrapped: Any {
        return AnyPropertyStylerTypeWrapper(Self.self)
    }
}

/// Type-erased property styler, needed to hold arrays of them
public struct AnyPropertyStyler {
    private let propertyValueApplicator: (Styleable) -> ()
    internal init(propertyValueApplicator: @escaping (Styleable) -> ()) {
        self.propertyValueApplicator = propertyValueApplicator
    }
    internal func apply(to target: Styleable) {
        propertyValueApplicator(target)
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
    private let applicator: (Any?, Styleable) -> ()
    internal let propertyKey: String
    internal init<T: PropertyStyler>(_ propertyStylerType: T.Type) {
        self.propertyKey = propertyStylerType.propertyKey
        let applicator: (Any?, Styleable) -> () = {
            value, target in
            if let value = value as? T.PropertyType?, let target = target as? T.TargetType {
                T.apply(value: value, to: target)
            }
        }
        self.jsonInitializer = {
            propertyName, propertyValue in
            guard propertyName == T.propertyKey else { return nil }
            if propertyValue is NSNull { return AnyPropertyStyler { applicator(nil, $0) } }
            if let parsedValue = T.PropertyType.parse(from: propertyValue) { return AnyPropertyStyler { applicator(parsedValue, $0) } }
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
    
    /// Get or set the current global stylesheet for the application. Setting a new Stylesheet will cause the entire view hierarchy to reapply any styles using the new stylesheet
    public static var stylesheet: Stylesheet? = nil {
        didSet {
            #if TARGET_INTERFACE_BUILDER
                return
            #endif
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
    public static func applyStyleNames(_ styles: String, to target: Styleable) {
        #if TARGET_INTERFACE_BUILDER
            UIView().prepareForInterfaceBuilder()
        #endif
        var hasInvalidStyleName = false
        var combinedStyle = styles.components(separatedBy: ",").reduce(AnyStyle(propertyStylers: []) as Style) {
            let name = $1.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let style = stylesheet?[name] else {
                hasInvalidStyleName = true
                return $0
            }
            return $0 + style
        }
        #if TARGET_INTERFACE_BUILDER
            if hasInvalidStyleName { combinedStyle = combinedStyle + ErrorStyle() }
        #endif
        applyStyle(combinedStyle, to: target)
    }
    
    /// Applies a single Style instance to the target Stylable object
    public static func applyStyle(_ style: Style, to target: Styleable) {
        style.propertyStylers.forEach { $0.apply(to: target) }
    }
    
    /// Refreshes the styles of all views in the app, in the event of a stylesheet change or update, etc.
    public static func refreshAllStyles() {
        for window in UIApplication.shared.windows {
            refreshStyles(for: window)
        }
    }
    
    /// Refreshes / reapplies the styling for a single view
    public static func refreshStyles(for view: UIView) {
        for subview in view.subviews {
            refreshStyles(for: subview)
        }
        if let styleable = view as? Styleable {
            applyStyleNames(styleable.styles, to: styleable)
        }
    }
}
