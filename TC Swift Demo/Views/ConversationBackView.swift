//
//  ConversationBackView.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/12/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

class ConversationBackView: UIView {
    
    var backArrowImageView: UIImageView!
    var conversationHash: NSString?
    var initialUnreadCount: NSInteger = 0
    var badgeView: BadgeView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    class func conversationBackViewWithConversaitonHash(_ conversationHash: String?) -> ConversationBackView! {
        let view = ConversationBackView.init(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        view.conversationHash = conversationHash as NSString?
        view.refreshBadge()
        view.registerNotifications()
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backArrowImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 8*1.2, height: 14*1.2))
        self.backArrowImageView.left = 10
        self.backArrowImageView.centerY = frame.midY
        self.backArrowImageView.backgroundColor = UIColor.clear
        self.backArrowImageView.image = UIImage.init(named: "back-arrow")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.backArrowImageView.tintColor = UIColor.white
        self.addSubview(self.backArrowImageView)
        
        self.badgeView = BadgeView.init(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        self.badgeView.left = self.backArrowImageView.right + 5
        self.badgeView.centerY = self.backArrowImageView.centerY
        self.addSubview(self.badgeView)
        
        let overlayButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        overlayButton.backgroundColor = UIColor.clear
        overlayButton.addTarget(self, action: Selector("onOverlayButtonPressed:"), for: UIControlEvents.touchDragInside)
        self.addSubview(overlayButton)
    }
    
    fileprivate func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: Selector("refreshBadge"), name: NSNotification.Name.ttKitUnreadMessagesCountChanged, object: nil)
    }
    
    fileprivate func refreshBadge() {
        var organizationUnreadCount: UInt = 0
        let currentOrgToken = TTKit.sharedInstance().currentOrganizationToken()
        if (currentOrgToken != nil) {
            let badgeData = TTKit.sharedInstance().badgeData(forOrganizationToken: currentOrgToken)
            organizationUnreadCount = (badgeData?.unreadCount)!
        }
        
        var unreadForConversationHash: UInt = 0
        if (self.conversationHash != nil) {
            unreadForConversationHash = TTKit.sharedInstance().badgeData(forConversationHash: self.conversationHash as String!).unreadCount
        }
        
        let unreadCountToDisplay = organizationUnreadCount - unreadForConversationHash
        if unreadCountToDisplay > 0 {
            self.badgeView.isHidden = false
            self.badgeView.setBadgeCount(Int(unreadCountToDisplay))
        } else {
            self.badgeView.isHidden = true
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.badgeView.setNeedsLayout()
    }
    
    fileprivate func onOverlayButtonPressed(_ sender: AnyObject) {
        let nav = self.firstAvailableViewController() as! UINavigationController
        nav.popViewController(animated: true)
    }
}
