//
//  SharedStyleClasses.swift
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

// 1. To create a StyleClass, define a struct that conforms to the StyleClass protocol

struct RoundedStyle : StyleClass {
    
// 2. The protocol requires you to create storage for StylePropertySets that this StyleClass will access

    var stylePropertySets = StylePropertySetCollection()

    
// 3. Inside the init(), set whatever properties and values you want to be applied when this StyleClass is used. The format below specifies first the StylePropertySet (UIView), and then the specific property in that set. Properties are strongly typed, so you won't be able to use the wrong kind of value by accident. This 'RoundedStyle' StyleClass will set the cornerRadius to 30.0 on any UIView it is applied to. 
    
    init() {
        UIView.cornerRadius = 30.0
        UIView.masksToBounds = true
    }
}


struct HighlightedTextStyle : StyleClass {
    var stylePropertySets = StylePropertySetCollection()
    init() {
        UIView.backgroundColor = UIColor(red: 0.25, green: 0.75, blue: 0.75, alpha: 0.25)
    }
}
