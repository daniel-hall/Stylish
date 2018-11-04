//
//  StylesheetParseableExtensions.swift
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



// Add StylesheetParseable conformance to all the types used in the built-in PropertyStylers. This conformance converts the expected json value in the stylesheet (could be a String, a Bool, a Dictionary multiple key-values) into the corresponding Swift type

extension CGFloat: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> CGFloat? {
        return stylesheetValue as? CGFloat
    }
}

extension Bool: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> Bool? {
        return stylesheetValue as? Bool
    }
}

extension String: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> String? {
        return stylesheetValue as? String
    }
}

public struct StringArray: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> StringArray? {
        return StringArray(strings: (stylesheetValue as? [String]) ?? [])
    }
    public let strings: [String]
    public init(strings: [String]) {
        self.strings = strings
    }
}

extension Double: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> Double? {
        return stylesheetValue as? Double
    }
}

extension Int: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> Int? {
        return stylesheetValue as? Int
    }
}

extension Float: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> Float? {
        return stylesheetValue as? Float
    }
}

extension UIImage: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> Self? {
        if let value = stylesheetValue as? String, let image: UIImage = Bundle.allBundles.reduce(nil, { $0 == nil ? UIImage(named: value, in: $1, compatibleWith: nil) : $0 }) {
            if let cgImage = image.cgImage { return self.init(cgImage: cgImage) } else if let ciImage = image.ciImage { return self.init(ciImage: ciImage) }
        }
        return nil
    }
}

public struct UIImageArray: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIImageArray? {
        guard let values = stylesheetValue as? [String], let images: [UIImage] = try? values.map({
            if let image = UIImage.parse(from: $0) {
                return image
            }
            throw NSError(domain:"", code:0, userInfo: nil)
        }) else {
            return nil
        }
        return UIImageArray(images: images)
    }
    public let images: [UIImage]
    public init(images: [UIImage]) {
        self.images = images
    }
}

extension UIDataDetectorTypes: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIDataDetectorTypes? {
        if stylesheetValue as? String == "all" { return .all }
        if let array = stylesheetValue as? [String] {
            return array.reduce([] as UIDataDetectorTypes) {
                switch $1 {
                case "phoneNumber":
                    return $0.union(.phoneNumber)
                case "link":
                    return $0.union(.link)
                case "address":
                    return $0.union(.address)
                case "calendarEvent":
                    return $0.union(.calendarEvent)
                case "shipmentTrackingNumber":
                    if #available(iOS 10.0, *) {
                        return $0.union(.shipmentTrackingNumber)
                    } else { return $0 }
                case "flightNumber":
                    if #available(iOS 10.0, *) {
                        return $0.union(.flightNumber)
                    } else { return $0 }
                case "lookupSuggestion":
                    if #available(iOS 10.0, *) {
                        return $0.union(.lookupSuggestion)
                    } else { return $0 }
                default:
                    return $0
                }
            }
        }
        return nil
    }
}

extension NSLineBreakMode: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> NSLineBreakMode? {
        switch stylesheetValue as? String {
        case .some("byWordWrapping"):
            return .byWordWrapping
        case .some("byCharWrapping"):
            return .byCharWrapping
        case .some("byClipping"):
            return .byClipping
        case .some("byTruncatingHead"):
            return .byTruncatingHead
        case .some("byTruncatingTail"):
            return .byTruncatingTail
        case .some("byTruncatingMiddle"):
            return .byTruncatingMiddle
        default:
            return nil
        }
    }
}

extension UITextAutocapitalizationType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextAutocapitalizationType? {
        switch stylesheetValue as? String {
        case .some("none"):
            return .none
        case .some("words"):
            return .words
        case .some("sentences"):
            return .sentences
        case .some("allCharacters"):
            return .allCharacters
        default:
            return nil
        }
    }
}

extension UITextAutocorrectionType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextAutocorrectionType? {
        switch stylesheetValue as? String {
        case .some("default"):
            return .default
        case .some("no"):
            return .no
        case .some("yes"):
            return .yes
        default:
            return nil
        }
    }
}

extension UITextSpellCheckingType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextSpellCheckingType? {
        switch stylesheetValue as? String {
        case .some("default"):
            return .default
        case .some("no"):
            return .no
        case .some("yes"):
            return .yes
        default:
            return nil
        }
    }
}

@available(iOS 11.0, *)
extension UITextSmartQuotesType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextSmartQuotesType? {
        switch stylesheetValue as? String {
        case .some("default"):
            return .default
        case .some("no"):
            return .no
        case .some("yes"):
            return .yes
        default:
            return nil
        }
    }
}

@available(iOS 11.0, *)
extension UITextSmartDashesType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextSmartDashesType? {
        switch stylesheetValue as? String {
        case .some("default"):
            return .default
        case .some("no"):
            return .no
        case .some("yes"):
            return .yes
        default:
            return nil
        }
    }
}

@available(iOS 11.0, *)
extension UITextSmartInsertDeleteType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextSmartInsertDeleteType? {
        switch stylesheetValue as? String {
        case .some("default"):
            return .default
        case .some("no"):
            return .no
        case .some("yes"):
            return .yes
        default:
            return nil
        }
    }
}

extension UIKeyboardType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIKeyboardType? {
        switch stylesheetValue as? String {
        case .some("default"):
            return .default
        case .some("asciiCapable"):
            return .asciiCapable
        case .some("numbersAndPunctuation"):
            return .numbersAndPunctuation
        case .some("URL"):
            return .URL
        case .some("numberPad"):
            return .numberPad
        case .some("phonePad"):
            return .phonePad
        case .some("namePhonePad"):
            return .namePhonePad
        case .some("emailAddress"):
            return .emailAddress
        case .some("decimalPad"):
            return .decimalPad
        case .some("twitter"):
            return .twitter
        case .some("webSearch"):
            return .webSearch
        case .some("asciiCapableNumberPad"):
            if #available(iOS 10.0, *) {
                return .asciiCapableNumberPad
            } else { return nil }
        default:
            return nil
        }
    }
}

extension UIKeyboardAppearance: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIKeyboardAppearance? {
        switch stylesheetValue as? String {
        case .some("default"):
            return .default
        case .some("dark"):
            return .dark
        case .some("light"):
            return .light
        default:
            return nil
        }
    }
}

extension UIReturnKeyType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIReturnKeyType? {
        switch stylesheetValue as? String {
        case .some("default"):
            return .default
        case .some("go"):
            return .go
        case .some("google"):
            return .google
        case .some("join"):
            return .join
        case .some("next"):
            return .next
        case .some("route"):
            return .route
        case .some("search"):
            return .search
        case .some("send"):
            return .send
        case .some("yahoo"):
            return .yahoo
        case .some("done"):
            return .done
        case .some("emergencyCall"):
            return .emergencyCall
        case .some("continue"):
            return .continue
        default:
            return nil
        }
    }
}

extension UITextContentType: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextContentType? {
        if #available(iOS 10.0, *) {
            switch stylesheetValue as? String {
            case .some("name"):
                return .name
            case .some("namePrefix"):
                return .namePrefix
            case .some("givenName"):
                return .givenName
            case .some("middleName"):
                return .middleName
            case .some("familyName"):
                return .familyName
            case .some("nameSuffix"):
                return .nameSuffix
            case .some("nickname"):
                return .nickname
            case .some("jobTitle"):
                return .jobTitle
            case .some("organizationName"):
                return .organizationName
            case .some("location"):
                return .location
            case .some("fullStreetAddress"):
                return .fullStreetAddress
            case .some("streetAddressLine1"):
                return .streetAddressLine1
            case .some("streetAddressLine2"):
                return .streetAddressLine2
            case .some("addressCity"):
                return .addressCity
            case .some("addressState"):
                return .addressState
            case .some("addressCityAndState"):
                return .addressCityAndState
            case .some("sublocality"):
                return .sublocality
            case .some("countryName"):
                return .countryName
            case .some("postalCode"):
                return .postalCode
            case .some("telephoneNumber"):
                return .telephoneNumber
            case .some("emailAddress"):
                return .emailAddress
            case .some("URL"):
                return .URL
            case .some("creditCardNumber"):
                return .creditCardNumber
            case .some("username"):
                if #available(iOS 11.0, *) {
                    return .username
                } else { return nil }
            case .some("password"):
                if #available(iOS 11.0, *) {
                    return .password
                } else { return nil }
            default:
                return nil
            }
        }
        else {
            return nil
        }
    }
}

extension UITextField.ViewMode: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextField.ViewMode? {
        switch stylesheetValue as? String {
        case .some("never"):
            return .never
        case .some("whileEditing"):
            return .whileEditing
        case .some("unlessEditing"):
            return .unlessEditing
        case .some("always"):
            return .always
        default:
            return nil
        }
    }
}

extension UIBaselineAdjustment: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIBaselineAdjustment? {
        switch stylesheetValue as? String {
        case .some("alignBaselines"):
            return .alignBaselines
        case .some("alignCenters"):
            return .alignCenters
        case .some("none"):
            return .none
        default:
            return nil
        }
    }
}

extension UITextField.BorderStyle: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UITextField.BorderStyle? {
        switch stylesheetValue as? String {
        case .some("none"):
            return .none
        case .some("line"):
            return .line
        case .some("bezel"):
            return .bezel
        case .some("roundedRect"):
            return .roundedRect
        default:
            return nil
        }
    }
}


extension UIEdgeInsets: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIEdgeInsets? {
        guard let value = stylesheetValue as? [String: Any], let top = value["top"] as? CGFloat, let left = value["left"] as? CGFloat, let bottom = value["bottom"] as? CGFloat, let right = value["right"] as? CGFloat else{ return nil }
        return self.init(top: top, left: left, bottom: bottom, right: right)
    }
}

extension UIFont.Weight: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIFont.Weight? {
        guard let value = stylesheetValue as? String else { return nil }
        switch value {
        case "ultralight":
            return .ultraLight
        case "thin":
            return .thin
        case "light":
            return .light
        case "regular":
            return .regular
        case "medium":
            return .medium
        case "semibold":
            return .semibold
        case "bold":
            return .bold
        case "heavy":
            return .heavy
        case "black":
            return .black
        default:
            return nil
        }
    }
}

extension UIFont.TextStyle: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIFont.TextStyle? {
        switch stylesheetValue as? String{
        case .some("title1"):
            return .title1
        case .some("title2"):
            return .title2
        case .some("title3"):
            return .title3
        case .some("headline"):
            return .headline
        case .some("subheadline"):
            return .subheadline
        case .some("body"):
            return .body
        case .some("callout"):
            return .title1
        case .some("footnote"):
            return .footnote
        case .some("caption1"):
            return .caption1
        case .some("caption2"):
            return .caption2
        default:
            return nil
        }
    }
}

extension UIView.ContentMode: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> UIView.ContentMode? {
        guard let value = stylesheetValue as? String else { return nil }
        switch value {
        case "scaleToFill" :
            return .scaleToFill
        case "scaleAspectFit" :
            return .scaleAspectFit
        case "scaleAspectFill" :
            return .scaleAspectFill
        case "redraw" :
            return .redraw
        case "center" :
            return .center
        case "top" :
            return .top
        case "bottom" :
            return .bottom
        case "left" :
            return .left
        case "right" :
            return .right
        case "topLeft" :
            return .topLeft
        case "topRight" :
            return .topRight
        case "bottomLeft" :
            return .bottomLeft
        case "bottomRight" :
            return .bottomRight
        default :
            return nil
        }
    }
}

extension UIFont: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> Self? {
        guard let json = stylesheetValue as? [String: Any] else { return nil }
        if let fontName = json["name"] as? String, let fontSize = json["size"] as? CGFloat {
            return self.init(name: fontName, size: fontSize)
        }
        else if let fontSize = json["size"] as? CGFloat, let weight = UIFont.Weight.parse(from: json["weight"] as Any) {
            return self.init(descriptor: systemFont(ofSize: fontSize, weight: weight).fontDescriptor, size: fontSize)
        }
        else if let fontSize = json["size"] as? CGFloat {
            return self.init(descriptor: systemFont(ofSize: fontSize).fontDescriptor, size: fontSize)
        }
        else if let boldFontSize = json["boldSize"] as? CGFloat {
            return self.init(descriptor: boldSystemFont(ofSize: boldFontSize).fontDescriptor, size: boldFontSize)
        }
        else if let italicFontSize = json["italicSize"] as? CGFloat {
            return self.init(descriptor: italicSystemFont(ofSize: italicFontSize).fontDescriptor, size: italicFontSize)
        }
        else if let textStyle = UIFont.TextStyle.parse(from: json["textStyle"] as Any) {
            let font = preferredFont(forTextStyle: textStyle)
            return self.init(descriptor: font.fontDescriptor, size: font.pointSize)
        }
        return nil
    }
}

extension NSTextAlignment: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> NSTextAlignment? {
        guard let value = stylesheetValue as? String else { return nil }
        switch value {
        case "left":
            return .left
        case "right":
            return .right
        case "center":
            return .center
        case "justified":
            return .justified
        case "natural":
            return .natural
        default :
            return nil
        }
    }
}

extension URL: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> URL? {
        return URL(string: stylesheetValue as? String ?? "")
    }
}

extension CGSize: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> CGSize? {
        guard let json = stylesheetValue as? [String: Any], let width = json["width"] as? Double, let height = json["height"] as? Double else {
            return nil
        }
        return self.init(width: width, height: height)
    }
}

extension UIColor: StylesheetParseable {
    public static func parse(from stylesheetValue: Any) -> Self? {
        guard let hexString = stylesheetValue as? String else { return nil }
        let r, g, b, a: CGFloat
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy:1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 || hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = hexColor.count == 8 ? CGFloat((hexNumber & 0xff000000) >> 24) / 255 : CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = hexColor.count == 8 ? CGFloat((hexNumber & 0x00ff0000) >> 16) / 255 : CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = hexColor.count == 8 ? CGFloat((hexNumber & 0x0000ff00) >> 8) / 255 : CGFloat(hexNumber & 0x000000ff) / 255
                    a = hexColor.count == 8 ? CGFloat(hexNumber & 0x000000ff) / 255 : 1.0
                    
                    return self.init(red: r, green: g, blue: b, alpha: a)
                }
            }
        }
        return nil
    }
}

