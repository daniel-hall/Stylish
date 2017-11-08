//
//  PropertyStylers.swift
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

// An empty protocol to conform UILabel, UITextField and UITextView to, so they can be styled with the same Property Styler
public protocol TextControl: class {
    var textAlignment: NSTextAlignment { get set }
    @available(iOS 10.0, *) var adjustsFontForContentSizeCategory: Bool { get set }
}

public protocol TextInputControl: class, TextControl {
    var allowsEditingTextAttributes: Bool { get set }
    var autocapitalizationType: UITextAutocapitalizationType { get set }
    var autocorrectionType: UITextAutocorrectionType { get set }
    var enablesReturnKeyAutomatically: Bool { get set }
    var clearsOnInsertion: Bool { get set }
    var keyboardAppearance: UIKeyboardAppearance { get set }
    var spellCheckingType: UITextSpellCheckingType { get set }
    @available(iOS 11.0, *) var smartDashesType: UITextSmartDashesType { get set }
    @available(iOS 11.0, *) var smartInsertDeleteType: UITextSmartInsertDeleteType { get set }
    @available(iOS 11.0, *) var smartQuotesType: UITextSmartQuotesType { get set }
    var keyboardType: UIKeyboardType { get set }
    var returnKeyType: UIReturnKeyType { get set }
    var isSecureTextEntry: Bool { get set }
    @available(iOS 10.0, *) var textContentType: UITextContentType! { get set }
}

extension UILabel: TextControl {}
extension UITextField: TextInputControl {}
extension UITextView: TextInputControl {}

public extension Style {
    typealias UIView = Stylish.PropertyStyler.UIView
    typealias UILabel = Stylish.PropertyStyler.UILabel
    typealias UITextField = Stylish.PropertyStyler.UITextField
    typealias UITextView = Stylish.PropertyStyler.UITextView
    typealias UIButton = Stylish.PropertyStyler.UIButton
    typealias UIImageView = Stylish.PropertyStyler.UIImageView
}


public extension Stylish {
    public enum PropertyStyler {}
}

public extension Stylish.PropertyStyler {
    
    public class UIView {
        
        public struct BackgroundColor: PropertyStyler {
            public static var propertyKey: String { return "backgroundColor" }
            public static func apply(value: UIColor?, to target: UIKit.UIView) {
                target.backgroundColor = value
            }
        }
        
        public struct ContentMode: PropertyStyler {
            public static var propertyKey: String { return "contentMode" }
            public static func apply(value: UIViewContentMode?, to target: UIKit.UIView) {
                target.contentMode = value ?? .scaleToFill
            }
        }
        
        public struct CornerRadius: PropertyStyler {
            public static var propertyKey: String { return "cornerRadius" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView) {
                target.layer.cornerRadius = value ?? 0
            }
        }
        
        public struct CornerRadiusRatio: PropertyStyler {
            public static var propertyKey: String { return "cornerRadiusRatio" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView) {
                target.layer.cornerRadius = (target.bounds.height * ( value ?? 0))
            }
        }
        
        public struct IsUserInteractionEnabled: PropertyStyler {
            public static var propertyKey: String { return "isUserInteractionEnabled" }
            public static func apply(value: Bool?, to target: UIKit.UIView) {
                target.isUserInteractionEnabled = value ?? true
            }
        }
        
        public struct IsHidden: PropertyStyler {
            public static var propertyKey: String { return "isHidden" }
            public static func apply(value: Bool?, to target: UIKit.UIView) {
                target.isHidden = value ?? false
            }
        }
        
        public struct BorderColor: PropertyStyler {
            public static var propertyKey: String { return "borderColor" }
            public static func apply(value: UIColor?, to target: UIKit.UIView) {
                target.layer.borderColor = value?.cgColor
            }
        }
        
        public struct BorderWidth: PropertyStyler {
            public static var propertyKey: String { return "borderWidth" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView) {
                target.layer.borderWidth = value ?? 0
            }
        }
        
        public struct Alpha: PropertyStyler {
            public static var propertyKey: String { return "alpha" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView) {
                target.alpha = value ?? 1.0
            }
        }
        
        public struct ClipsToBounds: PropertyStyler {
            public static var propertyKey: String { return "clipsToBounds" }
            public static func apply(value: Bool?, to target: UIKit.UIView) {
                target.clipsToBounds = value ?? false
            }
        }
        
        public struct MasksToBounds: PropertyStyler {
            public static var propertyKey: String { return "masksToBounds" }
            public static func apply(value: Bool?, to target: UIKit.UIView) {
                target.layer.masksToBounds = value ?? false
            }
        }
        
        public struct TintColor: PropertyStyler {
            public static var propertyKey: String { return "tintColor" }
            public static func apply(value: UIColor?, to target: UIKit.UIView) {
                target.tintColor = value
            }
        }
        
        public struct LayoutMargins: PropertyStyler {
            public static var propertyKey: String { return "layoutMargins" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UIView) {
                target.layoutMargins = value ?? UIKit.UIView().layoutMargins
            }
        }
        
        public struct ShadowColor: PropertyStyler {
            public static var propertyKey: String { return "shadowColor" }
            public static func apply(value: UIColor?, to target: UIKit.UIView) {
                if let label = target as? UIKit.UILabel {
                    label.shadowColor = value
                } else {
                    target.layer.shadowColor = value?.cgColor
                }
            }
        }
        
        public struct ShadowOffset: PropertyStyler {
            public static var propertyKey: String { return "shadowOffset" }
            public static func apply(value: CGSize?, to target: UIKit.UIView) {
                if let label = target as? UIKit.UILabel {
                    label.shadowOffset = value ?? .zero
                } else {
                    target.layer.shadowOffset = value ?? .zero
                }
            }
        }
        
        public struct ShadowRadius: PropertyStyler {
            public static var propertyKey: String { return "shadowRadius" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView) {
                target.layer.shadowRadius = value ?? 0
            }
        }
        
        public struct ShadowOpacity: PropertyStyler {
            public static var propertyKey: String { return "shadowOpacity" }
            public static func apply(value: Float?, to target: UIKit.UIView) {
                target.layer.shadowOpacity = value ?? 0
            }
        }
    }
    
    public class UIControl: UIView {
        
        public struct IsEnabled: PropertyStyler {
            public static var propertyKey: String { return "isEnabled" }
            public static func apply(value: Bool?, to target: UIKit.UIControl) {
                target.isEnabled = value ?? true
            }
        }
    }
    
    public class StylishTextControl: UIControl {
        
        public struct AdjustsFontSizeToFitWidth: PropertyStyler {
            public static var propertyKey: String { return "adjustsFontSizeToFitWidth" }
            public static func apply(value: Bool?, to target: TextControl) {
                switch target {
                case let label as UIKit.UILabel:
                    label.adjustsFontSizeToFitWidth = value ?? false
                case let textField as UIKit.UITextField:
                    textField.adjustsFontSizeToFitWidth = value ?? false
                default: break
                }        }
        }
        
        @available(iOS 10.0, *) 
        public struct AdjustsFontForContentSizeCategory: PropertyStyler {
            public static var propertyKey: String { return "adjustsFontForContentSizeCategory" }
            public static func apply(value: Bool?, to target: TextControl) {
                target.adjustsFontForContentSizeCategory = value ?? false
            }
        }
        
        public struct TextAlignment: PropertyStyler {
            public static var propertyKey: String { return "textAlignment" }
            public static func apply(value: NSTextAlignment?, to target: TextControl) {
                target.textAlignment = value ?? .left
            }
        }
        
        public struct Text: PropertyStyler {
            public static var propertyKey: String { return "text" }
            public static func apply(value: String?, to target: TextControl) {
                switch target {
                case let label as UIKit.UILabel:
                    label.text = value
                case let textField as UIKit.UITextField:
                    textField.text = value
                case let textView as UIKit.UITextView:
                    textView.text = value
                default: break
                }        }
        }
        
        public struct TextColor: PropertyStyler {
            public static var propertyKey: String { return "textColor" }
            public static func apply(value: UIColor?, to target: TextControl) {
                switch target {
                case let label as UIKit.UILabel:
                    label.textColor = value
                case let textField as UIKit.UITextField:
                    textField.textColor = value
                case let textView as UIKit.UITextView:
                    textView.textColor = value
                default: break
                }
            }
        }
        
        public struct Font: PropertyStyler {
            public static var propertyKey: String { return "font" }
            public static func apply(value: UIFont?, to target: UIKit.UIView) {
                switch target {
                case let label as UIKit.UILabel:
                    label.font = value
                case let textField as UIKit.UITextField:
                    textField.font = value
                case let textView as UIKit.UITextView:
                    textView.font = value
                case let button as UIKit.UIButton:
                    button.titleLabel?.font = value
                default: break
                }
            }
        }
        
        public struct IsHighlighted: PropertyStyler {
            public static var propertyKey: String { return "isHighlighted" }
            public static func apply(value: Bool?, to target: TextControl) {
                switch target {
                case let label as UIKit.UILabel:
                    label.isHighlighted = value ?? false
                case let textField as UIKit.UITextField:
                    textField.isHighlighted = value ?? false
                default: break
                }
            }
        }
    }
    
    public class UILabel: StylishTextControl {
        
        public struct BaselineAdjustment: PropertyStyler {
            public static var propertyKey: String { return "baselineAdjustment" }
            public static func apply(value: UIBaselineAdjustment?, to target: UIKit.UILabel) {
                target.baselineAdjustment = value ?? .alignBaselines
            }
        }
        
        public struct AllowsDefaultTighteningForTruncation: PropertyStyler {
            public static var propertyKey: String { return "allowsDefaultTighteningForTruncation" }
            public static func apply(value: Bool?, to target: UIKit.UILabel) {
                target.allowsDefaultTighteningForTruncation = value ?? false
            }
        }
        
        public struct LineBreakMode: PropertyStyler {
            public static var propertyKey: String { return "lineBreakMode" }
            public static func apply(value: NSLineBreakMode?, to target: UIKit.UILabel) {
                target.lineBreakMode = value ?? .byTruncatingTail
            }
        }
        
        public struct NumberOfLines: PropertyStyler {
            public static var propertyKey: String { return "numberOfLines" }
            public static func apply(value: Int?, to target: UIKit.UILabel) {
                target.numberOfLines = value ?? 1
            }
        }
        
        public struct MinimumScaleFactor: PropertyStyler {
            public static var propertyKey: String { return "minimumScaleFactor" }
            public static func apply(value: CGFloat?, to target: UIKit.UILabel) {
                target.minimumScaleFactor = value ?? 0.0
            }
        }
        
        public struct PreferredMaxLayoutWidth: PropertyStyler {
            public static var propertyKey: String { return "preferredMaxLayoutWidth" }
            public static func apply(value: CGFloat?, to target: UIKit.UILabel) {
                target.minimumScaleFactor = value ?? 0.0
            }
        }
        
        public struct HighlightedTextColor: PropertyStyler {
            public static var propertyKey: String { return "highlightedTextColor" }
            public static func apply(value: UIColor?, to target: UIKit.UILabel) {
                target.highlightedTextColor = value
            }
        }
    }
    
    public class StylishTextInputControl: StylishTextControl {
        
        public struct AllowsEditingTextAttributes: PropertyStyler {
            public static var propertyKey: String { return "allowsEditingTextAttributes" }
            public static func apply(value: Bool?, to target: TextInputControl) {
                switch target {
                case let textField as UIKit.UITextField:
                    textField.allowsEditingTextAttributes = value ?? false
                case let textView as UIKit.UITextView:
                    textView.allowsEditingTextAttributes = value ?? false
                default: break
                }
            }
        }
        
        public struct AutocapitalizationType: PropertyStyler {
            public static var propertyKey: String { return "autocapitalizationType" }
            public static func apply(value: UITextAutocapitalizationType?, to target: TextInputControl) {
                target.autocapitalizationType = value ?? .sentences
            }
        }
        
        public struct AutocorrectionType: PropertyStyler {
            public static var propertyKey: String { return "autocorrectionType" }
            public static func apply(value: UITextAutocorrectionType?, to target: TextInputControl) {
                target.autocorrectionType = value ?? .default
            }
        }
        
        public struct EnablesReturnKeyAutomatically: PropertyStyler {
            public static var propertyKey: String { return "enablesReturnKeyAutomatically" }
            public static func apply(value: Bool?, to target: TextInputControl) {
                target.enablesReturnKeyAutomatically = value ?? false
            }
        }
        
        public struct ClearsOnInsertion: PropertyStyler {
            public static var propertyKey: String { return "clearsOnInsertion" }
            public static func apply(value: Bool?, to target: TextInputControl) {
                target.clearsOnInsertion = value ?? false
            }
        }
        
        public struct KeyboardAppearance: PropertyStyler {
            public static var propertyKey: String { return "keyboardAppearance" }
            public static func apply(value: UIKeyboardAppearance?, to target: TextInputControl) {
                target.keyboardAppearance = value ?? .default
            }
        }
        
        public struct SpellCheckingType: PropertyStyler {
            public static var propertyKey: String { return "spellCheckingType" }
            public static func apply(value: UITextSpellCheckingType?, to target: TextInputControl) {
                target.spellCheckingType = value ?? .default
            }
        }
        
        @available(iOS 11.0, *)
        public struct SmartDashesType: PropertyStyler {
            public static var propertyKey: String { return "smartDashesType" }
            public static func apply(value: UITextSmartDashesType?, to target: TextInputControl) {
                target.smartDashesType = value ?? .default
            }
        }
        
        @available(iOS 11.0, *)
        public struct SmartInsertDeleteType: PropertyStyler {
            public static var propertyKey: String { return "smartInsertDeleteType" }
            public static func apply(value: UITextSmartInsertDeleteType?, to target: TextInputControl) {
                target.smartInsertDeleteType = value ?? .default
            }
        }
        
        @available(iOS 11.0, *)
        public struct SmartQuotesType: PropertyStyler {
            public static var propertyKey: String { return "smartQuotesType" }
            public static func apply(value: UITextSmartQuotesType?, to target: TextInputControl) {
                target.smartQuotesType = value ?? .default
            }
        }
        
        public struct KeyboardType: PropertyStyler {
            public static var propertyKey: String { return "keyboardType" }
            public static func apply(value: UIKeyboardType?, to target: TextInputControl) {
                target.keyboardType = value ?? .default
            }
        }
        
        public struct ReturnKeyType: PropertyStyler {
            public static var propertyKey: String { return "returnKeyType" }
            public static func apply(value: UIReturnKeyType?, to target: TextInputControl) {
                target.returnKeyType = value ?? .default
            }
        }
        
        public struct IsSecureTextEntry: PropertyStyler {
            public static var propertyKey: String { return "isSecureTextEntry" }
            public static func apply(value: Bool?, to target: TextInputControl) {
                target.isSecureTextEntry = value ?? false
            }
        }
        
        @available(iOS 10.0, *)
        public struct TextContentType: PropertyStyler {
            public static var propertyKey: String { return "textContentType" }
            public static func apply(value: UITextContentType?, to target: TextInputControl) {
                target.textContentType = value
            }
        }
    }
    
    public class UITextField: StylishTextInputControl {
        public struct Background: PropertyStyler {
            public static var propertyKey: String { return "background" }
            public static func apply(value: UIImage?, to target: UIKit.UITextField) {
                target.background = value
            }
        }
        
        public struct DisabledBackground: PropertyStyler {
            public static var propertyKey: String { return "disabledBackground" }
            public static func apply(value: UIImage?, to target: UIKit.UITextField) {
                target.disabledBackground = value
            }
        }
        
        public struct BorderStyle: PropertyStyler {
            public static var propertyKey: String { return "borderStyle" }
            public static func apply(value: UITextBorderStyle?, to target: UIKit.UITextField) {
                target.borderStyle = value ?? .none
            }
        }
        
        public struct ClearButtonMode: PropertyStyler {
            public static var propertyKey: String { return "clearButtonMode" }
            public static func apply(value: UITextFieldViewMode?, to target: UIKit.UITextField) {
                target.clearButtonMode = value ?? .never
            }
        }
        
        public struct LeftViewMode: PropertyStyler {
            public static var propertyKey: String { return "leftViewMode" }
            public static func apply(value: UITextFieldViewMode?, to target: UIKit.UITextField) {
                target.leftViewMode = value ?? .never
            }
        }
        
        public struct RightViewMode: PropertyStyler {
            public static var propertyKey: String { return "rightViewMode" }
            public static func apply(value: UITextFieldViewMode?, to target: UIKit.UITextField) {
                target.rightViewMode = value ?? .never
            }
        }
        
        public struct MinimumFontSize: PropertyStyler {
            public static var propertyKey: String { return "minimumFontSize" }
            public static func apply(value: CGFloat?, to target: UIKit.UITextField) {
                target.minimumFontSize = value ?? 0.0
            }
        }
        
        public struct Placeholder: PropertyStyler {
            public static var propertyKey: String { return "placeholder" }
            public static func apply(value: String?, to target: UIKit.UITextField) {
                target.placeholder = value
            }
        }
        
        public struct ClearsOnBeginEditing: PropertyStyler {
            public static var propertyKey: String { return "clearsOnBeginEditing" }
            public static func apply(value: Bool?, to target: UIKit.UITextField) {
                target.clearsOnBeginEditing = value ?? false
            }
        }
    }
    
    public class UITextView: StylishTextInputControl {
        
        public struct IsEditable: PropertyStyler {
            public static var propertyKey: String { return "isEditable" }
            public static func apply(value: Bool?, to target: UIKit.UITextView) {
                target.isEditable = value ?? false
            }
        }
        
        public struct IsSelectable: PropertyStyler {
            public static var propertyKey: String { return "isSelectable" }
            public static func apply(value: Bool?, to target: UIKit.UITextView) {
                target.isSelectable = value ?? false
            }
        }
        
        public struct DataDetectorTypes: PropertyStyler {
            public static var propertyKey: String { return "dataDetectorTypes" }
            public static func apply(value: UIDataDetectorTypes?, to target: UIKit.UITextView) {
                target.dataDetectorTypes = value ?? []
            }
        }
        
        public struct TextContainerInset: PropertyStyler {
            public static var propertyKey: String { return "textContainerInset" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UITextView) {
                target.textContainerInset = value ?? UIKit.UITextView().textContainerInset
            }
        }
    }
    
    public class UIButton: UIControl {
        
        public struct AdjustsImageWhenDisabled: PropertyStyler {
            public static var propertyKey: String { return "adjustsImageWhenDisabled" }
            public static func apply(value: Bool?, to target: UIKit.UIButton) {
                target.adjustsImageWhenDisabled = value ?? true
            }
        }
        
        public struct AdjustsImageWhenHighlighted: PropertyStyler {
            public static var propertyKey: String { return "adjustsImageWhenHighlighted" }
            public static func apply(value: Bool?, to target: UIKit.UIButton) {
                target.adjustsImageWhenHighlighted = value ?? true
            }
        }
        
        public struct ShowsTouchWhenHighlighted: PropertyStyler {
            public static var propertyKey: String { return "showsTouchWhenHighlighted" }
            public static func apply(value: Bool?, to target: UIKit.UIButton) {
                target.showsTouchWhenHighlighted = value ?? false
            }
        }
        
        public struct ContentEdgeInsets: PropertyStyler {
            public static var propertyKey: String { return "contentEdgeInsets" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UIButton) {
                target.contentEdgeInsets = value ?? UIKit.UIButton().contentEdgeInsets
            }
        }
        
        public struct TitleEdgeInsets: PropertyStyler {
            public static var propertyKey: String { return "titleEdgeInsets" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UIButton) {
                target.titleEdgeInsets = value ?? UIKit.UIButton().titleEdgeInsets
            }
        }
        
        public struct ImageEdgeInsets: PropertyStyler {
            public static var propertyKey: String { return "imageEdgeInsets" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UIButton) {
                target.imageEdgeInsets = value ?? UIKit.UIButton().imageEdgeInsets
            }
        }
        
        public struct TitleForNormalState: PropertyStyler {
            public static var propertyKey: String { return "titleForNormalState" }
            public static func apply(value: String?, to target: UIKit.UIButton) {
                target.setTitle(value, for: .normal)
            }
        }
        
        public struct TitleForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "titleForHighlightedState" }
            public static func apply(value: String?, to target: UIKit.UIButton) {
                target.setTitle(value, for: .highlighted)
            }
        }
        
        public struct TitleForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "titleForDisabledState" }
            public static func apply(value: String?, to target: UIKit.UIButton) {
                target.setTitle(value, for: .disabled)
            }
        }
        
        public struct TitleColorForNormalState: PropertyStyler {
            public static var propertyKey: String { return "titleColorForNormalState" }
            public static func apply(value: UIColor?, to target: UIKit.UIButton) {
                target.setTitleColor(value, for: .normal)
            }
        }
        
        public struct TitleColorForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "titleColorForHighlightedState" }
            public static func apply(value: UIColor?, to target: UIKit.UIButton) {
                target.setTitleColor(value, for: .highlighted)
            }
        }
        
        public struct TitleColorForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "titleColorForDisabledState" }
            public static func apply(value: UIColor?, to target: UIKit.UIButton) {
                target.setTitleColor(value, for: .disabled)
            }
        }
        
        public struct ImageForNormalState: PropertyStyler {
            public static var propertyKey: String { return "imageForNormalState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton) {
                target.setImage(value, for: .normal)
            }
            public let value: UIImage?
            public init(value: UIImage?) {
                self.value = value
            }
        }
        
        public struct ImageForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "imageForHighlightedState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton) {
                target.setImage(value, for: .highlighted)
            }
        }
        
        public struct ImageForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "imageForDisabledState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton) {
                target.setImage(value, for: .disabled)
            }
        }
        
        public struct BackgroundImageForNormalState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageForNormalState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton) {
                target.setBackgroundImage(value, for: .normal)
            }
        }
        
        public struct BackgroundImageForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageForHighlightedState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton) {
                target.setBackgroundImage(value, for: .highlighted)
            }
        }
        
        public struct BackgroundImageForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageForDisabledState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton) {
                target.setBackgroundImage(value, for: .disabled)
            }
        }
    }
    
    public class UIImageView: UIView {
        public struct Image: PropertyStyler {
            public static var propertyKey: String { return "image" }
            public static func apply(value: UIImage?, to target: UIKit.UIImageView) {
                target.image = value
            }
        }
        
        public struct ImageURL: PropertyStyler {
            public static var propertyKey: String { return "imageURL" }
            public static func apply(value: URL?, to target: UIKit.UIImageView) {
                if let url = value {
                    #if TARGET_INTERFACE_BUILDER
                        target.image = UIImage(named: "StylishPlaceholderImage", in: Bundle(for:StyleableUIView.self), compatibleWith: nil)
                        target.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
                        target.contentMode = .scaleAspectFit
                        target.alpha = 0.7
                    #else
                        URLSession.shared.dataTask(with: url) {
                            data, _, _ in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    target.image = image
                                }
                            }
                            }.resume()
                    #endif
                }
            }
        }
        
        public struct HighlightedImage: PropertyStyler {
            public static var propertyKey: String { return "highlightedImage" }
            public static func apply(value: UIImage?, to target: UIKit.UIImageView) {
                target.highlightedImage = value
            }
        }
        
        @available(iOS 11.0, *)
        public struct AdjustsImageSizeForAccessibilityContentSizeCategory: PropertyStyler {
            public static var propertyKey: String { return "adjustsImageSizeForAccessibilityContentSizeCategory" }
            public static func apply(value: Bool?, to target: UIKit.UIImageView) {
                target.adjustsImageSizeForAccessibilityContentSizeCategory = value ?? false
            }
        }
        
        public struct AnimationDuration: PropertyStyler {
            public static var propertyKey: String { return "animationDuration" }
            public static func apply(value: Double?, to target: UIKit.UIImageView) {
                target.animationDuration = value ?? Double((target.animationImages ?? []).count) * 0.0333333
            }
        }
        
        public struct AnimationRepeatCount: PropertyStyler {
            public static var propertyKey: String { return "animationRepeatCount" }
            public static func apply(value: Int?, to target: UIKit.UIImageView) {
                target.animationRepeatCount = value ?? 0
            }
        }
        
        public struct AnimationImages: PropertyStyler {
            public static var propertyKey: String { return "animationImages" }
            public static func apply(value: UIImageArray?, to target: UIKit.UIImageView) {
                target.animationImages = value?.images
            }
        }
        
        public struct HighlightedAnimationImages: PropertyStyler {
            public static var propertyKey: String { return "highlightedAnimationImages" }
            public static func apply(value: UIImageArray?, to target: UIKit.UIImageView) {
                target.highlightedAnimationImages = value?.images
            }
        }
        
        public struct IsAnimating: PropertyStyler {
            public static var propertyKey: String { return "isAnimating" }
            public static func apply(value: Bool?, to target: UIKit.UIImageView) {
                if value == true { target.startAnimating() } else { target.stopAnimating() }
            }
        }
    }
}


// MARK: - Stylish Internal Use Styles -

public struct ErrorStyle: Style {
    private(set) public var propertyStylers = [UIViewStripedSubviewStyler.set(value: .red)]
}

public struct UIViewStripedSubviewStyler: PropertyStyler {
    public static var propertyKey:String { return "stripedSubview" }
    private static let tag  = 298529835
    public static func apply(value: UIColor?, to target: Styleable) {
        if let target = target as? UIView, let value = value {
            target.viewWithTag(tag)?.removeFromSuperview()
            let context = CIContext()
            let stripesFilter = CIFilter(name: "CIStripesGenerator", withInputParameters: ["inputColor0" : CIColor(color: value.withAlphaComponent(0.4)), "inputColor1" : CIColor(color: value.withAlphaComponent(0.6)), "inputWidth" : 2])!
            let stripes = context.createCGImage(stripesFilter.outputImage!, from: CGRect(origin: CGPoint.zero, size: CGSize(width: 32.0, height: 32.0)))
            let rotateFilter = CIFilter(name: "CIStraightenFilter", withInputParameters: ["inputImage" : CIImage(cgImage: stripes!), "inputAngle" : 2.35])!
            let rotated = context.createCGImage(rotateFilter.outputImage!, from: rotateFilter.outputImage!.extent)
            let stripesView = UIView()
            stripesView.backgroundColor = UIColor(patternImage: UIImage(cgImage: rotated!))
            stripesView.frame = target.bounds
            target.addSubview(stripesView)
        }
    }
}
