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

/// A protocol that view types conform to in order to participate in the Stylish styling process
public protocol Styleable: class {
    var styles: String { get set }
}

/// A protocol that a type conforms to in order to be considered a Style.  Essentially, a style is a collection of value changes that will be applied to specific properties, so a Style is composed of a set of these property specific stylers.
public protocol Style {
    var propertyStylers: [AnyPropertyStyler] { get }
}

/// The protocol a type must conform to in order to be used as a Stylesheet. A Stylesheet is simply a dictionary of Styles, each associated with a name
public protocol Stylesheet {
    var styles: [String: Style] { get }
}

extension Stylesheet {
    subscript(_ styleName: String) -> Style? {
        return styles[styleName]
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


/// Global type which exposes the core Stylish functionality methods
public struct Stylish {
    
    
    
    /// Get or set the current global stylesheet for the application. Setting a new Stylesheet will cause the entire view hierarchy to reapply any styles using the new stylesheet
    public static var stylesheet: Stylesheet? = nil {
        didSet {
            if type(of: stylesheet) != type(of: oldValue) {
                refreshAllStyles()
            }
        }
    }
    
    private typealias UIView = Stylish.PropertyStyler.UIView
    private typealias UILabel = Stylish.PropertyStyler.UILabel
    private typealias UITextField = Stylish.PropertyStyler.UITextField
    private typealias UITextView = Stylish.PropertyStyler.UITextView
    private typealias UIButton = Stylish.PropertyStyler.UIButton
    private typealias UIImageView = Stylish.PropertyStyler.UIImageView
    
    /// The set of built-in PropertyStyler types, such as UIView.BackgroundColor, UILabel.Text, etc. each of which knows how to apply a specific type of value to a specific property of a specific type (UIView, UILabel, etc.). Each one also specifies which property key it will handle inside a json stylesheet file, e.g. "backgroundColor"
    public static let builtInPropertyStylerTypes: [AnyPropertyStylerType.Type] = {
        var types: [AnyPropertyStylerType.Type] = [UIView.BackgroundColor.self, UIView.ContentMode.self, UIView.CornerRadius.self, UIView.CornerRadiusRatio.self, UIView.IsUserInteractionEnabled.self, UIView.IsHidden.self, UIView.BorderColor.self, UIView.BorderWidth.self, UIView.Alpha.self, UIView.ClipsToBounds.self, UIView.MasksToBounds.self, UIView.TintColor.self, UIView.LayoutMargins.self, UIView.ShadowColor.self, UIView.ShadowOffset.self, UIView.ShadowOpacity.self, UIView.ShadowRadius.self, UILabel.IsEnabled.self, UILabel.AdjustsFontSizeToFitWidth.self, UILabel.TextAlignment.self, UILabel.Text.self, UILabel.TextColor.self, UILabel.Font.self, UILabel.IsHighlighted.self, UILabel.BaselineAdjustment.self, UILabel.AllowsDefaultTighteningForTruncation.self, UILabel.LineBreakMode.self, UILabel.NumberOfLines.self, UILabel.MinimumScaleFactor.self, UILabel.PreferredMaxLayoutWidth.self, UILabel.HighlightedTextColor.self, UITextField.AllowsEditingTextAttributes.self, UITextField.AutocapitalizationType.self, UITextField.AutocorrectionType.self, UITextField.EnablesReturnKeyAutomatically.self, UITextField.ClearsOnInsertion.self, UITextField.KeyboardAppearance.self, UITextField.SpellCheckingType.self, UITextField.KeyboardType.self, UITextField.ReturnKeyType.self, UITextField.IsSecureTextEntry.self, UITextField.Background.self, UITextField.DisabledBackground.self, UITextField.BorderStyle.self, UITextField.ClearButtonMode.self, UITextField.LeftViewMode.self, UITextField.RightViewMode.self, UITextField.MinimumFontSize.self, UITextField.Placeholder.self, UITextField.ClearsOnBeginEditing.self, UITextView.IsEditable.self, UITextView.IsSelectable.self, UITextView.DataDetectorTypes.self, UITextView.TextContainerInset.self, UIButton.AdjustsImageWhenDisabled.self, UIButton.AdjustsImageWhenHighlighted.self, UIButton.ShowsTouchWhenHighlighted.self, UIButton.ContentEdgeInsets.self, UIButton.ButtonFont.self, UIButton.TitleEdgeInsets.self, UIButton.ImageEdgeInsets.self, UIButton.TitleForNormalState.self, UIButton.TitleForHighlightedState.self, UIButton.TitleForDisabledState.self, UIButton.TitleColorForNormalState.self, UIButton.TitleColorForHighlightedState.self, UIButton.TitleColorForDisabledState.self, UIButton.ImageForNormalState.self, UIButton.ImageForHighlightedState.self, UIButton.ImageForDisabledState.self, UIButton.BackgroundImageForNormalState.self, UIButton.BackgroundImageForHighlightedState.self, UIButton.BackgroundImageForDisabledState.self, UIImageView.Image.self, UIImageView.ImageURL.self, UIImageView.HighlightedImage.self, UIImageView.AnimationDuration.self, UIImageView.AnimationRepeatCount.self, UIImageView.AnimationImages.self, UIImageView.HighlightedAnimationImages.self, UIImageView.IsAnimating.self]
        if #available(iOS 10.0, *) {
            types = types + [UITextField.TextContentType.self, UILabel.AdjustsFontForContentSizeCategory.self]
        }
        if #available(iOS 11.0, *) {
            types = types + [UITextField.SmartDashesType.self, UITextField.SmartInsertDeleteType.self, UITextField.SmartQuotesType.self, UIImageView.AdjustsImageSizeForAccessibilityContentSizeCategory.self]
        }
        return types
    }()
    
    /// Accepts a comma-separated list of style names and attempts to retrieve them from the current global stylesheet, and having done so will apply them to the target Styleable instance.
    public static func applyStyleNames(_ styles: String, to target: Styleable) {
        #if TARGET_INTERFACE_BUILDER
            UIKit.UIView().prepareForInterfaceBuilder()
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
    public static func refreshStyles(for view:UIKit.UIView) {
        for subview in view.subviews {
            refreshStyles(for: subview)
        }
        if let styleable = view as? Styleable {
            applyStyleNames(styleable.styles, to: styleable)
        }
    }
}
