//
//  Hashtag.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/6/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    @discardableResult mutating func remove(object: Element) -> Bool {
        if let index = index(of: object) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    @discardableResult mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
        if let index = self.index(where: { (element) -> Bool in
            return predicate(element)
        }) {
            self.remove(at: index)
            return true
        }
        return false
    }
}

@objc open class HashTag: NSObject {
    
    open var text: String
    open var isRemovable: Bool = true;
    open var hasHashSymbol: Bool = true;
    open var isGoldTag : Bool = false
    open var configuration: HashtagConfiguration?
    
    @objc public init(word: String, isGoldTag: Bool = false) {
        self.text = word
        self.isGoldTag = isGoldTag
        if self.hasHashSymbol && word.hasPrefix("#") == false {
            self.text = "#" + text
        }
    }
    
    public static func == (lhs: HashTag, rhs: HashTag) -> Bool {
        return lhs.text == rhs.text
    }
}
