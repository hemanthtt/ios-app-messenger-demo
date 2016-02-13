//
//  UIView+Common.swift
//  TC Swift Demo
//
//  Created by Oren Zitoun on 2/12/16.
//  Copyright © 2016 TigerConnect. All rights reserved.
//

import Foundation

extension UIView {
    
    func firstAvailableViewController() -> UIViewController? {
        let nextResponder = self.nextResponder()
        if nextResponder is UIViewController {
            return nextResponder as? UIViewController
        } else if nextResponder is UIView {
            let view = nextResponder as! UIView
            return view.firstAvailableViewController()
        } else {
            return nil
        }
    }
 
    var top: CGFloat {
        get {
           return CGRectGetMinY(self.frame)
        }
        set {
            var viewFrame = self.frame
            viewFrame.origin.y = newValue
            self.frame = viewFrame
        }
    }
    
    var left: CGFloat {
        get {
           return CGRectGetMinX(self.frame)
        }
        set {
            var viewFrame = self.frame
            viewFrame.origin.x = newValue
            self.frame = viewFrame
        }
    }

    var right: CGFloat {
        get {
           return CGRectGetMaxX(self.frame)
        }
        set {
            self.left = newValue - self.width
        }
    }

    var bottom: CGFloat {
        get {
           return CGRectGetMaxY(self.frame)
        }
        set {
            self.top = newValue - self.height
        }
    }
    
    var width: CGFloat {
        get {
           return CGRectGetWidth(self.bounds)
        }
        set {
            var viewFrame = self.frame
            viewFrame.size.width = newValue
            self.frame = viewFrame
        }
    }
    
    var height: CGFloat {
        get {
           return CGRectGetHeight(self.bounds)
        }
        set {
            var viewFrame = self.frame
            viewFrame.size.height = newValue
            self.frame = viewFrame
        }
    }
    
    var centerX: CGFloat {
        get {
            return CGRectGetMidX(self.frame)
        }
        set {
            self.center = CGPointMake(newValue, self.centerY)
        }
    }
    
    var centerY: CGFloat {
        get {
            return CGRectGetMidY(self.frame)
        }
        set {
            self.center = CGPointMake(self.centerX, newValue)
        }
    }
    
    func centerInSuperview() {
        if (self.superview != nil) {
            self.center = CGPointMake(self.superview!.width / 2.0, self.superview!.height / 2.0)
        }
    }
    
    // MARK: Layer properties
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            if (newValue > 0) {
                self.layer.masksToBounds = true
            }
        }
    }
    
    var borderColor: UIColor {
        get {
            return UIColor.init(CGColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.CGColor
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
}