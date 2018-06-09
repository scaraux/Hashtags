//
//  HashtagCollectionViewCell.swift
//  Outfit
//
//  Created by Oscar Götting on 6/8/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import Foundation
import UIKit

open class HashtagCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "HashtagCollectionViewCell"
    
    lazy var wordLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open func setup() {
        
        self.backgroundColor = UIColor.lightGray
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        
        self.wordLabel.textColor = UIColor.white
        self.wordLabel.textAlignment = .center
        
        self.addSubview(wordLabel)
        
        self.wordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.wordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0).isActive = true
        self.wordLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        self.wordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0).isActive = true
        self.wordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
    }
    
    open func configureWithTag(tag: HashTag) {
        wordLabel.text = tag.text
    }
}
