//
//  MonsterImg.swift
//  MonsterToGo
//
//  Created by Niklas Danz on 26.09.16.
//  Copyright © 2016 Niklas Danz. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        
        self.image = #imageLiteral(resourceName: "idle4")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for number in 1...4 {
            let frame = UIImage(named: "idle\(number).png")
            imgArray.append(frame!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        
        self.image = #imageLiteral(resourceName: "dead5")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for number in 1...5 {
            let frame = UIImage(named: "dead\(number).png")
            imgArray.append(frame!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
}
