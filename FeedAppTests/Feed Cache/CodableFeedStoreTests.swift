//
//  CodableFeedStoreTests.swift
//  FeedAppTests
//
//  Created by Aram Ispiryan on 26.04.24.
//

import XCTest
import FeedApp


class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableFeedStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for retrieve.")

        sut.retrieve { result in
            switch result {
            case .empty:
                break;
            default:
                XCTFail("Expected empty result, got \(result) instead.")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
