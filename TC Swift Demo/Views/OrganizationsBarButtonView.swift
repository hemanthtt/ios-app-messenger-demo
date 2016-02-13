//
//  OrganizationsBarButtonView.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/12/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

protocol OrganizationsBarButtonViewDelegate {
    func organizationBarButtonPressed(sender: OrganizationsBarButtonView!)
}

class OrganizationsBarButtonView: UIView {
    private var organizationsImageView: UIImageView!
    private var unreadMessagesBadge: UIView!
    var delegate: OrganizationsBarButtonViewDelegate?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    class func barView() -> OrganizationsBarButtonView {
        let view = OrganizationsBarButtonView.init(frame: CGRectMake(0, 0, 26, 25))
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.organizationsImageView = UIImageView.init(frame: CGRectMake(0, 0, 22, 22))
        self.organizationsImageView.left = 0
        self.organizationsImageView.bottom = CGRectGetHeight(frame)
        self.organizationsImageView.image = UIImage.init(named: "orgs")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.organizationsImageView.tintColor = UIColor.whiteColor()
        self.addSubview(self.organizationsImageView)
        
        self.unreadMessagesBadge = UIView.init(frame: CGRectMake(0, 0, 8, 8))
        self.unreadMessagesBadge.backgroundColor = UIColor.init(hex: 0xff3838)
        self.unreadMessagesBadge.cornerRadius = 4.0
        self.unreadMessagesBadge.borderColor = UIColor.whiteColor()
        self.unreadMessagesBadge.borderWidth = 1.0
        self.unreadMessagesBadge.right = CGRectGetMaxX(frame)
        self.unreadMessagesBadge.top = 0
        self.addSubview(self.unreadMessagesBadge)
        self.refreshBadge()
        self.registerNotifications()
        
        let overlayButton = UIButton.init(frame: CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        overlayButton.backgroundColor = UIColor.clearColor()
        overlayButton.addTarget(self, action: Selector("onOverlayButtonPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(overlayButton)
    }
    
    private func registerNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshBadge"), name: kTTKitUnreadMessagesCountChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("refreshBadge"), name: kTTKitCurrentOrganizationChangeNotification, object: nil)
    }
    
    @objc private func refreshBadge() {
        var unreadCount: UInt = 0
        let currentOrgToken = TTKit.sharedInstance().currentOrganizationToken()
        if (currentOrgToken != nil) {
            let badgeData = TTKit.sharedInstance().badgeDataForOrganizationToken(currentOrgToken)
            unreadCount = badgeData.unreadCount
        }
        
        let totalUnreadCount = TTKit.sharedInstance().getTotalUnreadMessageCount()
        if (totalUnreadCount - unreadCount) > 0 {
            self.unreadMessagesBadge.hidden = false
        } else {
            self.unreadMessagesBadge.hidden = true
        }
    }
    
    func onOverlayButtonPressed() {
        if let delegate = self.delegate {
            delegate.organizationBarButtonPressed(self)
        }
    }
    
}