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
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    class func conversationBackViewWithConversaitonHash(conversationHash: String?) -> ConversationBackView! {
        let view = ConversationBackView.init(frame: CGRectMake(0, 0, 70, 30))
        view.conversationHash = conversationHash
        view.refreshBadge()
        view.registerNotifications()
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backArrowImageView = UIImageView.init(frame: CGRectMake(0, 0, 8*1.2, 14*1.2))
        self.backArrowImageView.left = 10
        self.backArrowImageView.centerY = CGRectGetMidY(frame)
        self.backArrowImageView.backgroundColor = UIColor.clearColor()
        self.backArrowImageView.image = UIImage.init(named: "back-arrow")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.backArrowImageView.tintColor = UIColor.whiteColor()
        self.addSubview(self.backArrowImageView)
        
        self.badgeView = BadgeView.init(frame: CGRectMake(0, 0, 18, 18))
        self.badgeView.left = self.backArrowImageView.right + 5
        self.badgeView.centerY = self.backArrowImageView.centerY
        self.addSubview(self.badgeView)
        
        let overlayButton = UIButton.init(frame: CGRectMake(0, 0, self.width, self.height))
        overlayButton.backgroundColor = UIColor.clearColor()
        overlayButton.addTarget(self, action: Selector("onOverlayButtonPressed:"), forControlEvents: UIControlEvents.TouchDragInside)
        self.addSubview(overlayButton)
    }
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshBadge"), name: kTTKitUnreadMessagesCountChangedNotification, object: nil)
    }
    
    private func refreshBadge() {
        var organizationUnreadCount: UInt = 0
        let currentOrgToken = TTKit.sharedInstance().currentOrganizationToken()
        if (currentOrgToken != nil) {
            let badgeData = TTKit.sharedInstance().badgeDataForOrganizationToken(currentOrgToken)
            organizationUnreadCount = badgeData.unreadCount
        }
        
        var unreadForConversationHash: UInt = 0
        if (self.conversationHash != nil) {
            unreadForConversationHash = TTKit.sharedInstance().badgeDataForConversationHash(self.conversationHash as String!).unreadCount
        }
        
        let unreadCountToDisplay = organizationUnreadCount - unreadForConversationHash
        if unreadCountToDisplay > 0 {
            self.badgeView.hidden = false
            self.badgeView.setBadgeCount(Int(unreadCountToDisplay))
        } else {
            self.badgeView.hidden = true
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.badgeView.setNeedsLayout()
    }
    
    private func onOverlayButtonPressed(sender: AnyObject) {
        let nav = self.firstAvailableViewController() as! UINavigationController
        nav.popViewControllerAnimated(true)
    }
}