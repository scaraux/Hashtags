//
//  HashtagCollectionViewCell.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/8/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import Foundation
import UIKit

open class HashtagCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "HashtagCollectionViewCell"
    
    var paddingLeftConstraint: NSLayoutConstraint?
    var paddingRightConstraint: NSLayoutConstraint?
    var paddingTopConstraint: NSLayoutConstraint?
    var paddingBottomConstraint: NSLayoutConstraint?
    
    lazy var wordLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    open var hashtag: HashTag?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open func setup() {
        self.clipsToBounds = true
        
        self.addSubview(wordLabel)
        
        // Padding left
        self.paddingLeftConstraint = self.wordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.paddingLeftConstraint!.isActive = true
        // Padding top
        self.paddingTopConstraint = self.wordLabel.topAnchor.constraint(equalTo: self.topAnchor)
        self.paddingTopConstraint!.isActive = true
        // Padding bottom
        self.paddingBottomConstraint = self.wordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.paddingBottomConstraint!.isActive = true
        // Padding right
        self.paddingRightConstraint = self.wordLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        self.paddingRightConstraint!.isActive = true
    }
    
    open override func prepareForInterfaceBuilder() {
        self.wordLabel.text = ""
        super.prepareForInterfaceBuilder()
    }
    
    open func configureWithTag(tag: HashTag, configuration: HashtagConfiguration) {
        self.hashtag = tag
        wordLabel.text = tag.text
        
        self.paddingLeftConstraint!.constant = configuration.paddingLeft
        self.paddingTopConstraint!.constant = configuration.paddingTop
        self.paddingBottomConstraint!.constant = -1 * configuration.paddingBottom
        self.paddingRightConstraint!.constant = -1 * configuration.paddingRight

        self.layer.cornerRadius = configuration.cornerRadius
        self.backgroundColor = configuration.backgroundColor
        
        self.wordLabel.textColor = configuration.textColor
        self.wordLabel.font = UIFont.systemFont(ofSize: configuration.textSize)
    }
}
