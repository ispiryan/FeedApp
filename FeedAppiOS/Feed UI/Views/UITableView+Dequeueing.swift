//
//  UITableView+Dequeueing.swift
//  FeedAppiOS
//
//  Created by Aram Ispiryan on 07.06.24.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell> () -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
