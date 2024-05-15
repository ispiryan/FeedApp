//
//  UIButton+TestHelpers.swift
//  FeedAppiOSTests
//
//  Created by Aram Ispiryan on 15.05.24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
