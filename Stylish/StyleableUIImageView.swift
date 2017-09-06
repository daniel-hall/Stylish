//
//  StyleableUIImageView.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import UIKit

public struct UIImageViewPropertySet : DynamicStylePropertySet {
    public var image:UIImage?
    public var customUIImageViewStyleBlock:((UIImageView)->())?
    mutating public func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariant(of: "Image"):
            image = value as? UIImage
        default :
            return
        }
    }
    public init() {}
}

public extension StyleClass {
    public var UIImageView:UIImageViewPropertySet { get { return self.retrieve(propertySet: UIImageViewPropertySet.self) } set { self.register(propertySet: newValue) } }
}

@IBDesignable open class StyleableUIImageView : UIImageView, Styleable {
    
    public class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let imageView = target as? UIImageView {
                imageView.image =? style.UIImageView.image
                if let customStyleBlock = style.UIImageView.customUIImageViewStyleBlock { customStyleBlock(imageView) }
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
