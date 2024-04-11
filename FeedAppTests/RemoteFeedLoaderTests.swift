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
        
        expect(sut, toCompleteWithResult: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }

    func test_load_deliversErrorOnNon200HttpResponse() {
        let (sut, client) = makeSUT()
        let samples = [199,20 ,300,400,500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithResult: .failure(.invalidData)) {
                let jsonData = makeItemsJSON([])
                client.completeWith(statusCode: code, data: jsonData, at: index)
            }
        }
    }

    func test_load_deliversErrorOn200HttpResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .failure(.invalidData), when: {
            let invalidJSON = Data("invalidData".utf8)
            client.completeWith(statusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversNoItemsOn200HttpResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWithResult: .success([])) {
            let emptyJSON = makeItemsJSON([]) 
            client.completeWith(statusCode: 200, data: emptyJSON)
        } 
    }

    func test_load_deliversItemsOn200HttpResponseWithJsonItems() {
        let (sut, client) = makeSUT()

        let (item1, json1) = makeItem(id: UUID(),
                             imageURL: URL(string: "https://1.io")!)

        let (item2, json2) = makeItem(id: UUID(),
                                       description: "description",
                                       location: "location",
                                       imageURL: URL(string: "https://2.io")!)
        expect(sut,
               toCompleteWithResult: .success([item1, item2])) {
            let data = makeItemsJSON([json1 , json2])
            client.completeWith(statusCode: 200, data: data)
        }
    }

    // MARK: Helpers

    private func makeSUT(url: URL = URL(string: "https://google.com")!) -> (sut: RemoteFeedLoader, 
                                                                            client: HTTPClientSPY) {
        let client = HTTPClientSPY()
        let sut = RemoteFeedLoader(client: client, url: url)

        return (sut, client)
    }

    private func expect(_ sut: RemoteFeedLoader, 
                        toCompleteWithResult result: RemoteFeedLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }

        action()

        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }

    private func makeItem(id: UUID,
                          description: String? = nil,
                          location: String? = nil,
                          imageURL: URL) -> (model: FeedItem, json: [String: Any]) {

        let item = FeedItem(id: id,
                            description: description,
                            location: location,
                            imageURL: imageURL)
        let json = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.imageURL.absoluteString
        ]

        return (item, json as [String : Any])
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["items" : items]
        return try! JSONSerialization.data(withJSONObject: json)
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

    func completeWith(statusCode: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: requestedURLs[index],
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)!
        messages[index].completion(.success(data, response))
    }
}
