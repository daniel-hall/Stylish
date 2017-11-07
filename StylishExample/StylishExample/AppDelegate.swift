//
//  AppDelegate.swift
//  StylishExample
//
//  Created by Hall, Daniel on 8/11/17.
//  Copyright © 2017 Hall, Daniel. All rights reserved.
//

import UIKit
import Stylish

extension UIView {
    // This is the only entry point for setting global variables in Stylish for Interface Builder rendering (since App Delegate doesn't get run by IBDesignable. So we are setting up the same global variable here so they are also available during live previews on Storyboards
    open override func prepareForInterfaceBuilder() {
        Stylish.stylesheet = Graphite()
    }
}

extension StyleableUIView {
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Stylish.stylesheet = Graphite()

        //Remove the following code if you want to dynamically download and cache a stylesheet from the web.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let filename = documentsDirectory + "stylesheet.json"
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: filename)
        }
        catch { }
        
        return true
    }
}

