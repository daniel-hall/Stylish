//
//  JSONStylesheet
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



/// A Stylish Stylesheet that can dynamically populate its member styles and style names by parsing them from a json file.
public class JSONStylesheet: Stylesheet {
    public private(set) var styles: [String : Style]
    
    /// Initializer for instantiating a stylesheet dynamically from json.
    ///
    /// - Parameters:
    ///   - file: A URL to the location of the json stylesheet file
    ///   - propertyStylerTypes: An array of property styler types that will be used to parse all the properties that make up the styles in the stylesheet json.  By default, the standard set of built-in Stylish PropertyStylers will be used, but client apps can append additional custom PropertyStyler types to built-in types. E.g. StylishbuiltInPropertyStylerTypes + [CustomComponentPropertyOneStyler.self, CustomComponentPropertyTwoStyler.self]
    ///   - ignoringUnrecognizedStyleProperties: Normally, if the JSONStylesheet parsing encounters an unknown property name / property type which it doesn't know how to parse, it will throw an error and fail the entire intiialization.  When this parameter is set to true, failed properties will be ignored and the JSONStylesheet will include only the styles and properties it was able to parse, and will not throw errors for unparsed properties.
    /// - Throws: An NSError with a description of what went wrong
    public convenience init(file: URL, usingPropertyStylerTypes propertyStylerTypes: [AnyPropertyStylerType.Type] = Stylish.builtInPropertyStylerTypes, ignoringUnrecognizedStyleProperties: Bool = false) throws {
        try self.init(data: Data(contentsOf: file), usingPropertyStylerTypes: propertyStylerTypes, ignoringUnrecognizedStyleProperties: ignoringUnrecognizedStyleProperties)
    }
    
    /// Initializer for instantiating a stylesheet dynamically from json.
    ///
    /// - Parameters:
    ///   - data: JSON data loaded from a file, a network request, etc.
    ///   - propertyStylerTypes: An array of property styler types that will be used to parse all the properties that make up the styles in the stylesheet json.  By default, the standard set of built-in Stylish PropertyStylers will be used, but client apps can append additional custom PropertyStyler types to built-in types. E.g. StylishbuiltInPropertyStylerTypes + [CustomComponentPropertyOneStyler.self, CustomComponentPropertyTwoStyler.self]
    ///   - ignoringUnrecognizedStyleProperties: Normally, if the JSONStylesheet parsing encounters an unknown property name / property type which it doesn't know how to parse, it will throw an error and fail the entire intiialization.  When this parameter is set to true, failed properties will be ignored and the JSONStylesheet will include only the styles and properties it was able to parse, and will not throw errors for unparsed properties.
    /// - Throws: An NSError with a description of what went wrong
    public init(data: Data, usingPropertyStylerTypes propertyStylerTypes: [AnyPropertyStylerType.Type] = Stylish.builtInPropertyStylerTypes, ignoringUnrecognizedStyleProperties: Bool = false) throws {
        let propertyStylerTypes = Dictionary(propertyStylerTypes.map{(($0.wrapped as! AnyPropertyStylerTypeWrapper).propertyKey, $0.wrapped as! AnyPropertyStylerTypeWrapper)}, uniquingKeysWith: { $1 })
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let styles = json["styles"] as? [[String: Any]] else {
            throw NSError(domain: "Stylish", code: 100, userInfo: [NSLocalizedDescriptionKey: "Stylesheet JSON was not in the correct format. Please ensure the stylesheet JSON is a top-level dictionary that includes a \"styles\" key with a corresponding value that is an array of style dictionary objects. Each style dictionary object should minimally have a \"styleName\" key with a string value, and \"styleProperties\" key with dictionary value containing property name keys and corresponding values to set"])
        }
        let keyValues: [(String, Style)] = try styles.compactMap {
            jsonStyle in
            guard let styleName = jsonStyle["styleName"] as? String, let properties = jsonStyle["styleProperties"] as? [String: Any] else {
                throw NSError(domain: "Stylish", code: 101, userInfo: [NSLocalizedDescriptionKey: "Stylesheet JSON was not in the correct format. Please ensure the stylesheet JSON is a top-level dictionary that includes a \"styles\" key with a corresponding value that is an array of style dictionary objects. Each style dictionary object should minimally have a \"styleName\" key with a string value, and \"styleProperties\" key with dictionary value containing property name keys and corresponding values to set"])
            }
            let propertyStylers: [AnyPropertyStyler] = try properties.compactMap {
                key, value in
                guard let styler = propertyStylerTypes[key]?.propertyStyler(jsonPropertyName: key, jsonPropertyValue: value) else {
                    if ignoringUnrecognizedStyleProperties {
                        return nil
                    }
                    throw NSError(domain: "Stylish", code: 103, userInfo: [NSLocalizedDescriptionKey: "None of the provided PropertyStylers could parse the json style property \"\(key)\" with the value: \(value)"])
                }
                return styler
            }
            return (styleName, AnyStyle(propertyStylers: propertyStylers))
        }
        self.styles = Dictionary(keyValues, uniquingKeysWith:{ return $1 })
    }
}
