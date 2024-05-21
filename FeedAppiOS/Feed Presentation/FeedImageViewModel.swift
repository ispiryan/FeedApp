//
//  FeedImageViewModel.swift
//  FeedAppiOS
//
//  Created by Aram Ispiryan on 16.05.24.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
