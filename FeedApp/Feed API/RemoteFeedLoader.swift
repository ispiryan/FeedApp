//
//  RemoteFeedLoader.swift
//  FeedApp
//
//  Created by Aram Ispiryan on 09.04.24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL

    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url     }

    func load() {
        client.get(from: url)
    }
}
