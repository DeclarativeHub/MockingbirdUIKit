//
//  HostingViewController.swift
//  MockingbirdUIKit
//
//  Created by Srdan Rasic on 24/11/2019.
//  Copyright © 2019 Declarative Hub. All rights reserved.
//

import UIKit
import Mockingbird

public class HostingController: UIViewController {

    public let hostingView: HostingView

    public init(_ view: View) {
        self.hostingView = HostingView(view)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = hostingView
        view.backgroundColor = .white
    }
}
