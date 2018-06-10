//
//  HashtagView.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/6/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import UIKit

// MARK: Class

public enum ResizeMode {
    case manual
    case expandable
    case wrap
}

@IBDesignable
open class HashtagView: UIView {
    
    private var sizingLabel = UILabel(frame: .zero)
    
    private var originalHeight: CGFloat?
    
    private var configuration = HashtagConfiguration()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        return view
    }()
    
    public var hashtags: [HashTag] = []
    
    open var resizeMode: ResizeMode = .expandable
    
    @IBOutlet
    open weak var height: NSLayoutConstraint?

    @IBInspectable
    open var animationDuration: TimeInterval = 0.4

    @IBInspectable
    open var shouldBeHiddenWhenEmpty: Bool = true

    @IBInspectable
    open var animateViewHeightChanged: Bool = true
    
    @IBInspectable
    open var viewBackgroundColor: UIColor? {
        didSet {
            self.backgroundColor = self.viewBackgroundColor
        }
    }

    @IBInspectable
    open var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    
    // MARK: Container padding (insets)
    
    @IBInspectable
    open var containerPaddingLeft: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var containerPaddingRight: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var containerPaddingTop: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var containerPaddingBottom: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    // MARK: Hashtag cell padding
    
    @IBInspectable
    open var hashtagPaddingLeft: CGFloat = 5.0 {
        didSet {
            self.configuration.paddingLeft = self.hashtagPaddingLeft
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var hashtagPaddingRight: CGFloat = 5.0 {
        didSet {
            self.configuration.paddingRight = self.hashtagPaddingRight
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var hashtagPaddingTop: CGFloat = 5.0 {
        didSet {
            self.configuration.paddingTop = self.hashtagPaddingTop
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var hashtagPaddingBottom: CGFloat = 5.0 {
        didSet {
            self.configuration.paddingBottom = self.hashtagPaddingBottom
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var hashtagCloseButtonSize: CGFloat = 10.0 {
        didSet {
            self.configuration.closeIconSize = self.hashtagCloseButtonSize
            self.collectionView.reloadData()
        }
    }
    @IBInspectable
    open var hashtagCloseButtonSpacing: CGFloat = 5.0 {
        didSet {
            self.configuration.closeIconSpacing = self.hashtagCloseButtonSpacing
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Hashtags cell margins
    
    @IBInspectable
    open var horizontalTagSpacing: CGFloat = 7.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    open var verticalTagSpacing: CGFloat = 5.0 {
        didSet {
            setup()
        }
    }
    
    // MARK: Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.shouldBeHiddenWhenEmpty = false
        self.animateViewHeightChanged = false
        self.addTag(tag: HashTag(word: "hashtag"))
        self.addTag(tag: HashTag(word: "RemovableHashtag", isRemovable: true))
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }

    func setup() {
        self.configuration.paddingLeft = self.hashtagPaddingLeft
        self.configuration.paddingRight = self.hashtagPaddingRight
        self.configuration.paddingTop = self.hashtagPaddingTop
        self.configuration.paddingBottom = self.hashtagPaddingBottom
        self.configuration.closeIconSize = self.hashtagCloseButtonSize
        self.configuration.closeIconSpacing = self.hashtagCloseButtonSpacing
        
        self.clipsToBounds = true
        
        if self.height == nil {
            self.height = self.heightAnchor.constraint(equalToConstant: self.bounds.height)
            self.height!.isActive = true
        }
        
        if self.resizeMode == .wrap {
            self.height?.constant = 0.0
        }
        
        self.originalHeight = self.height!.constant
        
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
    
    func resize() {
        let contentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        
        if self.resizeMode == .expandable {
            if self.height!.constant < contentHeight {
                self.height!.constant = contentHeight
            } else if contentHeight > self.originalHeight! {
                self.height!.constant = contentHeight
            }
        }
        else if self.resizeMode == .wrap {
            self.height!.constant = contentHeight
        }
        else {
            return
        }
        
        if self.animateViewHeightChanged {
            UIView.animate(withDuration: self.animationDuration) {
                self.superview?.layoutIfNeeded()
            }
        } else {
            self.superview?.layoutIfNeeded()
        }
    }
}

extension HashtagView {

    open func addTag(tag: HashTag) {
        self.hashtags.append(tag)
        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()

        resize()
    }

    open func addTags(tags: [HashTag]) {
        self.hashtags.append(contentsOf: tags)
        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        
        resize()
    }

    open func removeTag(tag: HashTag) {
        self.hashtags.remove(object: tag)
        self.collectionView.reloadData()
        self.superview?.setNeedsLayout()
        self.superview?.layoutIfNeeded()
        
        resize()
    }

    open func getTags() -> [HashTag] {
        return self.hashtags
    }
}

extension HashtagView: HashtagViewDelegate {
    public func hashtagRemoved(hashtag: HashTag) {
        removeTag(tag: hashtag)
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
            
            cell.configureWithTag(tag: hashtag, configuration: self.configuration)
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
        let textDimensions = hashtag.text.sizeOfString(usingFont: UIFont.systemFont(ofSize: 14.0))
        
        var calculatedHeight = CGFloat()
        var calculatedWidth = CGFloat()
        
        calculatedHeight = textDimensions.height + 6

        if hashtag.isRemovable {
            calculatedWidth =
                configuration.paddingLeft
                + textDimensions.width
                + configuration.closeIconSpacing
                + configuration.closeIconSize
                + configuration.paddingRight
        } else {
            calculatedWidth = configuration.paddingLeft + textDimensions.width + configuration.paddingRight
        }
        return CGSize(width: calculatedWidth, height: calculatedHeight)
    }
}
