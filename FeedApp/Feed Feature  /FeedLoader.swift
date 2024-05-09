//
//  FeedLoader.swift
//  FeedApp
//
//  Created by Aram Ispiryan on 09.04.24.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
