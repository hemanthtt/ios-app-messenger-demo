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
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.init(hex:0xF84040)
        self.cornerRadius = self.width/2
        
        self.badgeUnreadLabel = UILabel.init(frame: CGRectMake(0, 0, self.width, self.height))
        self.badgeUnreadLabel.backgroundColor = UIColor.clearColor()
        self.badgeUnreadLabel.textColor = UIColor.whiteColor()
        self.badgeUnreadLabel.font = UIFont.systemFontOfSize(10)
        self.badgeUnreadLabel.textAlignment = NSTextAlignment.Center
        self.badgeUnreadLabel.centerX = CGRectGetMidX(self.bounds)
        self.badgeUnreadLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(self.badgeUnreadLabel)
    }
    
    func setBadgeCount(badgeCount: NSInteger) {
        if badgeCount == 0 {
            self.badgeUnreadLabel.text = ""
            return
        }
        self.badgeUnreadLabel.text = String.init(format: "%lu", badgeCount)
        self.badgeUnreadLabel.centerX = CGRectGetWidth(self.bounds)/2
    }
}