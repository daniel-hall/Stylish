//
//  StyleableUIButton.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import UIKit


public struct UIButtonPropertySet : DynamicStylePropertySet {
    public var contentEdgeInsets:UIEdgeInsets?
    public var titleEdgeInsets:UIEdgeInsets?
    public var imageEdgeInsets:UIEdgeInsets?
    public var titleFont:UIFont?
    public var titleForNormalState:String?
    public var titleForHighlightedState:String?
    public var titleForDisabledState:String?
    public var titleColorForNormalState:UIColor?
    public var titleColorForHighlightedState:UIColor?
    public var titleColorForDisabledState:UIColor?
    public var imageForNormalState:UIImage?
    public var imageForHighlightedState:UIImage?
    public var imageForDisabledState:UIImage?
    public var backgroundImageForNormalState:UIImage?
    public var backgroundImageForHighlightedState:UIImage?
    public var backgroundImageForDisabledState:UIImage?
    public var customUIButtonStyleBlock:((UIButton)->())?
    mutating public func setStyleProperty<T>(named name: String, toValue value: T) {
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
    
    public init() {}
}

public extension StyleClass {
    public var UIButton:UIButtonPropertySet { get { return self.retrieve(propertySet: UIButtonPropertySet.self) } set { self.register(propertySet: newValue) } }
}

@IBDesignable open class StyleableUIButton : UIButton, Styleable {
    
    public class var StyleApplicators: [StyleApplicator] {
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
    
    @IBInspectable public var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable public var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        parseAndApplyStyles()
        showErrorIfInvalidStyles()
    }
}
