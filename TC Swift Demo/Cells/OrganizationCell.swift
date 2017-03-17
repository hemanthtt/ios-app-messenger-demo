//
//  OrganizationCell.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/12/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class OrganizationCell: UITableViewCell {

    @IBOutlet weak var organizationNameLabel: UILabel!
    @IBOutlet weak var unreadBadgeView: UIView!
    @IBOutlet weak var unreadBadgeCountLabel: UILabel!
    @IBOutlet weak var selectedIndicatorView: UIView!
    var badgeData: TTBadgeData?
    
    class func cellHeight() -> CGFloat {
        return 60.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedIndicatorView.backgroundColor = Constants.Colors.leadingColor
    }
    
    var item: TTOrganization? {
        didSet {
            self.organizationNameLabel.text = item?.name
            let font: UIFont!
            let textColor: UIColor!
            if item?.token == TTKit.sharedInstance().currentOrganizationToken() {
                font = Constants.Fonts.mediumFont(self.organizationNameLabel.font.pointSize)
                textColor = UIColor.black
                self.backgroundColor = UIColor.init(hex: 0xFDEBA9)
                self.selectedIndicatorView.isHidden = false
            } else {
                font = Constants.Fonts.regularFont(self.organizationNameLabel.font.pointSize)
                textColor = Constants.Colors.defaultGrayColor
                self.backgroundColor = UIColor.white
                self.selectedIndicatorView.isHidden = true
            }
            self.setUnreadBadge()
            self.organizationNameLabel.font = font
            self.organizationNameLabel.textColor = textColor
        }
    }
    
    fileprivate func setUnreadBadge() {
        self.badgeData = TTKit.sharedInstance().badgeData(forOrganizationToken: item?.token)
        self.updateUnreadCount(self.badgeData?.unreadCount)
        
    }
    
    fileprivate func updateUnreadCount(_ unreadMessagesCountForConversation: UInt?) {
        if unreadMessagesCountForConversation > 0 {
            self.unreadBadgeView.isHidden = false
            self.unreadBadgeCountLabel.text = String.init(format: "%ld", unreadMessagesCountForConversation!)
        } else {
            self.unreadBadgeView.isHidden = true
            self.unreadBadgeCountLabel.text = ""
        }
        self.unreadBadgeView.cornerRadius = max(self.unreadBadgeView.frame.height, 19)/2
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.unreadBadgeView.setNeedsLayout()
        self.unreadBadgeView.layoutIfNeeded()
        self.unreadBadgeView.cornerRadius = max(self.unreadBadgeView.frame.height, 19)/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.badgeData?.prepareForReuse()
        self.unreadBadgeView.isHidden = true
        self.unreadBadgeCountLabel.text = ""
    }
}
