//
//  FeedErrorViewModel.swift
//  FeedAppiOS
//
//  Created by Aram Ispiryan on 18.06.24.
//


struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}
