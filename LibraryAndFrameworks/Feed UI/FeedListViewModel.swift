//
//  FeedListViewModel.swift
//  LibraryAndFrameworks
//
//  Created by Shilpa Bansal on 23/01/21.
//

import Foundation
import FeedContent

class FeedListViewModel {
    let feedContent: FeedContentProtocol?
    
    init(feedContent: FeedContentProtocol) {
        self.feedContent = feedContent
    }
    
    var numberOfFeeds: Int {
        return feedContent?.getFeeds().count ?? 0
    }
    
    func item(at index: Int) -> String? {
        if let feeds = feedContent?.getFeeds(), feeds.count > index {
            return feeds[index]
        }
        return nil
    }
}
