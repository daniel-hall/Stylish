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
    open override func prepareForInterfaceBuilder() {
        //Stylish.appBundle = Bundle(for: AppDelegate.self)
        Stylish.customDynamicPropertySets = [ProgressBarPropertySet.self]
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // Stylish.appBundle = Bundle(for: AppDelegate.self)
       // Stylish.customDynamicPropertySets = [ProgressBarPropertySet.self]
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

