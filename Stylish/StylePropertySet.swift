//
//  StylePropertySet.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import Foundation


// MARK: - StylePropertySet -


/// A style property set is a way of organizing sets of style-enabled properties by the type of view they applu to.  For example, you may want a "tint" property on a custom class, which should not be confused with "tintColor" on a UIView.  The style property sets separate out the properties into logicial groupings, e.g. 'style.CustomView.tint' vs. 'style.UIView.tintColor'

public protocol StylePropertySet {
    init()
}


// MARK: - DynamicStylePropertySet -


/// Adds support for setting style properties by name / string, instead of direct reference. Necessary only if you want your StylePropertySet to support being configured via JSON or other dynamic means.

public protocol DynamicStylePropertySet : StylePropertySet {
    mutating func setStyleProperty<T>(named name:String, toValue value:T)
}


// MARK: - StylePropertySetCollection -

/// A storage type used by StyleClasses to save values that will later be applied to a view

public class StylePropertySetCollection {
    
    private var dictionary = [String : StylePropertySet]()
    
    fileprivate func retrieve<T:StylePropertySet>(propertySetType:T.Type) -> T {
        if let existing = dictionary[String(describing: propertySetType)] as? T {
            return existing
        }
        dictionary[String(describing: propertySetType)] = T.init()
        return dictionary[String(describing: propertySetType)] as! T
    }
    
    fileprivate func retrieve(dynamicPropertySetName:String)->DynamicStylePropertySet? {
        return dictionary[dynamicPropertySetName] as? DynamicStylePropertySet
    }
    
    fileprivate func register(propertySet:StylePropertySet) {
        dictionary[String(describing: type(of: propertySet))] = propertySet
    }
    
    // Optional: the collection can be initialized prepopulated with property sets.  This is only needed if using dynamic / string based lookup
    public convenience init(sets:[StylePropertySet.Type]?) {
        self.init()
        guard let parameterSets = sets else {
            return
        }
        for type in parameterSets {
            dictionary[String(describing: type)] = type.init()
        }
    }
    
    public convenience init(asCopyOf:StylePropertySetCollection) {
        self.init()
        self.dictionary = asCopyOf.dictionary
    }
    
    public init() {}
}


// MARK: - StyleClass extension - 

// Retrieve a specific StylePropertySet by name or by type
public extension StyleClass {
    public mutating func register(propertySet:StylePropertySet) {
        if isKnownUniquelyReferenced(&stylePropertySets) {
            stylePropertySets.register(propertySet: propertySet)
        } else {
            stylePropertySets = StylePropertySetCollection(asCopyOf: stylePropertySets)
            stylePropertySets.register(propertySet: propertySet)
        }
    }
    public func retrieve<T:StylePropertySet>(propertySet:T.Type)->T {
        return stylePropertySets.retrieve(propertySetType: propertySet)
    }
    public func retrieve(dynamicPropertySetName:String)->DynamicStylePropertySet? {
        return stylePropertySets.retrieve(dynamicPropertySetName: dynamicPropertySetName)
    }
}
