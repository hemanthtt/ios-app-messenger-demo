//
//  UIHelpers.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/8/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

class UIHelpers {
    
    static func actionSheetAlertController(_ title: String, buttonTitles: [String], completion: @escaping (_ selectedButtonTitle: String?) -> Void) -> UIAlertController {
        let alertController = UIAlertController.init(title: title, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            completion("Cancel")
        }
        alertController.addAction(cancelAction)
        
        for buttonTitle in buttonTitles {
            let action = UIAlertAction.init(title: buttonTitle, style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) -> Void in
                completion(buttonTitle)
            })
            alertController.addAction(action)
        }
        return alertController
    }
    
    static func alertControllerWithTitle(_ title: String, message: String, completion: (() -> Void)?) -> UIAlertController {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            completion?()
        })
        alertController.addAction(okAction);
        return alertController
    }
    
    static func alertControllerWithTitle(_ title: String, message: String, buttonTitles: [String], completion: @escaping (_ selectedButtonTitle: String?) -> Void) -> UIAlertController {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
            completion("Cancel")
        }
        alertController.addAction(cancelAction)
        
        for buttonTitle in buttonTitles {
            let action = UIAlertAction.init(title: buttonTitle, style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                completion(buttonTitle)
            })
            alertController.addAction(action)
        }
        return alertController
    }
}
