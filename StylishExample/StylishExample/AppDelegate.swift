//
//  AppDelegate.swift
//  StylishExample
//
//  Created by Hall, Daniel on 8/11/17.
//  Copyright © 2017 Hall, Daniel. All rights reserved.
//

import UIKit
import Stylish

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        Stylish.stylesheet = Graphite()
        return true
    }
}

