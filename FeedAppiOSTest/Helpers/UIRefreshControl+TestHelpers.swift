//
//  UIRefreshControl+TestHelpers.swift
//  FeedAppiOSTests
//
//  Created by Aram Ispiryan on 15.05.24.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}