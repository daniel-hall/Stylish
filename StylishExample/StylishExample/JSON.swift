//
//  JSON.swift
//  StylishExample
//
// Copyright (c) 2016 Daniel Hall
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




import Stylish
import UIKit

// Our customized stylesheet that is loaded from JSON

class JSON : Stylesheet {
    let styles: [String : Style]
    init() {
        // Locate the stylesheet JSON in the bundle
        let url =  Bundle(for: JSON.self).url(forResource: "stylesheet", withExtension: "json")!
        // Prepare shared styles that we want to add as additions to the parsed JSON Stylesheet styles
        let sharedStyles: [String: Style] = ["Rounded": RoundedStyle(), "HighlightedText": HighlightedTextStyle()]
        // Load the JSON Stylesheet. Note that we are passing in Stylish.builtInPropertyStylerTypes + ProgressBar.propertyStylers because we want our own PropertyStylers for our custom ProgressBar component to be able to parse their values from the JSON as well.  By default, you don't need to pass any argument and only Stylish's built-in PropertyStylers will participate in the parsing.
        let jsonStylesheet = try! JSONStylesheet(file: url, usingPropertyStylerTypes: Stylish.builtInPropertyStylerTypes + ProgressBar.propertyStylers)
        // Lastly make this stylesheet's styles a combination of those parsed by the Stylish JSONStylesheet, and our own shared styles
        styles = jsonStylesheet.styles + sharedStyles
    }
}
