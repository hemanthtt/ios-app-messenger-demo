//
//  Constants.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/3/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

public struct Constants {
    
    static let defaultStatusBarStyle = UIStatusBarStyle.lightContent
    
    struct Colors {
        static let leadingColor = UIColor.init(colorLiteralRed: 217.0/255.0, green: 42.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        static let secondaryColor = UIColor.init(colorLiteralRed: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        static let defaultBlueColor = UIColor.init(colorLiteralRed: 48.0/255.0, green: 160.0/255.0, blue: 196.0/255.0, alpha: 1.0)
        static let defaultGreenColor = UIColor.init(colorLiteralRed: 104.0/255.0, green: 174.0/255.0, blue: 4.0/255.0, alpha: 1.0)
        static let defaultRedColor = UIColor.init(colorLiteralRed: 217.0/255.0, green: 42.0/255.0, blue: 37.0/255.0, alpha: 1.0)
        static let defaultGrayColor = UIColor.init(colorLiteralRed: 146.0/255.0, green: 147.0/255.0, blue: 147.0/255.0, alpha: 1.0)
        static let defaultLightGrayColor = UIColor.init(colorLiteralRed: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        static let defaultDarkTextColor = UIColor.init(colorLiteralRed: 22.0/255.0, green: 23.0/255.0, blue: 24.0/255.0, alpha: 1.0)
    }
    
    struct Fonts {
        static let messageTextFont = UIFont.systemFont(ofSize: 16)
        static let bangTextFont = UIFont.systemFont(ofSize: 12)
        static let messageInputViewFont = UIFont.systemFont(ofSize: 16)
        
        static func lightFont(_ fontSize: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightLight)
        }
        
        static func regularFont(_ fontSize: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: fontSize)
        }
        
        static func mediumFont(_ fontSize: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightMedium)
        }
        
        static func boldFont(_ fontSize: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFontWeightBold)
        }
    }
}
