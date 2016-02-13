//
//  OrganizationCell.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/12/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

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
                textColor = UIColor.blackColor()
                self.backgroundColor = UIColor.init(hex: 0xFDEBA9)
                self.selectedIndicatorView.hidden = false
            } else {
                font = Constants.Fonts.regularFont(self.organizationNameLabel.font.pointSize)
                textColor = Constants.Colors.defaultGrayColor
                self.backgroundColor = UIColor.whiteColor()
                self.selectedIndicatorView.hidden = true
            }
            self.setUnreadBadge()
            self.organizationNameLabel.font = font
            self.organizationNameLabel.textColor = textColor
        }
    }
    
    private func setUnreadBadge() {
        self.badgeData = TTKit.sharedInstance().badgeDataForOrganizationToken(item?.token)
        self.updateUnreadCount(self.badgeData?.unreadCount)
        
    }
    
    private func updateUnreadCount(unreadMessagesCountForConversation: UInt?) {
        if unreadMessagesCountForConversation > 0 {
            self.unreadBadgeView.hidden = false
            self.unreadBadgeCountLabel.text = String.init(format: "%ld", unreadMessagesCountForConversation!)
        } else {
            self.unreadBadgeView.hidden = true
            self.unreadBadgeCountLabel.text = ""
        }
        self.unreadBadgeView.cornerRadius = max(CGRectGetHeight(self.unreadBadgeView.frame), 19)/2
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.unreadBadgeView.setNeedsLayout()
        self.unreadBadgeView.layoutIfNeeded()
        self.unreadBadgeView.cornerRadius = max(CGRectGetHeight(self.unreadBadgeView.frame), 19)/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.badgeData?.prepareForReuse()
        self.unreadBadgeView.hidden = true
        self.unreadBadgeCountLabel.text = ""
    }
}