//
//  UIImage+TestHelpers.swift
//  FeedAppiOS
//
//  Created by Aram Ispiryan on 15.05.24.
//

import UIKit

extension UIImage {
    static func make(withColor color: UIColor = .black, height: CGFloat = 1) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: height)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1

        return UIGraphicsImageRenderer(size: rect.size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(rect)
        }
    }
}
