//
//  StyleableUIView.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import UIKit


public struct UIViewPropertySet : DynamicStylePropertySet {
    public var backgroundColor:UIColor?
    public var contentMode:UIViewContentMode?
    public var userInteractionEnabled:Bool?
    public var hidden:Bool?
    public var borderColor:CGColor?
    public var borderWidth:CGFloat?
    public var cornerRadius:CGFloat?
    public var cornerRadiusPercentage:CGFloat?
    public var masksToBounds:Bool?
    public var clipsToBounds:Bool?
    public var alpha: CGFloat?
    public var layoutMargins:UIEdgeInsets?
    public var tintColor:UIColor?
    public var customUIViewStyleBlock:((UIView)->())?
    mutating public func setStyleProperty<T>(named name: String, toValue value: T) {
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
    
    public init() {}
}

public extension StyleClass {
    public var UIView:UIViewPropertySet { get { return self.retrieve(propertySet: UIViewPropertySet.self) } set { self.register(propertySet: newValue) } }
}


@IBDesignable open class StyleableUIView : UIView, Styleable {
    
    public class var StyleApplicators:[StyleApplicator] {
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
