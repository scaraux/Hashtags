//
//  RemovableHashtagCollectionViewCell.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/8/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import Foundation
import UIKit

fileprivate extension Selector {
    static let removeButtonClicked: Selector = #selector(RemovableHashtagCollectionViewCell.onRemoveButtonClicked(_:))
}

open class RemovableHashtagCollectionViewCell: UICollectionViewCell {
    
    var paddingLeftConstraint: NSLayoutConstraint?
    var paddingRightConstraint: NSLayoutConstraint?
    var removeButtonHeightConstraint: NSLayoutConstraint?
    var removeButtonWidthConstraint: NSLayoutConstraint?
    var removeButtonSpacingConstraint: NSLayoutConstraint?
    
    static let cellIdentifier = "RemovableHashtagCollectionViewCell"
    
    lazy var wordLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    var removeButton : UIButton = {
        let btn = UIButton()
        let bundle = Bundle(for: RemovableHashtagCollectionViewCell.self)
        let removeIcon = UIImage(named: "close", in: bundle, compatibleWith: nil)!.scaleImageToFitSize(size: CGSize(width: 10.0, height: 10.0))
        btn.setImage(removeIcon, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.imageView?.tintColor = UIColor.black.withAlphaComponent(0.9)
        return btn
    }()
    
    open var delegate: HashtagViewDelegate?
    open var hashtag: HashTag?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        self.backgroundColor = UIColor.lightGray
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        
        self.wordLabel.textColor = UIColor.white
        self.wordLabel.textAlignment = .center
        
        self.addSubview(wordLabel)
        self.addSubview(removeButton)

        self.wordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Padding left
        self.paddingLeftConstraint = self.wordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0)
        self.paddingLeftConstraint!.isActive = true
        
        // Text width
        self.wordLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        
        // Center Y alignment
        self.wordLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.removeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // Remove button spacing
        self.removeButtonSpacingConstraint = self.removeButton.leadingAnchor.constraint(equalTo: self.wordLabel.trailingAnchor, constant: 0.0)
        self.removeButtonSpacingConstraint!.isActive = true
        
        // Remove button width
        self.removeButtonWidthConstraint = self.removeButton.widthAnchor.constraint(equalToConstant: 0.0)
        self.removeButtonWidthConstraint!.isActive = true

        // Remove button height
        self.removeButtonHeightConstraint = self.removeButton.heightAnchor.constraint(equalTo: self.wordLabel.heightAnchor)
        self.removeButtonHeightConstraint!.isActive = true
        
        // Remove button target
        self.removeButton.addTarget(self, action: Selector.removeButtonClicked, for: .touchUpInside)
    }
    
    open func configureWithTag(tag: HashTag, configuration: HashtagConfiguration) {
        self.hashtag = tag
        wordLabel.text = tag.text

        self.paddingLeftConstraint!.constant = configuration.paddingLeft
        self.removeButtonWidthConstraint!.constant = configuration.closeIconSize
        self.removeButtonSpacingConstraint!.constant = configuration.closeIconSpacing
    }
    
    @objc
    func onRemoveButtonClicked(_ sender: UIButton) {
        guard let hashtag = self.hashtag else {
            return
        }
        self.delegate?.hashtagRemoved(hashtag: hashtag)
    }
}
