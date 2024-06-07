//
//  FeedImageCell+TestHelpers.swift
//  FeedAppiOSTests
//
//  Created by Aram Ispiryan on 15.05.24.
//

import UIKit
import FeedAppiOS

extension FeedImageCell {

    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }

    var isShowingImageLoadingIndicator: Bool {
        return feedImageContainer.isShimmering
    }

    var isShowingLocation: Bool {
        return !locationContainer.isHidden
    }

    var isShowingRetryAction: Bool {
        return !feedImageRetryButton.isHidden
    }

    var locationText: String? {
        return locationLabel.text
    }

    var descriptionText: String? {
        return descriptionLabel.text
    }

    var renderedImage: Data? {
        return feedImageView.image?.pngData()
    }
}
