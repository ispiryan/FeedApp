//
//  FeedStoreSPY.swift
//  FeedAppTests
//
//  Created by Aram Ispiryan on 24.04.24.
//

import Foundation
import FeedApp

class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCacheFeed
        case insert([LocalFeedImage], Date)
    }

    private(set) var receivedMessages = [ReceivedMessage]()
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()

    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCacheFeed )
    }

    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }

    func completeDeletionSuccessfully( at index: Int = 0) {
        deletionCompletions[index](nil)
    }

    func completeInsertionSuccessfully( at index: Int = 0) {
        insertionCompletions[index](nil)
    }

    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionCompletions[index](error)
    }

    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(feed, timestamp))
        insertionCompletions.append(completion  )
    }
    }
