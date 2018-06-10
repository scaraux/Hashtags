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
        btn.imageView?.contentMode = .center
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
        
        self.wordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        self.wordLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.wordLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        
        self.removeButton.leadingAnchor.constraint(equalTo: self.wordLabel.trailingAnchor, constant: 0.0).isActive = true
        self.removeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.removeButton.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.removeButton.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.removeButton.addTarget(self, action: Selector.removeButtonClicked, for: .touchUpInside)
    }
    
    open func configureWithTag(tag: HashTag) {
        self.hashtag = tag
        wordLabel.text = tag.text
    }
    
    @objc
    func onRemoveButtonClicked(_ sender: UIButton) {
        guard let hashtag = self.hashtag else {
            return
        }
        self.delegate?.hashtagRemoved(hashtag: hashtag)
    }
}
