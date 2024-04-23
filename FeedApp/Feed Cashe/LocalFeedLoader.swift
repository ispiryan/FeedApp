//
//  LocalFeedLoader.swift
//  FeedApp
//
//  Created by Aram Ispiryan on 23.04.24.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
}

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    public func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self else { return }

            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items: items, with: completion)
            }
        }
    }

    private func cache(items: [FeedItem], with completion: @escaping (Error?) -> Void) {
        store.insert(items, timestamp: self.currentDate(), completion: { [weak self] error in
            guard self != nil else { return }
            completion(error)
        })
    }
}
