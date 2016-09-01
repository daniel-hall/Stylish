//
//  MainViewController.swift
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



import UIKit

class MainViewController : UIViewController {
    
    // Set new global stylesheet
    @IBAction func changeStylesheet(_ sender: UIButton) {
        switch sender.currentTitle! {
        case "Graphite" :
            Stylish.GlobalStylesheet = Graphite.self
        case "Aqua" :
            Stylish.GlobalStylesheet = Aqua.self
        case "JSON" :
            Stylish.GlobalStylesheet = StylishExampleJSONStylesheet.self
        default :
            return
        }
        
        refreshStyles(view)
    }
    
    // Re-apply styles to all styleable views in hierarchy
    func refreshStyles(_ forView:UIView) {
        for subview in forView.subviews {
            refreshStyles(subview)
        }
        if let styleable = forView as? Styleable {
            var styleableView = styleable
            styleableView.stylesheet = styleable.stylesheet
        }
    }
}
