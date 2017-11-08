//
//  Aqua.swift
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

class Aqua : Stylesheet {
    
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
    
    // 3. Here are the specific, nested Style types defined for this Stylesheet. They can be made private, or left internal as below, to allow other Stylesheets to resuse them with their full type identifiers, e.g. 'Aqua.PrimaryBackgroundColor'
    struct PrimaryBackgroundColor : Style {
        var propertyStylers = [UIView.BackgroundColor.set(value: UIColor(red:0.18, green:0.51, blue:0.72, alpha:1.0))]
    }
    
    struct SecondaryBackgroundColor : Style {
        var propertyStylers = [UIView.BackgroundColor.set(value: UIColor(red:0.23, green:0.60, blue:0.85, alpha:1.0))]
    }
    
    struct HeaderText : Style {
        var propertyStylers = [
            UILabel.Font.set(value: UIFont(name: "Futura-Medium", size: 20.0)),
            UILabel.TextColor.set(value: .white),
            UILabel.TextAlignment.set(value: .center)
        ]
    }
    
    struct BodyText : Style {
        var propertyStylers = [
            UILabel.Font.set(value: UIFont(name: "Futura-Medium", size: 16.0)),
            UILabel.TextColor.set(value: .white),
            UILabel.TextAlignment.set(value: .justified)
        ]
    }
    
    struct ThemeDescription : Style {
        var propertyStylers = [UILabel.Text.set(value: "This Aqua theme shows off some additional capabilities. There are rounded corners on elements, and the progress bar has a complex pattern color defined in the style. Even this text is part of a style, and not coded into a view controller or model.")]
    }
    
    struct DefaultProgressBar : Style {
        private static var patternColor: UIColor {
            let context = CIContext()
            let stripesFilter = CIFilter(name: "CIStripesGenerator", withInputParameters: ["inputColor0" : CIColor(color: UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0)), "inputColor1" : CIColor(color: UIColor(red:0.60, green:0.89, blue:0.99, alpha:1.0)), "inputWidth" : 4])!
            let stripes = context.createCGImage(stripesFilter.outputImage!, from: CGRect(origin: CGPoint.zero, size: CGSize(width: 32.0, height: 32.0)))
            let rotateFilter = CIFilter(name: "CIStraightenFilter", withInputParameters: ["inputImage" : CIImage(cgImage: stripes!), "inputAngle" : 2.35])!
            let rotated = context.createCGImage(rotateFilter.outputImage!, from: rotateFilter.outputImage!.extent)
            return UIColor(patternImage: UIImage(cgImage: rotated!))
        }
        var propertyStylers = [
            ProgressBar.ProgressColor.set(value: patternColor),
            ProgressBar.ProgressTrackColor.set(value: .white),
            ProgressBar.ProgressCornerRadiusRatio.set(value: 0.55),
            UIView.CornerRadiusRatio.set(value: 0.55),
            UIView.BorderWidth.set(value: 2.0),
            UIView.BorderColor.set(value: UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0))
        ]
    }
    
    struct DefaultButton : Style {
        var propertyStylers = [
            UIButton.TitleColorForNormalState.set(value: .white),
            UIButton.TitleColorForHighlightedState.set(value: UIColor(red:0.60, green:0.89, blue:0.99, alpha:1.0)),
            UIView.CornerRadiusRatio.set(value: 0.5),
            UIView.BorderColor.set(value: UIColor(red:0.60, green:0.89, blue:0.99, alpha:1.0)),
            UIView.BackgroundColor.set(value: UIColor(red:0.25, green:0.80, blue:0.99, alpha:1.0))
        ]
    }
    
    struct StylesheetTitle : Style {
        var propertyStylers = [UILabel.Text.set(value: "Aqua")]
    }
    
    struct ThemeImage : Style {
        var propertyStylers = [UIImageView.Image.set(value: UIImage(named: "water", in:  Bundle(for: ProgressBar.self), compatibleWith: nil))]
    }
}

