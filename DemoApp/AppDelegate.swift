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
            ZStack {
                Color.yellow.clipShape(Capsule())
                Button("Dismiss") { self.isOn.toggle() }
            }
        }
    }
}

struct ContentView: View {

    @State var spacing: CGFloat = 5
    @State var isOn: Bool = false
    @EnvironmentObject var ud: UserDefaults

    var body: SomeView {
        ScrollView {

            VStack {

                ForEach(0..<5) { _ in

                    VStack(spacing: 10) {

                        // Header
                        HStack {
                            if self.spacing > 10 {
                            Image("turtlerock")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                            }

                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Benjamin Leander")
                                        .bold()
                                    Text("I dag 14:35")
                                }
                                Text("Har opnået et nyt trofæ")
                            }

                            Spacer()

                            ZStack {

                                Text("😅")
                                    .padding(.init(top: 2, leading: 8, bottom: 2, trailing: 8))
                                    .background(
                                        Color.white
                                            .clipShape(Capsule())
                                            .shadow(radius: 4)
                                    )
                                    .onTapGesture {
                                        self.spacing += 10
                                    }
                            }

                        }

                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray)
                                .frame(height: 20, alignment: .center)

                            Text("Skriv en kommentar").padding()

                            VStack {
                                ForEach(0..<5) { _ in
                                    ZStack {
                                        Color.red
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 3)
                    .padding()

                }
            }.padding()
        }
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        window.rootViewController = HostingController(
            rootView: ContentView().environmentObject(UserDefaults.standard)
        )
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
