//
//  SharedTestHelpers.swift
//  FeedAppTests
//
//  Created by Aram Ispiryan on 24.04.24.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}


func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
