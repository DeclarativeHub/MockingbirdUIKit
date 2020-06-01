//
//  AppDelegate.swift
//  DemoApp
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import ReactiveKit
import Mockingbird
import MockingbirdUIKit

struct TestView: View {

    @State var spacing: CGFloat = 5
    @State var isOn: Bool = false
    @EnvironmentObject var ud: UserDefaults

    var body: SomeView {
        VStack(spacing: spacing) {
            Color.orange.clipShape(Circle()).frame(width: 200, height: 100, alignment: .center)
            VStack {
                ForEach(0..<5) { (id) in
                    Text("Spacing \(id * 10)").onTapGesture {
                        self.spacing = CGFloat(id) * 10
                    }
                }
            }
            Capsule().stroke(Color.green).border(Color.black).padding()
            HStack(spacing: spacing) {
                Text("Hello").padding(20).background(Color.yellow).cornerRadius(10).shadow(radius: 20)
                Text("Hello").background(Color.green)
            }
            Button("Spacing++", action: { self.spacing += 5 }).padding(12).background(Color.red)
            Button("Present sheet") { self.isOn.toggle() }
            Image("turtlerock")
                .resizable()
                .cornerRadius(10)
                .shadow(radius: 20)
                .onTapGesture {
                    self.spacing = 0
                }.onLongPressGesture {
                    self.spacing = 30
            }
        }
        .padding()
        .sheet(isPresented: $isOn) {
            Color.yellow.clipShape(Capsule())
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = HostingController(
            rootView: TestView().environmentObject(UserDefaults.standard)
        )
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
