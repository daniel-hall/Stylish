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

// 1. To define a Stylesheet, create a new type that conforms to the Stylesheet protocol

class Graphite : Stylesheet {
    
// 2. The protocol requires that you create a styles dictionary that defines a mapping of style names to style instances
    let styles: [String : Style] = [
        "PrimaryBackgroundColor": PrimaryBackgroundColor(),
        "SecondaryBackgroundColor": SecondaryBackgroundColor(),
        "HeaderText": HeaderText(),
        "BodyText": BodyText(),
        "ThemeDescription": ThemeDescription(),
        "DefaultProgressBar": DefaultProgressBar(),
        "DefaultButton": DefaultButton(),
        "StylesheetTitle": StylesheetTitle(),
        "ThemeImage": ThemeImage(),
        "Rounded": RoundedStyle(),   // This style is defined in a separate file (SharedStyles.swift) for easy reuse in multiple stylesheets
        "HighlightedText": HighlightedTextStyle() // This style is defined in a separate file (SharedStyles.swift) for easy reuse in multiple stylesheets
    ]
    
// 3. Here are the specific, nested Style types defined for this Stylesheet. They can be made private, or left internal as below, to allow other Stylesheets to resuse them with their full type identifiers, e.g. 'Graphite.PrimaryBackgroundColor'
    
    
    // 4. Each type that conforms to Style is required by the protocol to specify an array of [AnyPropertyStyler] that will run when the Style is applied. To create an instance of AnyPropertyStyler, call the default implemented "set" static method on one of your custom PropertyStylers, or one of Stylish's built-in PropertyStylers.
    struct PrimaryBackgroundColor : Style {
        var propertyStylers = [backgroundColor.set(value: UIColor(white: 0.9, alpha: 1.0))]
    }
    
    struct SecondaryBackgroundColor : Style {
        var propertyStylers = [backgroundColor.set(value: UIColor(white: 0.75, alpha: 1.0))]
    }
    
    struct HeaderText : Style {
        var propertyStylers = [
            font.set(value: .systemFont(ofSize: 20.0)),
            textColor.set(value: .darkGray),
            textAlignment.set(value: .left)
        ]
    }
    
    struct BodyText : Style {
        var propertyStylers = [
            font.set(value:  .systemFont(ofSize: 16.0)),
            textColor.set(value: .gray),
            textAlignment.set(value: .left)
        ]
    }
    
    struct ThemeDescription : Style {
        var propertyStylers = [text.set(value: "Everything on this screen is configured entirely through styles. The styles specify images, fonts, text, button styles, and more. The styles are previewed and updated live inside the storyboard, so this screen looks the same at design time and runtime.")]
    }
    
    struct DefaultProgressBar : Style {
        var propertyStylers = [
            progressColor.set(value: .gray),
            progressTrackColor.set(value: UIColor(white: 0.9, alpha: 1.0)),
            progressCornerRadiusRatio.set(value: 0.16),
            cornerRadiusRatio.set(value: 0.16),
            borderWidth.set(value: 1.0),
            borderColor.set(value: .gray)
            ]
    }
    
    struct DefaultButton : Style {
        var propertyStylers = [
            titleColorForNormalState.set(value: UIColor(red:0.21, green:0.29, blue:0.36, alpha:1.0)),
            titleColorForHighlightedState.set(value: UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)),
            titleColorForDisabledState.set(value: UIColor(red:0.18, green:0.24, blue:0.31, alpha:1.0)),
            cornerRadiusRatio.set(value: 0.16),
            borderWidth.set(value: 1.0),
            borderColor.set(value: UIColor(red:0.21, green:0.29, blue:0.36, alpha:1.0)),
            backgroundColor.set(value: UIColor(white: 0.82, alpha: 1.0))
        ]
    }
    
    struct StylesheetTitle : Style {
        var propertyStylers = [text.set(value: "Graphite")]
    }
    
    struct ThemeImage : Style {
        var propertyStylers = [image.set(value: UIImage(named: "stone", in:  Bundle(for: ProgressBar.self), compatibleWith: nil))]
    }
}
