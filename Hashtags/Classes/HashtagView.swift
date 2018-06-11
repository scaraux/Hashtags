//
//  HashtagView.swift
//  Hashtags
//
//  Created by Oscar Götting on 6/6/18.
//  Copyright © 2018 Oscar Götting. All rights reserved.
//

import UIKit

// MARK: Resising Delegate

public protocol HashtagsViewResizingDelegate {
    func viewShouldResizeTo(size: CGSize)
}

// MARK: Class

@IBDesignable
open class HashtagView: UIView {
    
    private var sizingLabel = UILabel(frame: .zero)
    
    private var lastDimension: CGSize?
    
    private var originalHeight: CGFloat?
    
    private var configuration = HashtagConfiguration()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        return view
    }()
    
    public var hashtags: [HashTag] = []
    
    public var resizingDelegate: HashtagsViewResizingDelegate?

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
    open var tagPadding: CGFloat = 5.0 {
        didSet {
            self.configuration.paddingLeft = self.tagPadding
            self.configuration.paddingTop = self.tagPadding
            self.configuration.paddingBottom = self.tagPadding
            self.configuration.paddingRight = self.tagPadding
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagCornerRadius: CGFloat = 5.0 {
        didSet {
            self.configuration.cornerRadius = self.tagCornerRadius
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagBackgroundColor: UIColor = .lightGray {
        didSet {
            self.configuration.backgroundColor = self.tagBackgroundColor
            self.collectionView.reloadData()
        }
    }
    
    @IBInspectable
    open var tagTextColor: UIColor = .white {
        didSet {
            self.configuration.textColor = self.tagTextColor
            self.collectionView.reloadData()
        }
    }
    
    
    @IBInspectable
    open var removeButtonSize: CGFloat = 10.0 {
        didSet {
            self.configuration.removeButtonSize = self.removeButtonSize
            self.collectionView.reloadData()
        }
    }
    @IBInspectable
    open var removeButtonSpacing: CGFloat = 5.0 {
        didSet {
            self.configuration.removeButtonSpacing = self.removeButtonSpacing
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
    
    public override init(frame: CGRect) {
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
        self.addTag(tag: HashTag(word: "hashtag"))
        self.addTag(tag: HashTag(word: "RemovableHashtag", isRemovable: true))
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }

    func makeDefaultConfiguration() {
        
        let configuration = HashtagConfiguration()
        
        configuration.paddingLeft = self.tagPadding
        configuration.paddingRight = self.tagPadding
        configuration.paddingTop = self.tagPadding
        configuration.paddingBottom = self.tagPadding
        configuration.removeButtonSize = self.removeButtonSize
        configuration.removeButtonSpacing = self.removeButtonSpacing
        configuration.backgroundColor = self.tagBackgroundColor
        configuration.cornerRadius = self.tagCornerRadius
        configuration.textColor = self.tagTextColor
        
        self.configuration = configuration
    }
    
    func setup() {
        
        makeDefaultConfiguration()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.cornerRadius

        let alignedFlowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        alignedFlowLayout.minimumLineSpacing = self.horizontalTagSpacing
        alignedFlowLayout.minimumInteritemSpacing = self.verticalTagSpacing
        alignedFlowLayout.sectionInset = UIEdgeInsets(top: self.containerPaddingTop,
                                                      left: self.containerPaddingLeft,
                                                      bottom: self.containerPaddingBottom,
                                                      right: self.containerPaddingRight)

        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.collectionViewLayout = alignedFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.isScrollEnabled = false
        
        self.collectionView.register(HashtagCollectionViewCell.self,
                                     forCellWithReuseIdentifier: HashtagCollectionViewCell.cellIdentifier)
        self.collectionView.register(RemovableHashtagCollectionViewCell.self,
                                     forCellWithReuseIdentifier: RemovableHashtagCollectionViewCell.cellIdentifier)
       
        self.collectionView.removeFromSuperview()
        self.addSubview(self.collectionView)
    }
    
    func resize() {
        guard let delegate = self.resizingDelegate else {
            return
        }
        
        let contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize
        
        if self.lastDimension != nil {
            if lastDimension!.height != contentSize.height {
               delegate.viewShouldResizeTo(size: contentSize)
            }
        } else {
            delegate.viewShouldResizeTo(size: contentSize)
        }
        self.lastDimension = contentSize
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
        
        calculatedHeight = configuration.paddingTop + textDimensions.height + configuration.paddingBottom

        if hashtag.isRemovable {
            calculatedWidth =
                configuration.paddingLeft
                + textDimensions.width
                + configuration.removeButtonSpacing
                + configuration.removeButtonSize
                + configuration.paddingRight
        } else {
            calculatedWidth = configuration.paddingLeft + textDimensions.width + configuration.paddingRight
        }
        return CGSize(width: calculatedWidth, height: calculatedHeight)
    }
}
