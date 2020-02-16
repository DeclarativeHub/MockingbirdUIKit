//
//  ContentView.swift
//  DemoApp
//
//  Created by Srdan Rasic on 07/12/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import Mockingbird
import MockingbirdUIKit
import ReactiveKit
import MapKit

typealias Published = ReactiveKit.Published
typealias ObservableObject = ReactiveKit.ObservableObject

struct CircleImage: View {

    var body: View {
        Image("turtlerock")
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }

}

struct MapView: UIViewRepresentable {

    var coordinate = CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868)

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        guard abs(coordinate.latitude - view.centerCoordinate.latitude) > 0.1
            || abs(coordinate.longitude - view.centerCoordinate.longitude) > 0.1 else { return }
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: false)
    }
}

class ViewModel: ObservableObject {

    @Published
    var counter: Int = 0
    
}


struct ContentView: View {

    @State var value: Float = 50

    @ObservedObject var viewModel = ViewModel()

    var body: View {
        VStack {
            MapView()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)

            ZStack {
                CircleImage()
                Text("\(viewModel.counter)").font(.system(size: 80)).foregroundColor(.white)
            }
            .onTapGesture {
                self.viewModel.counter += 1
            }
            .offset(y: -130)
            .padding(.bottom, -130)

            VStack(alignment: .leading) {
                Text("Turtle Rock")
                    .font(.title)
                HStack(alignment: .top) {
                    Text("Joshua Tree National Park")
                        .font(.subheadline)
                    Spacer()
                    Text("California")
                        .font(.subheadline)
                }
            }
            .padding()
            .foregroundColor(Color(rgb: 0x010120))

            Slider(value: $value, in: 0...100, step: 2)

            Button("Tap me") {
                self.value *= 2
            }.padding()

            Text("\(value)")

            Spacer()
        }
    }
}
