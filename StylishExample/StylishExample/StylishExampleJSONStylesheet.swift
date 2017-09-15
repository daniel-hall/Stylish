//
//  StylishExampleJSONStylesheet.swift
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


// Stylish provides a base implementation for reading and parsing style classes from a json stylesheet.  However, that base implementation isn't aware of any custom property sets you may have created for your own custom styleable views.  Therefore, in order to use the JSON stylesheet functionality with your own custom views, you must subclass 'JSONStylesheet' and override the 'dynamicPropertySets' getter to include both those defined in the base immplementation, and your own.   You can also override the styleClasses getter to include shared StyleClasses that you want added to those which will be parsed out of the JSON.

class StylishExampleJSONStylesheet:JSONStylesheet {
    
    //Add some shared StyleClasses that will be reused along with any Style Classes defined in the JSON stylesheet.
    
    override var styleClasses:[(identifier: String, styleClass: StyleClass)] { get { return super.styleClasses + [("Rounded", RoundedStyle()), ("HighlightedText", HighlightedTextStyle())] } set { super.styleClasses = newValue } }

}


