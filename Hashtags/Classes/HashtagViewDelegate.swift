//
//  HashtagViewDelegate.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/9/18.
//

import Foundation

public protocol HashtagViewDelegate: class {
    func hashtagRemoved(hashtag: HashTag)
    func viewShouldResizeTo(size: CGSize)
}
