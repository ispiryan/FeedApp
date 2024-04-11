//
//  RemoteFeedLoader.swift
//  FeedApp
//
//  Created by Aram Ispiryan on 09.04.24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public class RemoteFeedLoader {
    private let client: HTTPClient 
    private let url: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }

    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url     }

    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result  in
            switch result {
            case .success(let data, let response):
                do {
                    let items = try FeedItemsMapper.map(data, response)
                    completion(.success(items))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure(_):
                completion(.failure(.connectivity))
            }
        }
    }
}


private class FeedItemsMapper {

    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let image: URL

        var item: FeedItem {
            FeedItem(id: id,
                     description: description,
                     location: location,
                     imageURL: image)
        }
    }

    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == 200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return try JSONDecoder().decode(Root.self,
                                        from: data).items.map({$0.item})
    }
}
