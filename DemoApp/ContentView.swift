//
//  ContentView.swift
//  DemoApp
//
//  Created by Srdan Rasic on 07/12/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import Mockingbird
import ReactiveKit

typealias Published = ReactiveKit.Published
typealias ObservableObject = ReactiveKit.ObservableObject

struct ColorPalette {
    let primary = Color.black
    let secondary = Color.red
}

class ViewModel: ObservableObject {
    @Published var title: String = "TK"
}

struct MyButton: View {

    @Binding var title: String
    @EnvironmentObject var colorPalette: ColorPalette

    var body: View {
//        Button(action: { self.title += "😍" }) {
            ZStack {
                Circle()
                    .stroke(colorPalette.primary, lineWidth: 4)
                Text("Tap me").font(.system(size: 14, weight: .regular, design: .monospaced))
            }
            .frame(width: 100, height: 100)
            .onLongPressGesture { self.title += "😍" }
            .onTapGesture { self.title += "🥶" }
//        }
    }
}

struct ContentView: View {

    @ObservedObject var viewModel = ViewModel()
    @EnvironmentObject var colorPalette: ColorPalette

    var body: View {
        ZStack {
            VStack {
                ForEach(0..<4) { _ in
                    Text(self.viewModel.title).font(.title)
                }
                MyButton(title: $viewModel.title)
            }
        }.accentColor(colorPalette.secondary)
    }
}
