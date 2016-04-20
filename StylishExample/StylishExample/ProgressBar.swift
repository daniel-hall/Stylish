//
//  ProgressBar.swift
//  FrameworkTest
//
//  Created by Daniel Hall on 3/20/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation
import UIKit


extension StyleClass {
    var progressColor:UIColor? { get { return getValue(#function) } }
    var progressTrackColor:UIColor? { get { return getValue(#function) } }
    var progressCornerRadiusPercentage:CGFloat? { get { return getValue(#function) } }
}

extension MutableStyleClass {
    var progressColor:UIColor? { get { return getValue(#function) } set { setValue(newValue, forProperty: #function) } }
    var progressTrackColor:UIColor? { get { return getValue(#function) } set { setValue(newValue, forProperty: #function) } }
    var progressCornerRadiusPercentage:CGFloat? { get { return getValue(#function) } set { setValue(newValue, forProperty: #function) } }
}


@IBDesignable class ProgressBar:UIView, Styleable {
    
    class var StyleApplicators: [StyleApplicator] {
        return StyleableUIView.StyleApplicators + [{
            (style:StyleClass, target:Any) in
            if let progressBar = target as? ProgressBar {
                progressBar.trackView.layer.cornerRadius = progressBar.layer.cornerRadius
                progressBar.progressColor =? style.progressColor
                progressBar.trackColor =? style.progressTrackColor
                progressBar.progressCornerRadiusPercentage =? style.progressCornerRadiusPercentage
            }
            }]
    }
    
    private let trackView = UIView()
    private let progressView = UIView()
    
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
    
    override func layoutSubviews() {
        self.trackView.frame = self.bounds
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
        showErrorIfInvalidStyles()
    }
}

