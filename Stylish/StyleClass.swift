//
//  StyleClass.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import Foundation

/// A StyleClass is a collection of values that should be assigned to the specified properties of any view that the StyleClass is applied to. Analagous in concept to a CSS style or style class

public protocol StyleClass {
    /// This variable defines storage for all the values that are assigned to each property in each StylePropertySet. StylePropertySets are groupings of properties to avoid naming collisions.  For example in the expression:  styleClass.UIView.backgroundColor, "UIView" is the style property set that contains properties specifically relevant to UIViews and "backgroundColor" is a specific property.   
    var stylePropertySets:StylePropertySetCollection { get set }
}

