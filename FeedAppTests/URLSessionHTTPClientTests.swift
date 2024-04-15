//
//  URLSessionHTTPClientTests.swift
//  FeedAppTests
//
//  Created by Aram Ispiryan on 15.04.24.
//

import XCTest
@testable import FeedApp


class URLSessionHttpClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(from: URL, completion: @escaping  (HTTPClientResult) -> Void) {
        session.dataTask(with: from) { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_resumesDataTaskWithURL() {
        URLProtocolStub.startIntersectingRequest()

        let url = URL(string: "https://any-url.com")!

        let error = NSError(domain: "test", code: 1)
        let sut = URLSessionHttpClient()

        let exp = expectation(description: "Wait for completion!")

        URLProtocolStub.stub(withURL: url, data: nil, response: nil, error: error)

        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(error.code, receivedError.code )
            default:
                XCTFail("Expected pizdec!")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        URLProtocolStub.stopIntersectingRequest()
    }
}


private class URLProtocolStub: URLProtocol {
    private static var stubs = [URL: Stub]()

    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }

    static func stub(withURL: URL, data: Data?, response: URLResponse?, error: NSError? ) {
        stubs[withURL] = Stub(data: data, response: response, error: error)
    }

    static func startIntersectingRequest() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    static func stopIntersectingRequest() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stubs = [:]
    }

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }

        return stubs[url] != nil
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }

        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
