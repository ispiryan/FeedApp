//
//  FeedLoader.swift
//  FeedApp
//
//  Created by Aram Ispiryan on 09.04.24.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
