//
//  ProgressBar.swift
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



/*
 This is a custom progress bar view, which demonstrates how to make any UIView subclass participate in the Stylish process
*/


import Foundation
import UIKit


// 1. Define a Property Set that conforms to StylePropertySet in order to make the styleable properties of your custom view available to style classes.

// DynamicStylePropertySet is a protocol that inherits from StylePropertySet and exposes an additional mutating method that allows JSON-based or other dynamically parsed stylesheets to set the style properties based on string keys.

struct ProgressBarPropertySet : DynamicStylePropertySet {
    var progressColor:UIColor?
    var trackColor:UIColor?
    var cornerRadiusPercentage:CGFloat?
    
    // DynamicStylePropertySet conformanace, allows properties to be set using their string names as keys
    mutating func setStyleProperty<T>(named name: String, toValue value: T) {
        switch name {
        case _ where name.isVariantOf("Progress Color"):
            progressColor = value as? UIColor
        case _ where name.isVariantOf("Track Color"):
            trackColor = value as? UIColor
        case _ where name.isVariantOf("Corner Radius Percentage"):
            cornerRadiusPercentage = value as? CGFloat
        default :
            return
        }
    }
}

// 2. Extend StyleClass to include your custom view's property set as a gettable / settable property. The 'retrieve' and 'register' methods fetch and add the property set to a collection on the style class

extension StyleClass {
    var ProgressBar:ProgressBarPropertySet { get { return self.retrieve(ProgressBarPropertySet.self) } set { self.register(newValue) } }
}


// 3. Mark your custom view class as @IBDesignable and declare conformance to the Styleable protocol

@IBDesignable class ProgressBar:UIView, Styleable {
    
    // 4. The styleable protocol requires you to provide an array of atyle application closures (StyleApplicators) that know how to apply the properties from a style to your view.  Make sure to include in this array, the style applicators for any superclasses, which should usually be applied first.  That is why this variable returns the array of StyleableUIView.StyleApplicators + the applicator for this custom class
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let progressBar = target as? ProgressBar {
                progressBar.trackView.layer.cornerRadius = progressBar.layer.cornerRadius
                
                // In general, you probably only want to use the property from the style if is actually defined / non-nil. You don't want to overwrite all your view properties with nil just because they weren't defined in the style and appear there as nil.  Here is where the custom operator =? comes into play. It works by only setting the property on the left to the value on the right if that value is non-nil. If the value on the right is nil, nothing is done.
                
                progressBar.progressColor =? style.ProgressBar.progressColor
                progressBar.trackColor =? style.ProgressBar.trackColor
                progressBar.progressCornerRadiusPercentage =? style.ProgressBar.cornerRadiusPercentage
            }
            }]
    }
    
    fileprivate let trackView = UIView()
    fileprivate let progressView = UIView()

    
// 5. Add @IBInspectable properties for 'styles' and 'stylesheet' to make these available for setting in storyboards. They should call the extension method 'parseAndApplyStyles' whenever either value is changed, as shown below.
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
    @IBInspectable var stylesheet:String = "" {
        didSet {
            parseAndApplyStyles()
        }
    }
    
// 6. In order to get the special tinting of views when an invalid style is specified, override 'prepareForInterfaceBuilder()' and call 'showErrorIfInvalidStyles()'  That's it!  Your custom view is now a full participant in Stylish themeing. Next step to create some StyleClasses that set properties on your custom view inside a Stylesheet.
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles()
    }
    
    var progressColor:UIColor = UIColor.gray {
        didSet {
            progressView.backgroundColor = progressColor
        }
    }
    
    var trackColor:UIColor = UIColor.white {
        didSet {
            trackView.backgroundColor = trackColor
        }
    }
    
    var progressCornerRadiusPercentage:CGFloat = 0.0 {
        didSet {
            updateProgress()
            progressView.layer.cornerRadius = progressView.bounds.height * progressCornerRadiusPercentage
        }
    }
    
    @IBInspectable var progress:CGFloat = 0.5 {
        didSet {
            updateProgress()
        }
    }
    
    override func layoutSubviews() {
        updateProgress()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        trackView.backgroundColor = trackColor
        progressView.backgroundColor = progressColor
        trackView.frame = bounds
        progressView.frame = bounds
        addSubview(trackView)
        addSubview(progressView)
        updateProgress()
        layer.masksToBounds = true
        trackView.layer.masksToBounds = true
        progressView.layer.masksToBounds = true
        clipsToBounds = true
    }
    
    fileprivate func updateProgress() {
        self.trackView.frame = self.bounds
        progressView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: trackView.bounds.width * progress, height: trackView.bounds.height))
    }
}

