//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import MockingbirdUIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let view = ContentView()
        
        let viewController = HostingController(view)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController

        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
