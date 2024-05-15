//
//  UIRefreshControl+TestHelpers.swift
//  FeedAppiOSTests
//
//  Created by Aram Ispiryan on 15.05.24.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
