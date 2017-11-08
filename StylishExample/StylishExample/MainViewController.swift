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
import Stylish

class MainViewController : UIViewController {
    
    // Set new global stylesheet
    @IBAction func changeStylesheet(_ sender: UIButton) {
        switch sender.currentTitle! {
        case "Graphite" :
            Stylish.stylesheet = Graphite()
        case "Aqua" :
            Stylish.stylesheet = Aqua()
        case "JSON" :
            // Locate the stylesheet JSON in the bundle
            let url =  Bundle.main.url(forResource: "stylesheet", withExtension: "json")!
            // Prepare shared styles that we want to add as additions to the parsed JSON Stylesheet styles
            let sharedStyles: [String: Style] = ["Rounded": RoundedStyle(), "HighlightedText": HighlightedTextStyle()]
            // Load the JSON Stylesheet. Note that we are passing in Stylish.builtInPropertyStylerTypes + ProgressBar.propertyStylers because we want our own PropertyStylers for our custom ProgressBar component to be able to parse their values from the JSON as well.  By default, you don't need to pass any argument and only Stylish's built-in PropertyStylers will participate in the parsing. Lastly, we add the additional shared styles to those parsed from json
            let stylesheet = (try! JSONStylesheet(file: url, usingPropertyStylerTypes: Stylish.builtInPropertyStylerTypes + ProgressBar.propertyStylers)).addingAdditionalStyles(sharedStyles)
            Stylish.stylesheet = stylesheet
        default :
            return
        }
    }
}

/*
 #### IMPORTANT!! ####
 The below two extensions must always be defined in the an app that is using Stylish if you want to have live style rendering in Interface Builder storyboards.
 */

extension UIView {
    // This is the only entry point for setting global variables in Stylish for Interface Builder rendering (since App Delegate doesn't get run by IBDesignable. So we are setting up the global stylesheet that we want used for IBDesignable rendering here.
    open override func prepareForInterfaceBuilder() {
        Stylish.stylesheet = Graphite()
    }
}

// In order to force IBDesignable to compile and use code from this hosting app (specifically, the prepareForInterfaceBuilder() override above where we set the global stylesheet for use during IBDesignable rendering), we need to either 1) Create an IBDesignable view inside the host app (like ProgressBar, in this case) and actually place an instance of it on the storyboard or 2) Override prepareForInterfaceBuilder in one Stylish's included styleable components here in the host app. Note that it must be one of the Stylish components actually in use on the storyboard, so it might not be StyleableUIView in your app, but might instead be StyleableUILabel, StyleableUIButton, etc.
extension StyleableUIView {
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
