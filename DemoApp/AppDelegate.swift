//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird
import MockingbirdUIKit

@available(iOS 13, *)
struct VV: View {

    @State var n: CGFloat = 0.5

    var body: some View {
        VStack {
            Text("\(n)")
            Slider(value: $n)
            GeometryReader { _ in
                Text("GR")
            }
        }
    }
}

@available(iOS 13, *)
struct V: View {

    var body: SomeView {
        VStack {
            Text("Hello")
            HStack {
                Text("Hello")
                Text("Hello")
            }
            Image("turtlerock").padding(33)//.shadow(radius: 20)
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        if #available(iOS 13, *) {
            let viewController = HostingController(V())
            window.rootViewController = viewController
        }

        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
