//
//  AddButton.swift
//  Hashtags_Example
//
//  Created by Oscar Götting on 6/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class AddButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.lightGray
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitle("Add", for: .normal)
    }
    
    func setClickable(_ value: Bool) {
        if value {
            self.isEnabled = true
            self.backgroundColor = UIColor.lightGray
        } else {
            self.isEnabled = false
            self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        }
    }
}
