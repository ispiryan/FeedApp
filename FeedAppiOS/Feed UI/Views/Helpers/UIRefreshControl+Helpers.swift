//
//  UIRefreshControl+Helpers.swift
//  FeedAppiOS
//
//  Created by Aram Ispiryan on 18.06.24.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
