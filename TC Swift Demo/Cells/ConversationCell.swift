//
//  ConversationCell.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/11/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var avatar: TTImageView!
    @IBOutlet weak var conversationNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var lastMessageTimestampLabel: UILabel!
    @IBOutlet weak var lastMessageStatusLabel: UILabel!
    @IBOutlet weak var unreadBadgeView: UIView!
    @IBOutlet weak var unreadBadgeCountLabel: UILabel!
    var badgeData: TTBadgeData?
    
    class func cellHeight() -> CGFloat {
        return 73.0
    }
    
    deinit {
        badgeData?.prepareForReuse()
        badgeData = nil
    }
    
    var item: TTRosterEntry? {
        didSet {
            self.conversationNameLabel.text = item?.target.displayName
            if let latestMessage = item?.latestMessage {
                
                if latestMessage.body.characters.count > 0 {
                    self.lastMessageLabel.text = latestMessage.body
                } else {
                    self.lastMessageLabel.text = lastMessageMessageStringForAttachmet(latestMessage.attachmentDescriptors.firstObject as! TTAttachmentDescriptor)
                }
                
                if TTKit.sharedInstance().isUserLocalUser(latestMessage.sender as! TTUser) {
                    setLastMessageStatus(latestMessage.status)
                } else {
                    self.lastMessageStatusLabel.text = " "
                }
            } else {
                self.lastMessageStatusLabel.text = " "
                self.lastMessageLabel.text = " "
            }

            self.avatar.setPathToNetworkImage(item?.target.avatarURL, forDisplaySize: self.avatar.frame.size, contentMode: UIViewContentMode.ScaleAspectFill, circleCrop: true)
        }
    }
    
    func lastMessageMessageStringForAttachmet(attachment: TTAttachmentDescriptor) -> String? {
        var string: String?
        if TTAttachmentType(rawValue: attachment.type.unsignedLongValue) == .Image {
            string = "Image Message"
        } else if TTAttachmentType(rawValue: attachment.type.unsignedLongValue) == .Audio {
            string = "Audio Message"
        } else if TTAttachmentType(rawValue: attachment.type.unsignedLongValue) == .Video {
            string = "Video Message"
        } else if TTAttachmentType(rawValue: attachment.type.unsignedLongValue) == .Document {
            string = "Document Message"
        }
        return string
    }
    
    func setLastMessageStatus(status: String?) {
        var text = " "
        var color = UIColor.whiteColor()
        
        if status == kTTKitMessageStatusRead {
            text = "Read";
            color = Constants.Colors.defaultGreenColor
        } else if status == kTTKitMessageStatusDelivered {
            text = "Delivered";
            color = Constants.Colors.defaultBlueColor
        } else if status == kTTKitMessageStatusSending {
            text = "Sending...";
            color = Constants.Colors.defaultGrayColor
        } else if status == kTTKitMessageStatusSent {
            text = "Sent";
            color = Constants.Colors.defaultBlueColor
        } else if status == kTTKitMessageStatusFailed {
            text = "Message Failed";
            color = Constants.Colors.defaultRedColor
        }
        self.lastMessageStatusLabel.text = text
        self.lastMessageStatusLabel.textColor = color
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatar.prepareForReuse()
        self.unreadBadgeView.hidden = true
        self.unreadBadgeCountLabel.text = ""
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.backgroundColor = highlighted ? Constants.Colors.defaultLightGrayColor : UIColor.whiteColor()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? Constants.Colors.defaultLightGrayColor : UIColor.whiteColor()
    }
}
