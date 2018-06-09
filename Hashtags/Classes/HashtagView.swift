//
//  HashtagView.swift
//  Outfit
//
//  Created by Oscar Götting on 6/6/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import UIKit

public protocol HashtagViewDelegate {
    func hashtagRemoved(hashtag: HashTag)
}

// MARK: Class

@IBDesignable
open class HashtagView: UIView {
    
    private var sizingLabel = UILabel(frame: .zero)

    @IBOutlet weak var height: NSLayoutConstraint?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        return view
    }()

    public var hashtags: [HashTag] = []
    
    @IBInspectable
    open var animationDuration: TimeInterval = 0.4

    @IBInspectable
    open var shouldBeHiddenWhenEmpty: Bool = true

    @IBInspectable
    open var animateViewHeightChanged: Bool = true
    
    @IBInspectable
    open var viewBackgroundColor: UIColor? {
        didSet {
            setup()
        }
    }

    @IBInspectable
    open var cornerRadius: CGFloat = 5.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var horizontalTagSpacing: CGFloat = 7.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var  verticalTagSpacing: CGFloat = 5.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var  containerPaddingLeft: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var  containerPaddingRight: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var  containerPaddingTop: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    public var  containerPaddingBottom: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.shouldBeHiddenWhenEmpty = false
        self.animateViewHeightChanged = false
        self.addTag(tag: HashTag(word: "hashtag"))
        self.addTag(tag: HashTag(word: "RemovableHashtag", isRemovable: true))
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let height: CGFloat = self.collectionView.collectionViewLayout.collectionViewContentSize.height
//        self.height?.constant = height
//    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }

    func setup() {
        self.backgroundColor = self.viewBackgroundColor ?? UIColor.white
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius
        
        if self.shouldBeHiddenWhenEmpty == true {
            self.height?.constant = 0.0
        }

        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        alignedFlowLayout.minimumLineSpacing = self.horizontalTagSpacing
        alignedFlowLayout.minimumInteritemSpacing = self.verticalTagSpacing
        alignedFlowLayout.sectionInset = UIEdgeInsets(top: self.containerPaddingTop,
                                                      left: self.containerPaddingLeft,
                                                      bottom: self.containerPaddingBottom,
                                                      right: self.containerPaddingRight)

        self.collectionView.collectionViewLayout = alignedFlowLayout

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.backgroundColor
        self.collectionView.isScrollEnabled = false
        
        self.collectionView.register(HashtagCollectionViewCell.self,
                                     forCellWithReuseIdentifier: HashtagCollectionViewCell.cellIdentifier)
        self.collectionView.register(RemovableHashtagCollectionViewCell.self,
                                     forCellWithReuseIdentifier: RemovableHashtagCollectionViewCell.cellIdentifier)
       
        self.collectionView.removeFromSuperview()
        self.addSubview(self.collectionView)
    }
}

extension HashtagView {

    open func addTag(tag: HashTag) {
        self.hashtags.append(tag)
        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()

        self.height?.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        
        if self.animateViewHeightChanged {
            UIView.animate(withDuration: self.animationDuration) {
                self.superview?.layoutIfNeeded()
            }
        } else {
            self.superview?.layoutIfNeeded()
        }
    }

    open func addTags(tags: [HashTag]) {
        self.hashtags.append(contentsOf: tags)

        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()

        let height: CGFloat = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        self.height?.constant = height

        if self.animateViewHeightChanged {
            UIView.animate(withDuration: self.animationDuration) {
                self.superview?.layoutIfNeeded()
            }
        } else {
            self.superview?.layoutIfNeeded()
        }
    }

    open func removeTag(tag: HashTag) {
        self.hashtags.remove(object: tag)
        self.collectionView.reloadData()

        if self.hashtags.isEmpty {
            self.height?.constant = 0

            if self.animateViewHeightChanged {
                UIView.animate(withDuration: self.animationDuration) {
                    self.superview?.layoutIfNeeded()
                }
            } else {
                self.superview?.layoutIfNeeded()
            }
        }
    }

    open func getTags() -> [HashTag] {
        return self.hashtags
    }
}

extension HashtagView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hashtags.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hashtag: HashTag = self.hashtags[indexPath.item]
        
        if hashtag.isRemovable {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemovableHashtagCollectionViewCell.cellIdentifier,
                                                          for: indexPath) as! RemovableHashtagCollectionViewCell
            
            cell.configureWithTag(tag: hashtag)
            cell.delegate = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashtagCollectionViewCell.cellIdentifier,
                                                      for: indexPath) as! HashtagCollectionViewCell

        cell.configureWithTag(tag: hashtag)
        return cell
    }
}

extension HashtagView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hashtag: HashTag = self.hashtags[indexPath.item]
        let size = hashtag.text.sizeOfString(usingFont: UIFont.systemFont(ofSize: 14.0))
        
        let padding: CGFloat = 10.0
        
        if hashtag.isRemovable {
            let closeButtonSpacing: CGFloat = 5.0
            let closeButtonWidth: CGFloat = 20.0
            return CGSize(width: size.width + closeButtonSpacing + closeButtonWidth + padding, height: size.height + 6)
        }
        return CGSize(width: size.width + padding, height: size.height + 6)
    }
}

extension HashtagView: HashtagViewDelegate {
    public func hashtagRemoved(hashtag: HashTag) {
        removeTag(tag: hashtag)
    }
}
