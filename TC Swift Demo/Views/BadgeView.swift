//
//  BadgeView.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/12/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

class BadgeView: UIView {
    
    var badgeUnreadLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.init(hex:0xF84040)
        self.cornerRadius = self.width/2
        
        self.badgeUnreadLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        self.badgeUnreadLabel.backgroundColor = UIColor.clear
        self.badgeUnreadLabel.textColor = UIColor.white
        self.badgeUnreadLabel.font = UIFont.systemFont(ofSize: 10)
        self.badgeUnreadLabel.textAlignment = NSTextAlignment.center
        self.badgeUnreadLabel.centerX = self.bounds.midX
        self.badgeUnreadLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(self.badgeUnreadLabel)
    }
    
    func setBadgeCount(_ badgeCount: NSInteger) {
        if badgeCount == 0 {
            self.badgeUnreadLabel.text = ""
            return
        }
        self.badgeUnreadLabel.text = String.init(format: "%lu", badgeCount)
        self.badgeUnreadLabel.centerX = self.bounds.width/2
    }
}
