//
//  RemoteFeedLoaderTests.swift
//  RemoteFeedLoaderTests
//
//  Created by Aram Ispiryan on 09.04.24.
//

import XCTest
@testable import FeedApp

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty )
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://google.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }  

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://google.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        var capturedError: RemoteFeedLoader.Error?

        sut.load { capturedError = $0 }

        let clientError = NSError(domain: "Test", code: 0)
         client.complete(with: clientError)

        XCTAssertEqual(capturedError, .connectivity)
    }

    func test_load_deliversErrorOnNon200HttpResponse() {
        let (sut, client) = makeSUT()

        let samples = [199,201,300,400,500]
        samples.enumerated().forEach { index, code in
            var capturedError: RemoteFeedLoader.Error?
            sut.load { capturedError = $0 }
            client.completeWith(statusCode: code, at: index)
            XCTAssertEqual(capturedError, .invalidData)
        }
    }

    func test_load_deliversErrorOnNon200HttpResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        var capturedErrors = [RemoteFeedLoader.Error]()

        sut.load { capturedErrors.append($0) }

        let invalidJSON = Data("invalidData".utf8)
        client.completeWith(statusCode: 200, data: invalidJSON)

        XCTAssertEqual(capturedErrors, [.invalidData])
    }


    // MARK: Helpers

    private func makeSUT(url: URL = URL(string: "https://google.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSPY) {
        let client = HTTPClientSPY()
        let sut = RemoteFeedLoader(client: client, url: url)

        return (sut, client)
    }
}

private class HTTPClientSPY: HTTPClient {
    private var messages = [(url: URL,
                             completion: (HTTPClientResult) -> Void)]()

    var requestedURLs: [URL] {
        messages.map({ $0.url })
    }

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        messages.append((url, completion))
    }

    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }

    func completeWith(statusCode: Int, data: Data = Data() ,at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index],
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)!
        messages[index].completion(.success(data, response))
    }
}
