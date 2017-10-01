//
//  Graphite.swift
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

// 1. To define a Stylesheet, create a new class that conforms to the Stylesheet protocol

class Graphite : Stylesheet {
    
// 2. The protocol requires that you create a styleClasses variable to store an array of StyleClass instances that are part of this Stylesheet
    let styleClasses:[(identifier:String, styleClass:StyleClass)]

// 3. Inside the init() for your Stylesheet, initialize the styleClasses array with all the StyleClass instances that should be part of this Stylesheet. StyleClasses specific to this Stylesheet can be declared as nested types as you see further down.  Style Classes can also be reused between multiple Stylesheets, for example, the 'RoundedStyle' StyleClass below, which is declared in SharedStyleClasses.swift because it is identical across all Stylesheets.
    
    required init() {
        styleClasses = [("Primary Background Color", PrimaryBackgroundColor()), ("Secondary Background Color", SecondaryBackgroundColor()), ("Header Text", HeaderText()), ("Body Text", BodyText()), ("Progress Bar", ProgressBar()), ("Default Button", DefaultButton()), ("Stylesheet Title", StylesheetTitle()), ("Theme Image", ThemeImage()), ("Theme Description", ThemeDescription())]
    }

// 4. Here are the specific, nested StyleClass types defined for this Stylesheet. They can be made private, or left internal as below, to allow other Stylesheets to resuse them with their full type identifiers, e.g. 'Graphite.PrimaryBackgroundColor'
    
    struct PrimaryBackgroundColor : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            UIView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        }
    }
    
    struct SecondaryBackgroundColor : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            UIView.backgroundColor = UIColor(white: 0.75, alpha: 1.0)
        }
    }
    
    struct HeaderText : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            UILabel.font = UIFont.systemFont(ofSize: 20.0)
            UILabel.textColor = UIColor.darkGray
            UILabel.textAlignment = .left
        }
    }
    
    struct BodyText : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            UILabel.font = UIFont.systemFont(ofSize: 16.0)
            UILabel.textColor = UIColor.gray
            UILabel.textAlignment = .left
        }
    }
    
    struct ThemeDescription : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            UILabel.text = "Everything on this screen is configured entirely through styles. The styles specify images, fonts, text, button styles, and more. The styles are previewed and updated live inside the storyboard, so this screen looks the same at design time and runtime."
        }
    }
    
    struct ProgressBar : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            ProgressBar.progressColor = UIColor.gray
            ProgressBar.trackColor = UIColor(white: 0.9, alpha: 1.0)
            ProgressBar.cornerRadiusPercentage = 0.16
            UIView.cornerRadiusPercentage = 0.16
            UIView.borderWidth = 1.0
            UIView.borderColor = UIColor.gray.cgColor
        }
    }
    
    struct DefaultButton : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            UIButton.titleColorForNormalState = UIColor(red:0.21, green:0.29, blue:0.36, alpha:1.0)
            UIButton.titleColorForHighlightedState = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
            UIButton.titleColorForDisabledState = UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)
            UIView.cornerRadiusPercentage = 0.16
            UIView.borderWidth = 1.0
            UIView.borderColor = UIColor(red:0.21, green:0.29, blue:0.36, alpha:1.0).cgColor
            UIView.backgroundColor = UIColor(white: 0.82, alpha: 1.0)
        }
    }
    
    struct StylesheetTitle : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            UILabel.text = "Graphite"
        }
    }
    
    struct ThemeImage : StyleClass {
        var stylePropertySets = StylePropertySetCollection()
        init() {
            let bundle = Bundle(for: Aqua.self)
            UIImageView.image = UIImage(named: "stone", in: bundle, compatibleWith: UIScreen.main.traitCollection)!
        }
    }
}
