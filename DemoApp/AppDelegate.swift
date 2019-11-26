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

struct ColorPalette {
    let primary = Color.black
    let secondary = Color.red
}

struct MyButton: View {

    @Binding var title: String
    @EnvironmentObject var colorPalette: ColorPalette

    var body: View {
        Button(action: { self.title += "😍" }) {
            ZStack {
                Circle()
                    .stroke(colorPalette.primary, lineWidth: 4)
                Text("Tap me")
            }
            .frame(width: 100, height: 100)
        }
    }
}

struct ContentView: View {

    @State var title: String
    @EnvironmentObject var colorPalette: ColorPalette

    var body: View {
        ZStack {
            VStack {
                Text(title).font(.title).padding(50)
                MyButton(title: $title)
            }
        }.accentColor(colorPalette.secondary)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let view = ContentView(title: "Test")
            .environmentObject(ColorPalette())
        
        let viewController = HostingController(view)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController

        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
