//
//  JSONStylesheet.swift
//  Stylish
//
//  Created by Hall, Daniel on 8/11/17.
//
//

import Foundation



// Add some global settings and values for JSON stylesheet parsing

public extension Stylish {
    
    private static var customJSONStyleProperties: [JSONStyleProperty] = []
    
    /// A method that allows an app using Stylish to register its own JSONStyleProperty definitions to use when parsing JSON.  A JSONStyleProperty simply defines a way to identify an parse different native Swift values from JSON values, for example, parsing UIEdgeInsets from a JSON dictionary.
    public static func registerCustomJSONStyleProperties(_ jsonStyleProperties: [JSONStyleProperty]) {
        let nonDuplicates = jsonStyleProperties.filter{ jsonStyleProperty in customJSONStyleProperties.first{ $0.propertyTypeNames == jsonStyleProperty.propertyTypeNames } == nil }
            customJSONStyleProperties += nonDuplicates
    }
    
    /// All defined JSONStyleProperty instances being used by Stylish, which included all the built-in properties plus any specified in customJSONStyleProperties.
    public static var jsonStyleProperties: [JSONStyleProperty] { return customJSONStyleProperties + builtInJSONStyleProperties }
    
    private static var customDynamicPropertySets: [StylePropertySet.Type] = []
    
    /// A method that allows an app using Stylish to register specific dynamic style property sets (groups of properties for styling custom components) that can be defined in and parsed from JSON.
    public static func registerCustomDynamicPropertySets(_ dynamicPropertySets: [StylePropertySet.Type]) {
        let nonDuplicates = dynamicPropertySets.filter{ dynamicPropertySetType in !customDynamicPropertySets.contains{ $0 == dynamicPropertySetType } }
        customDynamicPropertySets += nonDuplicates
    }
    
    /// All defined dynamic style property sets being used by Stylish, which included all the built-in property sets plus any specified in customDynamicPropertySets.
    public static var dynamicPropertySets:[StylePropertySet.Type] {
        return [UIViewPropertySet.self, UILabelPropertySet.self, UIButtonPropertySet.self, UIImageViewPropertySet.self] + customDynamicPropertySets
    }
    
    /// The name of the stylesheet json file which sould be retrieved and used by Stylish
    public static var jsonStylesheetName: String = "stylesheet"
    
    private static var builtInJSONStyleProperties: [JSONStyleProperty] {
        let cgfloatProperty = JSONStyleProperty(propertyTypeNameVariations: ["CG Float", "CGFloat", "cgfloat", "cg float", "cg_float", "cgFloat"]) { $0 as? CGFloat }
        let floatProperty = JSONStyleProperty(propertyTypeNameVariations: ["Float", "float"]) { return $0 as? Float }
        let doubleProperty = JSONStyleProperty(propertyTypeNameVariations: ["Double", "double"]) { return $0 as? Double }
        let intProperty = JSONStyleProperty(propertyTypeNameVariations: ["Int", "int"]) { return $0 as? Int }
        let boolProperty = JSONStyleProperty(propertyTypeNameVariations: ["Bool", "bool"]) { return $0 as? Bool }
        
        let uiedgeinsetsProperty = JSONStyleProperty(propertyTypeNameVariations: ["UI Edge Insets", "UIEdgeInsets", "ui edge insets", "EdgeInsets", "Edge Insets", "edgeInsets", "uiEdgeInsets", "ui_edge_insets", "edge_insets", "edgeinsets", "edge insets"]) {
            guard let value = $0 as? [String : Any], let top = (value["top"] as? NSNumber)?.floatValue, let left = (value["left"] as? NSNumber)?.floatValue, let bottom = (value["bottom"] as? NSNumber)?.floatValue, let right = (value["right"] as? NSNumber)?.floatValue else { return nil }
            return UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
        }
        
        let nstextalignmentProperty = JSONStyleProperty(propertyTypeNameVariations: ["NSTextAlignment", "nstextalignment", "nsTextAlignment", "ns_text_alignment", "Text Alignment", "TextAlignment", "textAlignment", "text_alignment", "text alignment", "textalignmnet"]) {
            guard let value = $0 as? String else { return nil }
            switch value {
            case _ where value.isVariant(of: "Left") :
                return NSTextAlignment.left
            case _ where value.isVariant(of: "Center") :
                return NSTextAlignment.center
            case _ where value.isVariant(of: "Right") :
                return NSTextAlignment.right
            case _ where value.isVariant(of: "Justified") :
                return NSTextAlignment.justified
            case _ where value.isVariant(of: "Natural") :
                return NSTextAlignment.natural
            default:
                return nil
            }
        }
        
        let stringProperty = JSONStyleProperty(propertyTypeNameVariations: ["String", "string"]) { return $0 as? String }
        
        let uicolorProperty = JSONStyleProperty(propertyTypeNameVariations: ["UIColor", "UI Color","uiColor", "ui_color", "uicolor", "ui color", "Color", "color"]) {
            guard let hex = $0 as? String, let value = UIColor(hexString:hex) else {
                return nil
            }
            return value
        }
        
        let cgcolorProperty = JSONStyleProperty(propertyTypeNameVariations: ["CGColor", "CG Color","cgColor", "cg_color", "cgcolor", "cg color"]) {
            guard let hex = $0 as? String, let value = UIColor(hexString:hex)?.cgColor else { return nil }
            return value
        }
        
        let uiimageProperty = JSONStyleProperty(propertyTypeNameVariations: ["UIImage", "UI Image","uiImage", "ui_image", "uiimage", "ui image", "Image", "image"]) {
            guard let name = $0 as? String, let value = UIImage(named: name, in: Stylish.appBundle, compatibleWith: UIScreen.main.traitCollection) else { return nil }
            return value
        }
        
        let uiviewcontentmodeProperty = JSONStyleProperty(propertyTypeNameVariations: ["UI View Content Mode", "UIViewContentMode", "uiViewContentMode", "uiviewcontentmode", "ui_view_content_mode", "ui view content mode", "View Content Mode", "ViewContentMode", "viewContentMode", "viewcontentmode", "view_content_mode", "view content mode"]) {
            guard let value = $0 as? String else {
                return nil
            }
            switch value {
            case _ where value.isVariant(of: "Scale To Fill") :
                return UIViewContentMode.scaleToFill
            case _ where value.isVariant(of: "Scale Aspect Fit") :
                return UIViewContentMode.scaleAspectFit
            case _ where value.isVariant(of: "Scale Aspect Fill") :
                return UIViewContentMode.scaleAspectFill
            case _ where value.isVariant(of: "Redraw") :
                return UIViewContentMode.redraw
            case _ where value.isVariant(of: "Center") :
                return UIViewContentMode.center
            case _ where value.isVariant(of: "Top") :
                return UIViewContentMode.top
            case _ where value.isVariant(of: "Bottom") :
                return UIViewContentMode.bottom
            case _ where value.isVariant(of: "Left") :
                return UIViewContentMode.left
            case _ where value.isVariant(of: "Right") :
                return UIViewContentMode.right
            case _ where value.isVariant(of: "Top Left") :
                return UIViewContentMode.topLeft
            case _ where value.isVariant(of: "Top Right") :
                return UIViewContentMode.topRight
            case _ where value.isVariant(of: "Bottom Left") :
                return UIViewContentMode.bottomLeft
            case _ where value.isVariant(of: "Bottom Right") :
                return UIViewContentMode.bottomRight
            default :
                return nil
            }
        }
        
        let uifontProperty = JSONStyleProperty(propertyTypeNameVariations: ["UI Font", "UIFont", "uiFont", "uifont", "ui_font", "ui font", "Font", "font"]) {
            guard let value = $0 as? [String : Any], let fontName = value["name"] as? String, let fontSize = (value["size"] as? NSNumber)?.floatValue, let font = UIFont(name: fontName, size: CGFloat(fontSize)) else {
                return nil
            }
            return font
        }
        
        let systemfontProperty = JSONStyleProperty(propertyTypeNameVariations: ["System Font", "SystemFont", "systemFont", "systemfont", "system_font", "system font"]) {
            guard let value = $0 as? [String : Any] else {
                return nil
            }
            if let fontSize = (value["size"] as? NSNumber)?.floatValue, let fontWeight = value["weight"] as? String {
                let font: UIFont?
                switch(fontWeight) {
                case _ where fontWeight.isVariant(of: "Ultra Light") || fontWeight.isVariant(of: "UI Font Weight Ultra Light") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightUltraLight)
                case _ where fontWeight.isVariant(of: "Thin") || fontWeight.isVariant(of: "UI Font Weight Thin") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightThin)
                case _ where fontWeight.isVariant(of: "Light") || fontWeight.isVariant(of: "UI Font Weight Light") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightLight)
                case _ where fontWeight.isVariant(of: "Regular") || fontWeight.isVariant(of: "UI Font Weight Regular") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightRegular)
                case _ where fontWeight.isVariant(of: "Medium") || fontWeight.isVariant(of: "UI Font Weight Medium") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightMedium)
                case _ where fontWeight.isVariant(of: "Semibold") || fontWeight.isVariant(of: "UI Font Weight Semibold") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightSemibold)
                case _ where fontWeight.isVariant(of: "Bold") || fontWeight.isVariant(of: "UI Font Weight Bold") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightBold)
                case _ where fontWeight.isVariant(of: "Heavy") || fontWeight.isVariant(of: "UI Font Weight Heavy") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightHeavy)
                case _ where fontWeight.isVariant(of: "Black") || fontWeight.isVariant(of: "UI Font Weight Black") :
                    font = UIFont.systemFont(ofSize: CGFloat(fontSize), weight: UIFontWeightBlack)
                default :
                    font = nil
                }
                if let resolvedFont = font {
                    return resolvedFont
                }
                return nil
            }
            else if let fontSize = (value["size"] as? NSNumber)?.floatValue {
                return UIFont.systemFont(ofSize: CGFloat(fontSize))
            }
            return nil
        }
        
        let boldsystemfontProperty = JSONStyleProperty(propertyTypeNameVariations: ["Bold System Font", "BoldSystemFont", "boldSystemFont", "boldsystemfont", "bold_system_font", "bold system font"]) {
            guard let value = $0 as? [String : Any], let fontSize = (value["size"] as? NSNumber)?.floatValue else {
                return nil
            }
            return UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
        }
        
        let italicsystemfontProperty = JSONStyleProperty(propertyTypeNameVariations: ["Italic System Font", "ItalicSystemFont", "italicSystemFont", "italicsystemfont", "italic_system_font", "italic system font"]) {
            guard let value = $0 as? [String : Any], let fontSize = (value["size"] as? NSNumber)?.floatValue else {
                return nil
            }
            return UIFont.italicSystemFont(ofSize: CGFloat(fontSize))
        }
        
        let preferredfontProperty = JSONStyleProperty(propertyTypeNameVariations: ["Preferred Font", "PreferredFont", "preferredFont", "prefferedfont", "preferred_font", "preferred font"]) {
            guard let value = $0 as? [String : Any], let textStyle = value["textStyle"] as? String else {
                return nil
            }
            switch(textStyle) {
            case _ where textStyle.isVariant(of: "Title 1") || textStyle.isVariant(of: "UI Font Text Style Title 1") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
            case _ where textStyle.isVariant(of: "Title 2") || textStyle.isVariant(of: "UI Font Text Style Title 2") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.title2)
            case _ where textStyle.isVariant(of: "Title 3") || textStyle.isVariant(of: "UI Font Text Style Title 3") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.title3)
            case _ where textStyle.isVariant(of: "Headline") || textStyle.isVariant(of: "UIFontTextStyleHeadline") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
            case _ where textStyle.isVariant(of: "Subheadline") || textStyle.isVariant(of: "UI Font Text Style Subheadline") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
            case _ where textStyle.isVariant(of: "Body") || textStyle.isVariant(of: "UI Font Text Style Body") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            case _ where textStyle.isVariant(of: "Callout") || textStyle.isVariant(of: "UI Font Text Style Callout") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.callout)
            case _ where textStyle.isVariant(of: "Footnote") || textStyle.isVariant(of: "UI Font Text Style Footnote") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
            case _ where textStyle.isVariant(of: "Caption 1") || textStyle.isVariant(of: "UI Font Text Style Caption 1") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
            case _ where textStyle.isVariant(of: "Caption 2") || textStyle.isVariant(of: "UI Font Text Style Caption 2") :
                return UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption2)
            default :
                return nil
            }
        }
        
        return [cgfloatProperty, floatProperty, doubleProperty, intProperty, boolProperty, uiedgeinsetsProperty, nstextalignmentProperty, stringProperty, uicolorProperty, cgcolorProperty, uiimageProperty, uiviewcontentmodeProperty, uifontProperty, systemfontProperty, boldsystemfontProperty, italicsystemfontProperty, preferredfontProperty]
    }
}

// MARK: JSONStyleProperty

/// A struct that defines how to convert a JSON value of a certain type to a Swift / iOS instance of a corresponding type

public struct JSONStyleProperty {
    private let parse: (Any) -> Any?
    public let propertyTypeNames: [String]
    
    /// Constructs a new instance of a JSONStyleProperty
    ///
    /// - Parameters:
    ///   - propertyTypeNameVariations: An array of string values that can be matched against the "propertyType" key in a JSON style definition. This JSONStyleProperty will only attempt to parse the JSON value associated with the key "propertyValue" if the value for "propertyType" matches one of the strings in this array
    ///   - parseClosure: A closure that receives the value associated with the JSON key "propertyValue".  Note that this could be a string, a bool, a dictionary, an array, etc. The closure is responsible for converting that value into a specific corresponding Swift type instance.
    public init(propertyTypeNameVariations:[String], parseClosure:@escaping (Any)->Any?) {
        propertyTypeNames = propertyTypeNameVariations
        parse = parseClosure
    }
    
    public func parse(jsonValue:Any?) -> Any? {
        if let jsonValue = jsonValue {
            return parse(jsonValue)
        }
        return nil
    }
}


// MARK: JSONStylesheet


open class JSONStylesheet : Stylesheet {
    
    static internal var cachedStylesheet:JSONStylesheet?
    static internal var cacheTimestamp:TimeInterval = 0
    
    struct DynamicStyleClass : StyleClass {
        var stylePropertySets:StylePropertySetCollection
        init(jsonArray:[[String : AnyObject]], styleClass:String, dynamicPropertySets:[StylePropertySet.Type]? = nil) {
            stylePropertySets = StylePropertySetCollection(sets: dynamicPropertySets)
            for dictionary in jsonArray {
                if let propertySetName = dictionary["propertySetName"] as? String, let propertyName = dictionary["propertyName"] as? String, let propertyValue = dictionary["propertyValue"], let propertyType = dictionary["propertyType"] as? String, let styleProperty = Stylish.jsonStyleProperties.filter({
                    $0.propertyTypeNames.contains(propertyType) && $0.parse(jsonValue: propertyValue) != nil
                }).first {
                    var propertySet = retrieve(dynamicPropertySetName: propertySetName)
                    propertySet?.setStyleProperty(named:propertyName, toValue:styleProperty.parse(jsonValue: propertyValue))
                    if let modified = propertySet {
                        register(propertySet: modified)
                    }
                } else {
                    assertionFailure("Could not find a JSONStyleProperty instance that could parse: \(dictionary)")
                }
            }
        }
    }
    
    open var styleClasses = [(identifier: String, styleClass: StyleClass)]()
    
    required public init() {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let savedDirectory = paths[0]
        let filename = savedDirectory.appending("/\(Stylish.jsonStylesheetName).json")
        let fileManager = FileManager.default
        
        // Compare the file modification date of the downloaded / copied version of stylesheet.json in the Documents directory, and the original version of stylesheet.json included in the app bundle. If the Documents version is more recent, load and parse that version.  Otherwise, use the bundle version and then copy it to the Documents directory.
        
        if let savedAttributes = try? fileManager.attributesOfItem(atPath: filename), let savedDate = savedAttributes[FileAttributeKey.modificationDate] as? NSDate, let path = Stylish.appBundle.path(forResource: "stylesheet", ofType: "json"), let bundledAttributes = try? fileManager.attributesOfItem(atPath: path), let bundledDate = bundledAttributes[FileAttributeKey.modificationDate] as? NSDate  {
            
            if let data = NSData(contentsOfFile:filename), let json = (try? JSONSerialization.jsonObject(with: data as Data, options:[])) as? [[String : AnyObject]], savedDate.timeIntervalSinceReferenceDate >= bundledDate.timeIntervalSinceReferenceDate {
                parse(json: json)
            } else if let path = Stylish.appBundle.path(forResource: Stylish.jsonStylesheetName, ofType: "json"), let data = NSData(contentsOfFile:path), let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
                if let stringJSON = String(data:data as Data, encoding: String.Encoding.utf8) {
                    do {
                        try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                    }
                    catch {}
                }
                
                parse(json: json)
            }
        }
        else if let path = Stylish.appBundle.path(forResource: Stylish.jsonStylesheetName, ofType: "json"), let data = NSData(contentsOfFile:path), let json = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions(rawValue: 0))) as? [[String : AnyObject]] {
            if let stringJSON = String(data:data as Data, encoding: String.Encoding.utf8) {
                do {
                    try stringJSON.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)
                }
                catch {}
            }
            parse(json: json)
        }
        
        return
    }
    
    private func parse(json:[[String : AnyObject]]) {
        for dictionary in json {
            if let styleClass = dictionary["styleClass"] as? String, let array = dictionary["properties"] as? [[String : AnyObject]] {
                styleClasses.append((identifier: styleClass, styleClass: DynamicStyleClass(jsonArray: array, styleClass:styleClass, dynamicPropertySets: Stylish.dynamicPropertySets)))
            } else {
                assert(false, "Error in JSON stylesheet, possibly missing a 'styleClass' String value, or a 'properties' array for one of the included style classes")
            }
        }
        JSONStylesheet.cacheTimestamp = NSDate.timeIntervalSinceReferenceDate
        JSONStylesheet.cachedStylesheet = self
    }
}


// MARK: UIColor(hexString:) extension

private extension UIColor {
    
    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy:1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 || hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0xff000000) >> 24) / 255 : CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0x00ff0000) >> 16) / 255 : CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = hexColor.characters.count == 8 ? CGFloat((hexNumber & 0x0000ff00) >> 8) / 255 : CGFloat(hexNumber & 0x000000ff) / 255
                    a = hexColor.characters.count == 8 ? CGFloat(hexNumber & 0x000000ff) / 255 : 1.0
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        self.init()
        return nil
    }
}
