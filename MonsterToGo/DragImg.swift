//
//  DragImg.swift
//  MonsterToGo
//
//  Created by Niklas Danz on 25.09.16.
//  Copyright © 2016 Niklas Danz. All rights reserved.
//

import Foundation
import UIKit


class DragImg: UIImageView {
    
    // MARK: Vars
    var originalPosition: CGPoint!
    var dropTarget: UIView?
    
    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // Get location of the UIView in the view where its dragged
            let position = touch.location(in: self.superview)
            // update location to match point
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // if a touch is made and we got a target specified
        if let touch = touches.first, let target = dropTarget {
            
            let position = touch.location(in: self.superview)
            
            // NOTIFICATION SENDER
            if target.frame.contains(position) {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "onTargetDropped")))
            }
        }
        
        self.center = originalPosition
    }
    
}
