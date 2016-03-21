//
//  ProgressBar.swift
//  FrameworkTest
//
//  Created by Daniel Hall on 3/20/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation
import UIKit

extension Stylish {
    
    struct ProgressBar {
        
        static var ProgressColor:Properties.ProgressColor.Type { get { return Properties.ProgressColor.self } }
        static var TrackColor:Properties.TrackColor.Type { get { return Properties.TrackColor.self } }
        static var ProgressCornerRadiusPercentage:Properties.ProgressCornerRadiusPercentage.Type { get { return Properties.ProgressCornerRadiusPercentage.self } }
        
        struct Properties {
            struct ProgressColor:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct TrackColor:StyleProperty {
                let value:UIColor
                init(value:UIColor) {
                    self.value = value
                }
            }
            struct ProgressCornerRadiusPercentage:StyleProperty {
                let value:CGFloat
                init(value:CGFloat) {
                    self.value = value
                }
            }
        }
    }
}

@IBDesignable class ProgressBar:UIView, Styleable {
    
    private let trackView = UIView()
    private let progressView = UIView()
    
    @IBInspectable var styles:String = "" {
        didSet {
            parseAndApplyStyles(styles)
        }
    }
    
    var progressColor:UIColor = UIColor.grayColor() {
        didSet {
            progressView.backgroundColor = progressColor
        }
    }
    
    var trackColor:UIColor = UIColor.whiteColor() {
        didSet {
            trackView.backgroundColor = trackColor
        }
    }
    
    var progressCornerRadiusPercentage:CGFloat = 0.0 {
        didSet {
            progressView.layer.cornerRadius = progressView.bounds.height * progressCornerRadiusPercentage
        }
    }
    
    @IBInspectable var progress:CGFloat = 0.5 {
        didSet {
            updateProgress()
        }
    }
    
    override var frame:CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            self.trackView.frame = self.bounds
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
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
    }
    
    private func updateProgress() {
        progressView.frame = CGRect(origin: CGPointZero, size: CGSize(width: trackView.bounds.width * progress, height: trackView.bounds.height))
    }
    
    override func prepareForInterfaceBuilder() {
        showErrorIfInvalidStyles(styles)
    }
    
    func applyStyle(style: Style) {
        Stylish.UIView.ApplyStyle(style, toView: self)
        trackView.layer.cornerRadius = layer.cornerRadius
        progressColor = style.valueFor(Stylish.ProgressBar.ProgressColor) ?? progressColor
        trackColor = style.valueFor(Stylish.ProgressBar.TrackColor) ?? trackColor
        progressCornerRadiusPercentage = style.valueFor(Stylish.ProgressBar.ProgressCornerRadiusPercentage) ?? progressCornerRadiusPercentage
    }
}

