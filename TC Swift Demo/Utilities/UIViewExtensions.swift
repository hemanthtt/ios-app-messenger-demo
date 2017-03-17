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
        let nextResponder = self.next
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
           return self.frame.minY
        }
        set {
            var viewFrame = self.frame
            viewFrame.origin.y = newValue
            self.frame = viewFrame
        }
    }
    
    var left: CGFloat {
        get {
           return self.frame.minX
        }
        set {
            var viewFrame = self.frame
            viewFrame.origin.x = newValue
            self.frame = viewFrame
        }
    }

    var right: CGFloat {
        get {
           return self.frame.maxX
        }
        set {
            self.left = newValue - self.width
        }
    }

    var bottom: CGFloat {
        get {
           return self.frame.maxY
        }
        set {
            self.top = newValue - self.height
        }
    }
    
    var width: CGFloat {
        get {
           return self.bounds.width
        }
        set {
            var viewFrame = self.frame
            viewFrame.size.width = newValue
            self.frame = viewFrame
        }
    }
    
    var height: CGFloat {
        get {
           return self.bounds.height
        }
        set {
            var viewFrame = self.frame
            viewFrame.size.height = newValue
            self.frame = viewFrame
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.frame.midX
        }
        set {
            self.center = CGPoint(x: newValue, y: self.centerY)
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.frame.midY
        }
        set {
            self.center = CGPoint(x: self.centerX, y: newValue)
        }
    }
    
    func centerInSuperview() {
        if (self.superview != nil) {
            self.center = CGPoint(x: self.superview!.width / 2.0, y: self.superview!.height / 2.0)
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
            return UIColor.init(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
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
