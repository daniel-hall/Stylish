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


import Stylish
import UIKit

// 1. Create a custom view class marked as @IBDesignable and declare conformance to the Styleable protocol

@IBDesignable class ProgressBar:UIView, Styleable {
    
    // 2. Create custom PropertyStylers that define a property key that can be read out of json, and a way to set the styleable properties of the ProgressBar component. These can be private to the type if you are only using JSON stylesheets and no code-created stylesheets
    struct ProgressColor: PropertyStyler {
        static var propertyKey: String { return "progressColor" }
        static func apply(value: UIColor?, to target: ProgressBar, using bundle: Bundle) {
            target.progressColor = value ?? .gray
        }
    }
    
    struct ProgressTrackColor: PropertyStyler {
        static var propertyKey: String { return "progressTrackColor" }
        static func apply(value: UIColor?, to target: ProgressBar, using bundle: Bundle) {
            target.trackColor = value ?? .white
        }
    }
    
    struct ProgressCornerRadiusRatio: PropertyStyler {
        static var propertyKey: String { return "progressCornerRadiusRatio" }
        static func apply(value: CGFloat?, to target: ProgressBar, using bundle: Bundle) {
            target.progressCornerRadiusPercentage = value ?? 0
        }
    }
    
    // 3. Expose all the PropertyStylers as an array that can be passed into JSONStylesheet during initialization so they can participate in the parsing process
    static var propertyStylers: [AnyPropertyStylerType.Type] { return [ProgressColor.self, ProgressTrackColor.self, ProgressCornerRadiusRatio.self]  }
    
    fileprivate let trackView = UIView()
    fileprivate let progressView = UIView()

    
    // 4. The Styleable protocol only requires a styles property, create one and mark it as @IBInspectable to make it available for setting in storyboards. It should call Stylish.applyStyleNames(:to:) whenever value is changed, as shown below.
    
    @IBInspectable var styles:String = "" {
        didSet {
            updateProgress()
            Stylish.applyStyleNames(styles, to: self, using: stylesheet)
        }
    }
    @IBInspectable public var stylesheet: String? = nil {
        didSet {
            updateProgress()
            Stylish.applyStyleNames(styles, to: self, using: stylesheet)
        }
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
            trackView.layer.cornerRadius = progressView.layer.cornerRadius
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

// 5. Optionally, add a convenience typealias to the Style protocol, so any style can reference simply: "progressColor.set(value:)" instead of "ProgressBar.ProgressColor.set(value:)"

extension Style {
    /// Sets a color value for the filled-in part of a ProgressBar instance
    typealias progressColor = ProgressBar.ProgressColor
    /// Sets a color value for the background track part of a ProgressBar instance
    typealias progressTrackColor = ProgressBar.ProgressTrackColor
    /// Sets a ratio of corner radius to height for the filled in progress part of a ProgressBar instance
    typealias progressCornerRadiusRatio = ProgressBar.ProgressCornerRadiusRatio
}


