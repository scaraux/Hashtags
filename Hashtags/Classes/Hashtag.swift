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

open class HashTag: Equatable {
    
    open var text: String
    open var isRemovable: Bool
    open var hasHashSymbol: Bool
    open var configuration: HashtagConfiguration?
    
    public init(word: String, withHashSymbol: Bool = true, isRemovable: Bool = false) {
        self.text = word
        self.isRemovable = isRemovable
        self.hasHashSymbol = withHashSymbol
        
        if hasHashSymbol {
            self.text = "#" + text
        }
    }
    
    public static func == (lhs: HashTag, rhs: HashTag) -> Bool {
        return lhs.text == rhs.text
    }
}
