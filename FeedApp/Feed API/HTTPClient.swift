//
//  HTTPClient.swift
//  FeedApp
//
//  Created by Aram Ispiryan on 13.04.24.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}
