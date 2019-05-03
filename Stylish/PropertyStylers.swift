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


public extension Style {
    /// Sets property value on UIViews and subclasses
    typealias backgroundColor = Stylish.PropertyStylers.UIView.BackgroundColor
    /// Sets property value on UIViews and subclasses
    typealias contentMode  = Stylish.PropertyStylers.UIView.ContentMode
    /// Sets property value on UIViews and subclasses
    typealias cornerRadius = Stylish.PropertyStylers.UIView.CornerRadius
    /// Sets property value on UIViews and subclasses
    typealias cornerRadiusRatio = Stylish.PropertyStylers.UIView.CornerRadiusRatio
    /// Sets property value on UIViews and subclasses
    typealias isUserInteractionEnabled = Stylish.PropertyStylers.UIView.IsUserInteractionEnabled
    /// Sets property value on UIViews and subclasses
    typealias isHidden = Stylish.PropertyStylers.UIView.IsHidden
    /// Sets property value on UIViews and subclasses
    typealias borderColor = Stylish.PropertyStylers.UIView.BorderColor
    /// Sets property value on UIViews and subclasses
    typealias borderWidth = Stylish.PropertyStylers.UIView.BorderWidth
    /// Sets property value on UIViews and subclasses
    typealias alpha = Stylish.PropertyStylers.UIView.Alpha
    /// Sets property value on UIViews and subclasses
    typealias clipsToBounds = Stylish.PropertyStylers.UIView.ClipsToBounds
    /// Sets property value on UIViews and subclasses
    typealias masksToBounds = Stylish.PropertyStylers.UIView.MasksToBounds
    /// Sets property value on UIViews and subclasses
    typealias tintColor = Stylish.PropertyStylers.UIView.TintColor
    /// Sets property value on UIViews and subclasses
    typealias layoutMargins = Stylish.PropertyStylers.UIView.LayoutMargins
    /// Sets property value on UIViews and subclasses
    typealias shadowColor = Stylish.PropertyStylers.UIView.ShadowColor
    /// Sets property value on UIViews and subclasses
    typealias shadowOffset = Stylish.PropertyStylers.UIView.ShadowOffset
    /// Sets property value on UIViews and subclasses
    typealias shadowRadius = Stylish.PropertyStylers.UIView.ShadowRadius
    /// Sets property value on UIViews and subclasses
    typealias shadowOpacity = Stylish.PropertyStylers.UIView.ShadowOpacity
    /// Sets property value on UIControle and subclasses
    typealias isEnabled = Stylish.PropertyStylers.UIControl.IsEnabled
    /// Sets property value on UILabels, UITextFields, UITextViews, and their subclasses
    typealias adjustsFontSizeToFitWidth = Stylish.PropertyStylers.StylishTextControl.AdjustsFontSizeToFitWidth
    /// Sets property value on UILabels, UITextFields, UITextViews, and their subclasses
    @available(iOS 10.0, *) typealias adjustsFontForContentSizeCategory = Stylish.PropertyStylers.StylishTextControl.AdjustsFontForContentSizeCategory
    /// Sets property value on UILabels, UITextFields, UITextViews, and their subclasses
    typealias textAlignment = Stylish.PropertyStylers.StylishTextControl.TextAlignment
    /// Sets property value on UILabels, UITextFields, UITextViews, and their subclasses
    typealias text = Stylish.PropertyStylers.StylishTextControl.Text
    /// Sets property value on UILabels, UITextFields, UITextViews, and their subclasses
    typealias textColor = Stylish.PropertyStylers.StylishTextControl.TextColor
    /// Sets property value on UILabels, UITextFields, UITextViews, and their subclasses. Also sets titleLabel font on UIButtons and subclasses
    typealias font = Stylish.PropertyStylers.StylishTextControl.Font
    /// Sets property value on UILabels, UITextFields, UITextViews, and their subclasses
    typealias isHighlighted = Stylish.PropertyStylers.StylishTextControl.IsHighlighted
    /// Sets property value on UILabels and subclasses
    typealias baselineAdjustment = Stylish.PropertyStylers.UILabel.BaselineAdjustment
    /// Sets property value on UILabels and subclasses
    typealias allowsDefaultTighteningForTruncation = Stylish.PropertyStylers.UILabel.AllowsDefaultTighteningForTruncation
    /// Sets property value on UILabels and subclasses
    typealias lineBreakMode = Stylish.PropertyStylers.UILabel.LineBreakMode
    /// Sets property value on UILabels and subclasses
    typealias numberOfLines = Stylish.PropertyStylers.UILabel.NumberOfLines
    /// Sets property value on UILabels and subclasses
    typealias minimumScaleFactor = Stylish.PropertyStylers.UILabel.MinimumScaleFactor
    /// Sets property value on UILabels and subclasses
    typealias preferredMaxLayoutWidth = Stylish.PropertyStylers.UILabel.PreferredMaxLayoutWidth
    /// Sets property value on UILabels and subclasses
    typealias highlightedTextColor = Stylish.PropertyStylers.UILabel.HighlightedTextColor
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias allowsEditingTextAttributes = Stylish.PropertyStylers.StylishTextInputControl.AllowsEditingTextAttributes
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias autocapitalizationType = Stylish.PropertyStylers.StylishTextInputControl.AutocapitalizationType
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias autocorrectionType = Stylish.PropertyStylers.StylishTextInputControl.AutocorrectionType
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias enablesReturnKeyAutomatically = Stylish.PropertyStylers.StylishTextInputControl.EnablesReturnKeyAutomatically
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias clearsOnInsertion = Stylish.PropertyStylers.StylishTextInputControl.ClearsOnInsertion
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias keyboardAppearance = Stylish.PropertyStylers.StylishTextInputControl.KeyboardAppearance
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias spellCheckingType = Stylish.PropertyStylers.StylishTextInputControl.SpellCheckingType
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    @available(iOS 11.0, *) typealias smartDashesType = Stylish.PropertyStylers.StylishTextInputControl.SmartDashesType
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    @available(iOS 11.0, *) typealias smartInsertDeleteType = Stylish.PropertyStylers.StylishTextInputControl.SmartInsertDeleteType
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    @available(iOS 11.0, *) typealias smartQuotesType = Stylish.PropertyStylers.StylishTextInputControl.SmartQuotesType
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias keyboardType = Stylish.PropertyStylers.StylishTextInputControl.KeyboardType
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias returnKeyType = Stylish.PropertyStylers.StylishTextInputControl.ReturnKeyType
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    typealias isSecureTextEntry = Stylish.PropertyStylers.StylishTextInputControl.IsSecureTextEntry
    /// Sets property value on UITextFields, UITextViews, and their subclasses
    @available(iOS 10.0, *) typealias textContentType = Stylish.PropertyStylers.StylishTextInputControl.TextContentType
    /// Sets property value on UITextFields and subclasses
    typealias background = Stylish.PropertyStylers.UITextField.Background
    /// Sets property value on UITextFields and subclasses
    typealias backgroundImageName = Stylish.PropertyStylers.UITextField.BackgroundImageName
    /// Sets property value on UITextFields and subclasses
    typealias disabledBackground = Stylish.PropertyStylers.UITextField.DisabledBackground
    /// Sets property value on UITextFields and subclasses
    typealias disabledBackgroundImageName = Stylish.PropertyStylers.UITextField.DisabledBackgroundImageName
    /// Sets property value on UITextFields and subclasses
    typealias borderStyle = Stylish.PropertyStylers.UITextField.BorderStyle
    /// Sets property value on UITextFields and subclasses
    /// Sets property value on UITextFields and subclasses
    typealias clearButtonMode = Stylish.PropertyStylers.UITextField.ClearButtonMode
    /// Sets property value on UITextFields and subclasses
    typealias leftViewMode = Stylish.PropertyStylers.UITextField.LeftViewMode
    /// Sets property value on UITextFields and subclasses
    typealias rightViewMode = Stylish.PropertyStylers.UITextField.RightViewMode
    /// Sets property value on UITextFields and subclasses
    typealias minimumFontSize = Stylish.PropertyStylers.UITextField.MinimumFontSize
    /// Sets property value on UITextFields and subclasses
    typealias placeholder = Stylish.PropertyStylers.UITextField.Placeholder
    /// Sets property value on UITextFields and subclasses
    typealias clearsOnBeginEditing = Stylish.PropertyStylers.UITextField.ClearsOnBeginEditing
    /// Sets property value on UITextViews and subclasses
    typealias isEditable = Stylish.PropertyStylers.UITextView.IsEditable
    /// Sets property value on UITextViews and subclasses
    typealias isSelectable = Stylish.PropertyStylers.UITextView.IsSelectable
    /// Sets property value on UITextViews and subclasses
    typealias dataDetectorTypes = Stylish.PropertyStylers.UITextView.DataDetectorTypes
    /// Sets property value on UITextViews and subclasses
    typealias textContainerInset = Stylish.PropertyStylers.UITextView.TextContainerInset
    /// Sets property value on UIButtons and subclasses
    typealias adjustsImageWhenDisabled = Stylish.PropertyStylers.UIButton.AdjustsImageWhenDisabled
    /// Sets property value on UIButtons and subclasses
    typealias adjustsImageWhenHighlighted = Stylish.PropertyStylers.UIButton.AdjustsImageWhenHighlighted
    /// Sets property value on UIButtons and subclasses
    typealias showsTouchWhenHighlighted = Stylish.PropertyStylers.UIButton.ShowsTouchWhenHighlighted
    /// Sets property value on UIButtons and subclasses
    typealias contentEdgeInsets = Stylish.PropertyStylers.UIButton.ContentEdgeInsets
    /// Sets property value on UIButtons and subclasses
    /// Sets property value on UIButtons and subclasses
    typealias titleEdgeInsets = Stylish.PropertyStylers.UIButton.TitleEdgeInsets
    /// Sets property value on UIButtons and subclasses
    typealias imageEdgeInsets = Stylish.PropertyStylers.UIButton.ImageEdgeInsets
    /// Sets property value on UIButtons and subclasses
    typealias titleForNormalState = Stylish.PropertyStylers.UIButton.TitleForNormalState
    /// Sets property value on UIButtons and subclasses
    typealias titleForHighlightedState = Stylish.PropertyStylers.UIButton.TitleForHighlightedState
    /// Sets property value on UIButtons and subclasses
    typealias titleForDisabledState = Stylish.PropertyStylers.UIButton.TitleForDisabledState
    /// Sets property value on UIButtons and subclasses
    typealias titleColorForNormalState = Stylish.PropertyStylers.UIButton.TitleColorForNormalState
    /// Sets property value on UIButtons and subclasses
    typealias titleColorForHighlightedState = Stylish.PropertyStylers.UIButton.TitleColorForHighlightedState
    /// Sets property value on UIButtons and subclasses
    typealias titleColorForDisabledState = Stylish.PropertyStylers.UIButton.TitleColorForDisabledState
    /// Sets property value on UIButtons and subclasses
    typealias imageForNormalState = Stylish.PropertyStylers.UIButton.ImageForNormalState
    /// Sets property value on UIButtons and subclasses
    typealias imageNameForNormalState = Stylish.PropertyStylers.UIButton.ImageNameForNormalState
    /// Sets property value on UIButtons and subclasses
    typealias imageForHighlightedState = Stylish.PropertyStylers.UIButton.ImageForHighlightedState
    /// Sets property value on UIButtons and subclasses
    typealias imageNameForHighlightedState = Stylish.PropertyStylers.UIButton.ImageNameForHighlightedState
    /// Sets property value on UIButtons and subclasses
    typealias imageForDisabledState = Stylish.PropertyStylers.UIButton.ImageForDisabledState
    /// Sets property value on UIButtons and subclasses
    typealias imageNameForDisabledState = Stylish.PropertyStylers.UIButton.ImageNameForDisabledState
    /// Sets property value on UIButtons and subclasses
    typealias backgroundImageForNormalState = Stylish.PropertyStylers.UIButton.BackgroundImageForNormalState
    /// Sets property value on UIButtons and subclasses
    typealias backgroundImageNameForNormalState = Stylish.PropertyStylers.UIButton.BackgroundImageNameForNormalState
    /// Sets property value on UIButtons and subclasses
    typealias backgroundImageForHighlightedState = Stylish.PropertyStylers.UIButton.BackgroundImageForHighlightedState
    /// Sets property value on UIButtons and subclasses
    typealias backgroundImageNameForHighlightedState = Stylish.PropertyStylers.UIButton.BackgroundImageNameForHighlightedState
    /// Sets property value on UIButtons and subclasses
    typealias backgroundImageForDisabledState = Stylish.PropertyStylers.UIButton.BackgroundImageForDisabledState
    /// Sets property value on UIButtons and subclasses
    typealias backgroundImageNameForDisabledState = Stylish.PropertyStylers.UIButton.BackgroundImageNameForDisabledState
    /// Sets property value on UIImageViews and subclasses
    typealias image = Stylish.PropertyStylers.UIImageView.Image
    /// Sets property value on UIImageViews and subclasses
    typealias imageName = Stylish.PropertyStylers.UIImageView.ImageName
    /// Specifies a URL to asynchronously download an image from, and then set as the UIImageView's image property
    typealias imageURL = Stylish.PropertyStylers.UIImageView.ImageURL
    /// Sets property value on UIImageViews and subclasses
    typealias highlightedImage = Stylish.PropertyStylers.UIImageView.HighlightedImage
    /// Sets property value on UIImageViews and subclasses
    typealias highlightedImageName = Stylish.PropertyStylers.UIImageView.HighlightedImageName
    /// Sets property value on UIImageViews and subclasses
    @available(iOS 11.0, *) typealias adjustsImageSizeForAccessibilityContentSizeCategory = Stylish.PropertyStylers.UIImageView.AdjustsImageSizeForAccessibilityContentSizeCategory
    /// Sets property value on UIImageViews and subclasses
    typealias animationDuration = Stylish.PropertyStylers.UIImageView.AnimationDuration
    /// Sets property value on UIImageViews and subclasses
    typealias animationRepeatCount = Stylish.PropertyStylers.UIImageView.AnimationRepeatCount
    /// Sets property value on UIImageViews and subclasses
    typealias animationImages = Stylish.PropertyStylers.UIImageView.AnimationImages
    /// Sets property value on UIImageViews and subclasses
    typealias animationImageNames = Stylish.PropertyStylers.UIImageView.AnimationImageNames
    /// Sets property value on UIImageViews and subclasses
    typealias highlightedAnimationImages = Stylish.PropertyStylers.UIImageView.HighlightedAnimationImages
    /// Sets property value on UIImageViews and subclasses
    typealias highlightedAnimationImageNames = Stylish.PropertyStylers.UIImageView.HighlightedAnimationImageNames
    /// When true, calls startAnimating() on target UIImageView, calls stopAnimating() when false
    typealias isAnimating = Stylish.PropertyStylers.UIImageView.IsAnimating
}


public extension Stylish {
    enum PropertyStylers {}
}

public extension Stylish.PropertyStylers {
    
    class UIView {
        
        public struct BackgroundColor: PropertyStyler {
            public static var propertyKey: String { return "backgroundColor" }
            public static func apply(value: UIColor?, to target: UIKit.UIView, using bundle: Bundle) {
                target.backgroundColor = value
            }
        }
        
        public struct ContentMode: PropertyStyler {
            public static var propertyKey: String { return "contentMode" }
            public static func apply(value: UIKit.UIView.ContentMode?, to target: UIKit.UIView, using bundle: Bundle) {
                target.contentMode = value ?? .scaleToFill
            }
        }
        
        public struct CornerRadius: PropertyStyler {
            public static var propertyKey: String { return "cornerRadius" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView, using bundle: Bundle) {
                target.layer.cornerRadius = value ?? 0
            }
        }
        
        public struct CornerRadiusRatio: PropertyStyler {
            public static var propertyKey: String { return "cornerRadiusRatio" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView, using bundle: Bundle) {
                target.layer.cornerRadius = (target.bounds.height * ( value ?? 0))
            }
        }
        
        public struct IsUserInteractionEnabled: PropertyStyler {
            public static var propertyKey: String { return "isUserInteractionEnabled" }
            public static func apply(value: Bool?, to target: UIKit.UIView, using bundle: Bundle) {
                target.isUserInteractionEnabled = value ?? true
            }
        }
        
        public struct IsHidden: PropertyStyler {
            public static var propertyKey: String { return "isHidden" }
            public static func apply(value: Bool?, to target: UIKit.UIView, using bundle: Bundle) {
                target.isHidden = value ?? false
            }
        }
        
        public struct BorderColor: PropertyStyler {
            public static var propertyKey: String { return "borderColor" }
            public static func apply(value: UIColor?, to target: UIKit.UIView, using bundle: Bundle) {
                target.layer.borderColor = value?.cgColor
            }
        }
        
        public struct BorderWidth: PropertyStyler {
            public static var propertyKey: String { return "borderWidth" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView, using bundle: Bundle) {
                target.layer.borderWidth = value ?? 0
            }
        }
        
        public struct Alpha: PropertyStyler {
            public static var propertyKey: String { return "alpha" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView, using bundle: Bundle) {
                target.alpha = value ?? 1.0
            }
        }
        
        public struct ClipsToBounds: PropertyStyler {
            public static var propertyKey: String { return "clipsToBounds" }
            public static func apply(value: Bool?, to target: UIKit.UIView, using bundle: Bundle) {
                target.clipsToBounds = value ?? false
            }
        }
        
        public struct MasksToBounds: PropertyStyler {
            public static var propertyKey: String { return "masksToBounds" }
            public static func apply(value: Bool?, to target: UIKit.UIView, using bundle: Bundle) {
                target.layer.masksToBounds = value ?? false
            }
        }
        
        public struct TintColor: PropertyStyler {
            public static var propertyKey: String { return "tintColor" }
            public static func apply(value: UIColor?, to target: UIKit.UIView, using bundle: Bundle) {
                target.tintColor = value
            }
        }
        
        public struct LayoutMargins: PropertyStyler {
            public static var propertyKey: String { return "layoutMargins" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UIView, using bundle: Bundle) {
                target.layoutMargins = value ?? UIKit.UIView().layoutMargins
            }
        }
        
        public struct ShadowColor: PropertyStyler {
            public static var propertyKey: String { return "shadowColor" }
            public static func apply(value: UIColor?, to target: UIKit.UIView, using bundle: Bundle) {
                if let label = target as? UIKit.UILabel {
                    label.shadowColor = value
                } else {
                    target.layer.shadowColor = value?.cgColor
                }
            }
        }
        
        public struct ShadowOffset: PropertyStyler {
            public static var propertyKey: String { return "shadowOffset" }
            public static func apply(value: CGSize?, to target: UIKit.UIView, using bundle: Bundle) {
                if let label = target as? UIKit.UILabel {
                    label.shadowOffset = value ?? .zero
                } else {
                    target.layer.shadowOffset = value ?? .zero
                }
            }
        }
        
        public struct ShadowRadius: PropertyStyler {
            public static var propertyKey: String { return "shadowRadius" }
            public static func apply(value: CGFloat?, to target: UIKit.UIView, using bundle: Bundle) {
                target.layer.shadowRadius = value ?? 0
            }
        }
        
        public struct ShadowOpacity: PropertyStyler {
            public static var propertyKey: String { return "shadowOpacity" }
            public static func apply(value: Float?, to target: UIKit.UIView, using bundle: Bundle) {
                target.layer.shadowOpacity = value ?? 0
            }
        }
    }
    
    class UIControl: UIView {
        
        public struct IsEnabled: PropertyStyler {
            public static var propertyKey: String { return "isEnabled" }
            public static func apply(value: Bool?, to target: UIKit.UIControl, using bundle: Bundle) {
                target.isEnabled = value ?? true
            }
        }
    }
    
    class StylishTextControl: UIControl {
        
        public struct AdjustsFontSizeToFitWidth: PropertyStyler {
            public static var propertyKey: String { return "adjustsFontSizeToFitWidth" }
            public static func apply(value: Bool?, to target: TextControl, using bundle: Bundle) {
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
            public static func apply(value: Bool?, to target: TextControl, using bundle: Bundle) {
                target.adjustsFontForContentSizeCategory = value ?? false
            }
        }
        
        public struct TextAlignment: PropertyStyler {
            public static var propertyKey: String { return "textAlignment" }
            public static func apply(value: NSTextAlignment?, to target: TextControl, using bundle: Bundle) {
                target.textAlignment = value ?? .left
            }
        }
        
        public struct Text: PropertyStyler {
            public static var propertyKey: String { return "text" }
            public static func apply(value: String?, to target: TextControl, using bundle: Bundle) {
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
            public static func apply(value: UIColor?, to target: TextControl, using bundle: Bundle) {
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
            public static func apply(value: UIFont?, to target: UIKit.UIView, using bundle: Bundle) {
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
            public static func apply(value: Bool?, to target: TextControl, using bundle: Bundle) {
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
    
    class UILabel: StylishTextControl {
        
        public struct BaselineAdjustment: PropertyStyler {
            public static var propertyKey: String { return "baselineAdjustment" }
            public static func apply(value: UIBaselineAdjustment?, to target: UIKit.UILabel, using bundle: Bundle) {
                target.baselineAdjustment = value ?? .alignBaselines
            }
        }
        
        public struct AllowsDefaultTighteningForTruncation: PropertyStyler {
            public static var propertyKey: String { return "allowsDefaultTighteningForTruncation" }
            public static func apply(value: Bool?, to target: UIKit.UILabel, using bundle: Bundle) {
                target.allowsDefaultTighteningForTruncation = value ?? false
            }
        }
        
        public struct LineBreakMode: PropertyStyler {
            public static var propertyKey: String { return "lineBreakMode" }
            public static func apply(value: NSLineBreakMode?, to target: UIKit.UILabel, using bundle: Bundle) {
                target.lineBreakMode = value ?? .byTruncatingTail
            }
        }
        
        public struct NumberOfLines: PropertyStyler {
            public static var propertyKey: String { return "numberOfLines" }
            public static func apply(value: Int?, to target: UIKit.UILabel, using bundle: Bundle) {
                target.numberOfLines = value ?? 1
            }
        }
        
        public struct MinimumScaleFactor: PropertyStyler {
            public static var propertyKey: String { return "minimumScaleFactor" }
            public static func apply(value: CGFloat?, to target: UIKit.UILabel, using bundle: Bundle) {
                target.minimumScaleFactor = value ?? 0.0
            }
        }
        
        public struct PreferredMaxLayoutWidth: PropertyStyler {
            public static var propertyKey: String { return "preferredMaxLayoutWidth" }
            public static func apply(value: CGFloat?, to target: UIKit.UILabel, using bundle: Bundle) {
                target.minimumScaleFactor = value ?? 0.0
            }
        }
        
        public struct HighlightedTextColor: PropertyStyler {
            public static var propertyKey: String { return "highlightedTextColor" }
            public static func apply(value: UIColor?, to target: UIKit.UILabel, using bundle: Bundle) {
                target.highlightedTextColor = value
            }
        }
    }
    
    class StylishTextInputControl: StylishTextControl {
        
        public struct AllowsEditingTextAttributes: PropertyStyler {
            public static var propertyKey: String { return "allowsEditingTextAttributes" }
            public static func apply(value: Bool?, to target: TextInputControl, using bundle: Bundle) {
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
            public static func apply(value: UITextAutocapitalizationType?, to target: TextInputControl, using bundle: Bundle) {
                target.autocapitalizationType = value ?? .sentences
            }
        }
        
        public struct AutocorrectionType: PropertyStyler {
            public static var propertyKey: String { return "autocorrectionType" }
            public static func apply(value: UITextAutocorrectionType?, to target: TextInputControl, using bundle: Bundle) {
                target.autocorrectionType = value ?? .default
            }
        }
        
        public struct EnablesReturnKeyAutomatically: PropertyStyler {
            public static var propertyKey: String { return "enablesReturnKeyAutomatically" }
            public static func apply(value: Bool?, to target: TextInputControl, using bundle: Bundle) {
                target.enablesReturnKeyAutomatically = value ?? false
            }
        }
        
        public struct ClearsOnInsertion: PropertyStyler {
            public static var propertyKey: String { return "clearsOnInsertion" }
            public static func apply(value: Bool?, to target: TextInputControl, using bundle: Bundle) {
                target.clearsOnInsertion = value ?? false
            }
        }
        
        public struct KeyboardAppearance: PropertyStyler {
            public static var propertyKey: String { return "keyboardAppearance" }
            public static func apply(value: UIKeyboardAppearance?, to target: TextInputControl, using bundle: Bundle) {
                target.keyboardAppearance = value ?? .default
            }
        }
        
        public struct SpellCheckingType: PropertyStyler {
            public static var propertyKey: String { return "spellCheckingType" }
            public static func apply(value: UITextSpellCheckingType?, to target: TextInputControl, using bundle: Bundle) {
                target.spellCheckingType = value ?? .default
            }
        }
        
        @available(iOS 11.0, *)
        public struct SmartDashesType: PropertyStyler {
            public static var propertyKey: String { return "smartDashesType" }
            public static func apply(value: UITextSmartDashesType?, to target: TextInputControl, using bundle: Bundle) {
                target.smartDashesType = value ?? .default
            }
        }
        
        @available(iOS 11.0, *)
        public struct SmartInsertDeleteType: PropertyStyler {
            public static var propertyKey: String { return "smartInsertDeleteType" }
            public static func apply(value: UITextSmartInsertDeleteType?, to target: TextInputControl, using bundle: Bundle) {
                target.smartInsertDeleteType = value ?? .default
            }
        }
        
        @available(iOS 11.0, *)
        public struct SmartQuotesType: PropertyStyler {
            public static var propertyKey: String { return "smartQuotesType" }
            public static func apply(value: UITextSmartQuotesType?, to target: TextInputControl, using bundle: Bundle) {
                target.smartQuotesType = value ?? .default
            }
        }
        
        public struct KeyboardType: PropertyStyler {
            public static var propertyKey: String { return "keyboardType" }
            public static func apply(value: UIKeyboardType?, to target: TextInputControl, using bundle: Bundle) {
                target.keyboardType = value ?? .default
            }
        }
        
        public struct ReturnKeyType: PropertyStyler {
            public static var propertyKey: String { return "returnKeyType" }
            public static func apply(value: UIReturnKeyType?, to target: TextInputControl, using bundle: Bundle) {
                target.returnKeyType = value ?? .default
            }
        }
        
        public struct IsSecureTextEntry: PropertyStyler {
            public static var propertyKey: String { return "isSecureTextEntry" }
            public static func apply(value: Bool?, to target: TextInputControl, using bundle: Bundle) {
                target.isSecureTextEntry = value ?? false
            }
        }
        
        @available(iOS 10.0, *)
        public struct TextContentType: PropertyStyler {
            public static var propertyKey: String { return "textContentType" }
            public static func apply(value: UITextContentType?, to target: TextInputControl, using bundle: Bundle) {
                target.textContentType = value
            }
        }
    }
    
    class UITextField: StylishTextInputControl {
        
        public struct Background: PropertyStyler {
            public static var propertyKey: String { return "background" }
            public static func apply(value: UIImage?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.background = value
            }
        }
        
        public struct BackgroundImageName: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageName" }
            public static func apply(value: String?, to target: UIKit.UITextField, using bundle: Bundle) {
                if let name = value {
                    target.background = UIImage(named: name, in: bundle, compatibleWith: target.traitCollection)
                }
            }
        }
        
        public struct DisabledBackground: PropertyStyler {
            public static var propertyKey: String { return "disabledBackground" }
            public static func apply(value: UIImage?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.disabledBackground = value
            }
        }
        
        public struct DisabledBackgroundImageName: PropertyStyler {
            public static var propertyKey: String { return "disabledBackgroundImageName" }
            public static func apply(value: String?, to target: UIKit.UITextField, using bundle: Bundle) {
                if let name = value {
                    target.disabledBackground = UIImage(named: name, in: bundle, compatibleWith: target.traitCollection)
                }
            }
        }
        
        public struct BorderStyle: PropertyStyler {
            public static var propertyKey: String { return "borderStyle" }
            public static func apply(value: UIKit.UITextField.BorderStyle?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.borderStyle = value ?? .none
            }
        }
        
        public struct ClearButtonMode: PropertyStyler {
            public static var propertyKey: String { return "clearButtonMode" }
            public static func apply(value: UIKit.UITextField.ViewMode?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.clearButtonMode = value ?? .never
            }
        }
        
        public struct LeftViewMode: PropertyStyler {
            public static var propertyKey: String { return "leftViewMode" }
            public static func apply(value: UIKit.UITextField.ViewMode?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.leftViewMode = value ?? .never
            }
        }
        
        public struct RightViewMode: PropertyStyler {
            public static var propertyKey: String { return "rightViewMode" }
            public static func apply(value: UIKit.UITextField.ViewMode?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.rightViewMode = value ?? .never
            }
        }
        
        public struct MinimumFontSize: PropertyStyler {
            public static var propertyKey: String { return "minimumFontSize" }
            public static func apply(value: CGFloat?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.minimumFontSize = value ?? 0.0
            }
        }
        
        public struct Placeholder: PropertyStyler {
            public static var propertyKey: String { return "placeholder" }
            public static func apply(value: String?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.placeholder = value
            }
        }
        
        public struct ClearsOnBeginEditing: PropertyStyler {
            public static var propertyKey: String { return "clearsOnBeginEditing" }
            public static func apply(value: Bool?, to target: UIKit.UITextField, using bundle: Bundle) {
                target.clearsOnBeginEditing = value ?? false
            }
        }
    }
    
    class UITextView: StylishTextInputControl {
        
        public struct IsEditable: PropertyStyler {
            public static var propertyKey: String { return "isEditable" }
            public static func apply(value: Bool?, to target: UIKit.UITextView, using bundle: Bundle) {
                target.isEditable = value ?? false
            }
        }
        
        public struct IsSelectable: PropertyStyler {
            public static var propertyKey: String { return "isSelectable" }
            public static func apply(value: Bool?, to target: UIKit.UITextView, using bundle: Bundle) {
                target.isSelectable = value ?? false
            }
        }
        
        public struct DataDetectorTypes: PropertyStyler {
            public static var propertyKey: String { return "dataDetectorTypes" }
            public static func apply(value: UIDataDetectorTypes?, to target: UIKit.UITextView, using bundle: Bundle) {
                target.dataDetectorTypes = value ?? []
            }
        }
        
        public struct TextContainerInset: PropertyStyler {
            public static var propertyKey: String { return "textContainerInset" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UITextView, using bundle: Bundle) {
                target.textContainerInset = value ?? UIKit.UITextView().textContainerInset
            }
        }
    }
    
    class UIButton: UIControl {
        
        public struct AdjustsImageWhenDisabled: PropertyStyler {
            public static var propertyKey: String { return "adjustsImageWhenDisabled" }
            public static func apply(value: Bool?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.adjustsImageWhenDisabled = value ?? true
            }
        }
        
        public struct AdjustsImageWhenHighlighted: PropertyStyler {
            public static var propertyKey: String { return "adjustsImageWhenHighlighted" }
            public static func apply(value: Bool?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.adjustsImageWhenHighlighted = value ?? true
            }
        }
        
        public struct ShowsTouchWhenHighlighted: PropertyStyler {
            public static var propertyKey: String { return "showsTouchWhenHighlighted" }
            public static func apply(value: Bool?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.showsTouchWhenHighlighted = value ?? false
            }
        }
        
        public struct ContentEdgeInsets: PropertyStyler {
            public static var propertyKey: String { return "contentEdgeInsets" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.contentEdgeInsets = value ?? UIKit.UIButton().contentEdgeInsets
            }
        }
        
        public struct TitleEdgeInsets: PropertyStyler {
            public static var propertyKey: String { return "titleEdgeInsets" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.titleEdgeInsets = value ?? UIKit.UIButton().titleEdgeInsets
            }
        }
        
        public struct ImageEdgeInsets: PropertyStyler {
            public static var propertyKey: String { return "imageEdgeInsets" }
            public static func apply(value: UIEdgeInsets?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.imageEdgeInsets = value ?? UIKit.UIButton().imageEdgeInsets
            }
        }
        
        public struct TitleForNormalState: PropertyStyler {
            public static var propertyKey: String { return "titleForNormalState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setTitle(value, for: .normal)
            }
        }
        
        public struct TitleForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "titleForHighlightedState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setTitle(value, for: .highlighted)
            }
        }
        
        public struct TitleForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "titleForDisabledState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setTitle(value, for: .disabled)
            }
        }
        
        public struct TitleColorForNormalState: PropertyStyler {
            public static var propertyKey: String { return "titleColorForNormalState" }
            public static func apply(value: UIColor?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setTitleColor(value, for: .normal)
            }
        }
        
        public struct TitleColorForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "titleColorForHighlightedState" }
            public static func apply(value: UIColor?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setTitleColor(value, for: .highlighted)
            }
        }
        
        public struct TitleColorForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "titleColorForDisabledState" }
            public static func apply(value: UIColor?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setTitleColor(value, for: .disabled)
            }
        }
        
        public struct ImageForNormalState: PropertyStyler {
            public static var propertyKey: String { return "imageForNormalState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setImage(value, for: .normal)
            }
        }
        
        public struct ImageNameForNormalState: PropertyStyler {
            public static var propertyKey: String { return "imageNameForNormalState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                if let name = value {
                    target.setImage(UIImage(named: name, in: bundle, compatibleWith: target.traitCollection), for: .normal)
                }
            }
        }
        
        public struct ImageForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "imageForHighlightedState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setImage(value, for: .highlighted)
            }
        }
        
        public struct ImageNameForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "imageNameForHighlightedState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                if let name = value {
                    target.setImage(UIImage(named: name, in: bundle, compatibleWith: target.traitCollection), for: .highlighted)
                }
            }
        }
        
        public struct ImageForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "imageForDisabledState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setImage(value, for: .disabled)
            }
        }
        
        public struct ImageNameForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "imageNameForDisabledState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                if let name = value {
                    target.setImage(UIImage(named: name, in: bundle, compatibleWith: target.traitCollection), for: .disabled)
                }
            }
        }
        
        public struct BackgroundImageForNormalState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageForNormalState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setBackgroundImage(value, for: .normal)
            }
        }
        
        public struct BackgroundImageNameForNormalState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageNameForNormalState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                if let name = value {
                    target.setBackgroundImage(UIImage(named: name, in: bundle, compatibleWith: target.traitCollection), for: .normal)
                }
            }
        }
        
        public struct BackgroundImageForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageForHighlightedState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setBackgroundImage(value, for: .highlighted)
            }
        }
        
        public struct BackgroundImageNameForHighlightedState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageNameForHighlightedState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                if let name = value {
                    target.setBackgroundImage(UIImage(named: name, in: bundle, compatibleWith: target.traitCollection), for: .highlighted)
                }
            }
        }
        
        public struct BackgroundImageForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageForDisabledState" }
            public static func apply(value: UIImage?, to target: UIKit.UIButton, using bundle: Bundle) {
                target.setBackgroundImage(value, for: .disabled)
            }
        }
        
        public struct BackgroundImageNameForDisabledState: PropertyStyler {
            public static var propertyKey: String { return "backgroundImageNameForDisabledState" }
            public static func apply(value: String?, to target: UIKit.UIButton, using bundle: Bundle) {
                if let name = value {
                    target.setBackgroundImage(UIImage(named: name, in: bundle, compatibleWith: target.traitCollection), for: .disabled)
                }
            }
        }
    }
    
    class UIImageView: UIView {
        
        public struct Image: PropertyStyler {
            public static var propertyKey: String { return "image" }
            public static func apply(value: UIImage?, to target: UIKit.UIImageView, using bundle: Bundle) {
                target.image = value
            }
        }
        
        public struct ImageName: PropertyStyler {
            public static var propertyKey: String { return "imageName" }
            public static func apply(value: String?, to target: UIKit.UIImageView, using bundle: Bundle) {
                if let name = value {
                    target.image = UIImage(named: name, in: bundle, compatibleWith: target.traitCollection)
                }
            }
        }
        
        public struct ImageURL: PropertyStyler {
            public static var propertyKey: String { return "imageURL" }
            public static func apply(value: URL?, to target: UIKit.UIImageView, using bundle: Bundle) {
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
            public static func apply(value: UIImage?, to target: UIKit.UIImageView, using bundle: Bundle) {
                target.highlightedImage = value
            }
        }
        
        public struct HighlightedImageName: PropertyStyler {
            public static var propertyKey: String { return "highlightedImageName" }
            public static func apply(value: String?, to target: UIKit.UIImageView, using bundle: Bundle) {
                if let name = value {
                    target.highlightedImage = UIImage(named: name, in: bundle, compatibleWith: target.traitCollection)
                }
            }
        }
        
        @available(iOS 11.0, *)
        public struct AdjustsImageSizeForAccessibilityContentSizeCategory: PropertyStyler {
            public static var propertyKey: String { return "adjustsImageSizeForAccessibilityContentSizeCategory" }
            public static func apply(value: Bool?, to target: UIKit.UIImageView, using bundle: Bundle) {
                target.adjustsImageSizeForAccessibilityContentSizeCategory = value ?? false
            }
        }
        
        public struct AnimationDuration: PropertyStyler {
            public static var propertyKey: String { return "animationDuration" }
            public static func apply(value: Double?, to target: UIKit.UIImageView, using bundle: Bundle) {
                target.animationDuration = value ?? Double((target.animationImages ?? []).count) * 0.0333333
            }
        }
        
        public struct AnimationRepeatCount: PropertyStyler {
            public static var propertyKey: String { return "animationRepeatCount" }
            public static func apply(value: Int?, to target: UIKit.UIImageView, using bundle: Bundle) {
                target.animationRepeatCount = value ?? 0
            }
        }
        
        public struct AnimationImages: PropertyStyler {
            public static var propertyKey: String { return "animationImages" }
            public static func apply(value: UIImageArray?, to target: UIKit.UIImageView, using bundle: Bundle) {
                target.animationImages = value?.images
            }
        }
        
        public struct AnimationImageNames: PropertyStyler {
            public static var propertyKey: String { return "animationImageNames" }
            public static func apply(value: StringArray?, to target: UIKit.UIImageView, using bundle: Bundle) {
                if let names = value?.strings {
                    target.animationImages = names.compactMap{ UIImage(named: $0, in: bundle, compatibleWith: target.traitCollection) }
                }
            }
        }
        
        public struct HighlightedAnimationImages: PropertyStyler {
            public static var propertyKey: String { return "highlightedAnimationImages" }
            public static func apply(value: UIImageArray?, to target: UIKit.UIImageView, using bundle: Bundle) {
                target.highlightedAnimationImages = value?.images
            }
        }
        
        public struct HighlightedAnimationImageNames: PropertyStyler {
            public static var propertyKey: String { return "highlightedAnimationImageNames" }
            public static func apply(value: StringArray?, to target: UIKit.UIImageView, using bundle: Bundle) {
                if let names = value?.strings {
                    target.highlightedAnimationImages = names.compactMap{ UIImage(named: $0, in: bundle, compatibleWith: target.traitCollection) }
                }
            }
        }
        
        public struct IsAnimating: PropertyStyler {
            public static var propertyKey: String { return "isAnimating" }
            public static func apply(value: Bool?, to target: UIKit.UIImageView, using bundle: Bundle) {
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
    public static func apply(value: UIColor?, to target: Styleable, using bundle: Bundle) {
        if let target = target as? UIView, let value = value {
            target.viewWithTag(tag)?.removeFromSuperview()
            let context = CIContext()
            let stripesFilter = CIFilter(name: "CIStripesGenerator", parameters: ["inputColor0" : CIColor(color: value.withAlphaComponent(0.4)), "inputColor1" : CIColor(color: value.withAlphaComponent(0.6)), "inputWidth" : 2])!
            let stripes = context.createCGImage(stripesFilter.outputImage!, from: CGRect(origin: CGPoint.zero, size: CGSize(width: 32.0, height: 32.0)))
            let rotateFilter = CIFilter(name: "CIStraightenFilter", parameters: ["inputImage" : CIImage(cgImage: stripes!), "inputAngle" : 2.35])!
            let rotated = context.createCGImage(rotateFilter.outputImage!, from: rotateFilter.outputImage!.extent)
            let stripesView = UIView()
            stripesView.backgroundColor = UIColor(patternImage: UIImage(cgImage: rotated!))
            stripesView.frame = target.bounds
            target.addSubview(stripesView)
        }
    }
}

/// MARK: - Convenience Protocols

/// A protocol to conform UILabel, UITextField and UITextView to, so they can be styled with the same Property Stylers
public protocol TextControl: class {
    var textAlignment: NSTextAlignment { get set }
    @available(iOS 10.0, *) var adjustsFontForContentSizeCategory: Bool { get set }
}

/// A protocol to conform UITextField and UITextView to, so they can be styled with the same Property Stylers
public protocol TextInputControl: TextControl {
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

