//
//  JSONStylesheet.swift
//  StylishExample
//
//  Created by Daniel Hall on 4/19/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation
import UIKit


enum StyleProperty {
    case FloatProperty(value:CGFloat)
    case StringProperty(value:String)
    case ColorProperty(value:UIColor)
    
    init?(dictionary:[String : AnyObject]) {
        guard let type = dictionary["propertyType"] as? String else {
            return nil
        }
        switch type {
        case "float" :
            guard let value = dictionary["propertyValue"] as? CGFloat else {
                return nil
            }
            self = .FloatProperty(value: value)
        case "string" :
            guard let value = dictionary["propertyValue"] as? String else {
                return nil
            }
            self = .StringProperty(value: value)
        case "color" :
            guard let r = (dictionary["propertyValue"]?["r"] as? NSNumber)?.floatValue, let g = (dictionary["propertyValue"]?["g"] as? NSNumber)?.floatValue, let b = (dictionary["propertyValue"]?["b"] as? NSNumber)?.floatValue, let a = (dictionary["propertyValue"]?["a"] as? NSNumber)?.floatValue else {
                return nil
            }
            self = .ColorProperty(value: UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a)))
        default :
            return nil
        }
    }
    
    var value:Any {
        switch self {
        case .ColorProperty(let value) :
            return value
        case .FloatProperty(let value) :
            return value
        case .StringProperty(let value) :
            return value
        }
    }
    
}


final class JSONStylesheet : Stylesheet {
    
    struct DynamicStyleClass : MutableStyleClass {
        var properties = [String : Any]()
        init(array:[[String : AnyObject]]) {
            for dictionary in array {
                if let property = dictionary["propertyName"] as? String, let style = StyleProperty(dictionary:dictionary) {
                    setValue(style.value, forProperty: property)
                }
            }
        }
    }
    
    var styleClasses = [(identifier: String, styleClass: StyleClass)]()
    
    init() {
        let bundle = NSBundle(forClass: JSONStylesheet.self)
        if let path = bundle.pathForResource("stylesheet", ofType: "json"), let data = NSData(contentsOfFile:path), let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
            for dictionary in json {
                if let styleClass = dictionary["styleClass"] as? String, let array = dictionary["properties"] as? [[String : AnyObject]] {
                    styleClasses.append((identifier: styleClass, styleClass: DynamicStyleClass(array: array)))
                }
            }
        }
    }
}