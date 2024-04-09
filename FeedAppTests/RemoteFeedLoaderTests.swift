//
//  RemoteFeedLoaderTests.swift
//  RemoteFeedLoaderTests
//
//  Created by Aram Ispiryan on 09.04.24.
//

import XCTest
@testable import FeedApp

class RemoteFeedLoader {
    let client: HTTPClient
    let url: URL

    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSPY: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSPY()
        let url = URL(string: "https://google.com")!

        _ = RemoteFeedLoader(client: client, url: url)

        XCTAssertNil(client.requestedURL)
    }

    func test_init_requestDataFromURL() {
        let client = HTTPClientSPY()
        let url = URL(string: "https://google.com")!

        let sut = RemoteFeedLoader(client: client, url: url)

        sut.load()

        XCTAssertEqual(url, client.requestedURL)
    }
}
