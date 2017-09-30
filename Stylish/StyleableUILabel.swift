//
//  StyleableUILabel.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import UIKit


public struct UILabelPropertySet : DynamicStylePropertySet {
    public var textColor:UIColor?
    public var font:UIFont?
    public var enabled:Bool?
    public var textAlignment:NSTextAlignment?
    public var text:String?
    public var highlighted:Bool?
    public var highlightedTextColor:UIColor?
    public var customUILabelStyleBlock:((UILabel)->())?
    mutating public func setStyleProperty<T>(named name: String, toValue value: T) {
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
    
    public init() {}
}


public extension StyleClass {
    var UILabel:UILabelPropertySet { get { return self.retrieve(propertySet: UILabelPropertySet.self) } set { self.register(propertySet: newValue) } }
}

@IBDesignable open class StyleableUILabel : UILabel, Styleable {
    
    public class var StyleApplicators: [StyleApplicator] {
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
    
    override open func didMoveToSuperview() {
        NotificationCenter.default.addObserver(self, selector: #selector(StyleableUILabel.refreshFont), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
        super.didMoveToSuperview()
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
    
    public func refreshFont() {
        parseAndApplyStyles()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        parseAndApplyStyles()
        showErrorIfInvalidStyles()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
