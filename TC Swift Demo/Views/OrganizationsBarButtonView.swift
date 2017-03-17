//
//  OrganizationsBarButtonView.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/12/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

protocol OrganizationsBarButtonViewDelegate {
    func organizationBarButtonPressed(_ sender: OrganizationsBarButtonView!)
}

class OrganizationsBarButtonView: UIView {
    fileprivate var organizationsImageView: UIImageView!
    fileprivate var unreadMessagesBadge: UIView!
    var delegate: OrganizationsBarButtonViewDelegate?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    class func barView() -> OrganizationsBarButtonView {
        let view = OrganizationsBarButtonView.init(frame: CGRect(x: 0, y: 0, width: 26, height: 25))
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.organizationsImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        self.organizationsImageView.left = 0
        self.organizationsImageView.bottom = frame.height
        self.organizationsImageView.image = UIImage.init(named: "orgs")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.organizationsImageView.tintColor = UIColor.white
        self.addSubview(self.organizationsImageView)
        
        self.unreadMessagesBadge = UIView.init(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        self.unreadMessagesBadge.backgroundColor = UIColor.init(hex: 0xff3838)
        self.unreadMessagesBadge.cornerRadius = 4.0
        self.unreadMessagesBadge.borderColor = UIColor.white
        self.unreadMessagesBadge.borderWidth = 1.0
        self.unreadMessagesBadge.right = frame.maxX
        self.unreadMessagesBadge.top = 0
        self.addSubview(self.unreadMessagesBadge)
        self.refreshBadge()
        self.registerNotifications()
        
        let overlayButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        overlayButton.backgroundColor = UIColor.clear
        overlayButton.addTarget(self, action: #selector(OrganizationsBarButtonView.onOverlayButtonPressed), for: UIControlEvents.touchUpInside)
        self.addSubview(overlayButton)
    }
    
    fileprivate func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(OrganizationsBarButtonView.refreshBadge), name: NSNotification.Name.ttKitUnreadMessagesCountChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OrganizationsBarButtonView.refreshBadge), name: NSNotification.Name.ttKitCurrentOrganizationChange, object: nil)
    }
    
    @objc fileprivate func refreshBadge() {
        var unreadCount: UInt = 0
        let currentOrgToken = TTKit.sharedInstance().currentOrganizationToken()
        if (currentOrgToken != nil) {
            let badgeData = TTKit.sharedInstance().badgeData(forOrganizationToken: currentOrgToken)
            unreadCount = (badgeData?.unreadCount)!
        }
        
        let totalUnreadCount = TTKit.sharedInstance().getTotalUnreadMessageCount()
        if (UInt(totalUnreadCount - unreadCount)) > 0 {
            self.unreadMessagesBadge.isHidden = false
        } else {
            self.unreadMessagesBadge.isHidden = true
        }
    }
    
    func onOverlayButtonPressed() {
        if let delegate = self.delegate {
            delegate.organizationBarButtonPressed(self)
        }
    }
    
}
