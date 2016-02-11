//
//  UIHelpers.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/8/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

class UIHelpers {
    
    static func actionSheetAlertController(title: String, buttonTitles: [String], completion: (selectedButtonTitle: String?) -> Void) -> UIAlertController! {
        let alertController = UIAlertController.init(title: title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            completion(selectedButtonTitle: "Cancel")
        }
        alertController.addAction(cancelAction)
        
        for buttonTitle in buttonTitles {
            let action = UIAlertAction.init(title: buttonTitle, style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) -> Void in
                completion(selectedButtonTitle: buttonTitle)
            })
            alertController.addAction(action)
        }
        return alertController
    }
    
    static func alertControllerWithTitle(title: String, message: String, completion: (() -> Void)?) -> UIAlertController! {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            completion?()
        })
        alertController.addAction(okAction);
        return alertController
    }
    
    static func alertControllerWithTitle(title: String, message: String, buttonTitles: [String], completion: (selectedButtonTitle: String?) -> Void) -> UIAlertController! {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            completion(selectedButtonTitle: "Cancel")
        }
        alertController.addAction(cancelAction)
        
        for buttonTitle in buttonTitles {
            let action = UIAlertAction.init(title: buttonTitle, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                completion(selectedButtonTitle: buttonTitle)
            })
            alertController.addAction(action)
        }
        return alertController
    }
}
