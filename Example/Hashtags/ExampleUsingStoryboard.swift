//
//  ExampleUsingStoryboard.swift
//  Hashtags
//
//  Created by gottingoscar@gmail.com on 06/08/2018.
//  Copyright (c) 2018 gottingoscar@gmail.com. All rights reserved.
//

import UIKit
import Hashtags

fileprivate extension Selector {
    static let onEditingChanged = #selector(ExampleUsingStoryboard.editingChanged(_:))
}

class ExampleUsingStoryboard: UIViewController {
    
    struct Constants {
        static let minCharsForInput = 3
        static let maxCharsForInput = 30
    }

    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var hashtags: HashtagView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hashtags.resizingDelegate = self
        self.input.delegate = self
        self.input.addTarget(self, action: Selector.onEditingChanged, for: .editingChanged)
        
        let tags = [HashTag(word: "this"),
                    HashTag(word: "is", isRemovable: false),
                    HashTag(word: "an", isRemovable: true),
                    HashTag(word: "example", isRemovable: true)]
        
        self.hashtags.addTags(tags: tags)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onAddHashtag(_ sender: Any) {
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

extension ExampleUsingStoryboard: HashtagsViewResizingDelegate {
    func viewShouldResizeTo(size: CGSize) {
        self.heightConstraint.constant = size.height
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ExampleUsingStoryboard: UITextFieldDelegate {
    
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
