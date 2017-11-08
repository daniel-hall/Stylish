////
////  SharedStyles.swift
////  StylishExample
////
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

// 1. To create a Style, define a type that conforms to the Style protocol

struct RoundedStyle : Style {
    
    // 2. Each type that conforms to Style is required by the protocol to specify an array of [AnyPropertyStyler] that will run when the Style is applied. To create an instance of AnyPropertyStyler, call the default implemented "set" static method on one of your custom PropertyStylers, or one of Stylish's built-in PropertyStylers.
    var propertyStylers = [cornerRadius.set(value: 30.0), masksToBounds.set(value: true)]
}


struct HighlightedTextStyle : Style {
    var propertyStylers = [
        highlightedTextColor.set(value: UIColor(red: 0.25, green: 0.75, blue: 0.75, alpha: 0.25)),
        isHighlighted.set(value: true)
        ]
}

