//
//  Stylesheet.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import Foundation


// MARK: - Stylesheet -

/// A Stylesheet is a collection of StyleClasses. Changing Stylesheets is the equivalent of re-theming the app, since the StyleClasses with the same identifier in a new Stylesheet will most likely have different values for their properties. Analagous in concept to a CSS stylesheet

public protocol Stylesheet : class {
    var styleClasses:[(identifier:String, styleClass:StyleClass)] { get }
    func style(named:String)->StyleClass?
    init()
}

public extension Stylesheet {
    
    public func style(named name: String) -> StyleClass? {
        for (identifier, styleClass) in styleClasses + Stylish.sharedStyleClasses {
            if name.isVariant(of: identifier) {
                return styleClass
            }
        }
        return nil
    }
    
    public subscript(styleName:String)->StyleClass? {
        get {
            return style(named: styleName)
        }
    }
}
