//
//  ExampleWithoutStoryboardVC.swift
//  Hashtags_Example
//
//  Created by Oscar Götting on 6/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Hashtags

fileprivate extension Selector {
    static let onEditingChanged = #selector(ExampleUsingCode.editingChanged(_:))
    static let onAddHashtag = #selector(ExampleUsingCode.onAddHashtag(_:))
}

class ExampleUsingCode: UIViewController {
   
    struct Constants {
        static let minCharsForInput = 3
        static let maxCharsForInput = 30
    }
    
    lazy var hashtags: HashtagView = {
        let hashtags = HashtagView(frame: CGRect(x: 0, y: 0, width: 0, height: 70.0))
        hashtags.cornerRadius = 5.0
        hashtags.tagCornerRadius = 5.0
        hashtags.backgroundColor = UIColor(red: 238.0, green: 238.0, blue: 238.0, alpha: 0.0).withAlphaComponent(0.3)
        hashtags.tagBackgroundColor = UIColor.lightGray
        hashtags.tagTextColor = UIColor.white
        return hashtags
    }()
    
    var input: UITextField = {
        let input = UITextField(frame: .zero)
        input.borderStyle = .roundedRect
        return input
    }()
    
    var addButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Add", for: .normal)
        return button
    }()
    
    var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        
        self.hashtags.resizingDelegate = self

        self.view.addSubview(self.hashtags)
        self.view.addSubview(self.input)
        self.view.addSubview(self.addButton)
        
        self.hashtags.translatesAutoresizingMaskIntoConstraints = false
        self.hashtags.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        self.hashtags.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0).isActive = true
        self.hashtags.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0).isActive = true
        // This constraint helps us resizing the Hashtags view when it needs to be expanded
        self.heightConstraint = self.hashtags.heightAnchor.constraint(equalToConstant: 50.0)
        self.heightConstraint?.isActive = true
        
        self.input.translatesAutoresizingMaskIntoConstraints = false
        self.input.delegate = self
        self.input.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0).isActive = true
        self.input.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        self.input.topAnchor.constraint(equalTo: self.hashtags.bottomAnchor, constant: 20.0).isActive = true
        
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.leadingAnchor.constraint(equalTo: self.input.trailingAnchor, constant: 6.0).isActive = true
        self.addButton.centerYAnchor.constraint(equalTo: self.input.centerYAnchor).isActive = true
        
        self.input.addTarget(self, action: Selector.onEditingChanged, for: .editingChanged)
        self.addButton.addTarget(self, action: Selector.onAddHashtag, for: .touchUpInside)
        self.hashtags.addTag(tag: HashTag(word: "hashtag", isRemovable: true))
        
        let tags = [HashTag(word: "this"),
                    HashTag(word: "is", isRemovable: false),
                    HashTag(word: "another", isRemovable: true),
                    HashTag(word: "example", isRemovable: true)]
        
        self.hashtags.addTags(tags: tags)
    }
    
    @objc func onAddHashtag(_ sender: Any) {
        guard let text = self.input.text else {
            return
        }
        let hashtag = HashTag(word: text, isRemovable: true)
        hashtags.addTag(tag: hashtag)
        
        self.input.text = ""
        self.addButton.isEnabled = false
        self.addButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
    }
}

extension ExampleUsingCode: HashtagsViewResizingDelegate {
    func viewShouldResizeTo(size: CGSize) {
        guard let constraint = self.heightConstraint else {
            return
        }
        constraint.constant = size.height
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ExampleUsingCode: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        if text.count >= Constants.minCharsForInput {
            onAddHashtag(textField)
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= Constants.maxCharsForInput
    }
    
    @objc
    func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if text.count >= Constants.minCharsForInput {
            self.addButton.isEnabled = true
            self.addButton.backgroundColor = UIColor.blue
        } else {
            self.addButton.isEnabled = false
            self.addButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        }
    }
}


