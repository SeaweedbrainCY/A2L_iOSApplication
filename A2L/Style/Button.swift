//
//  Button.swift
//  A2L
//
//  Created by Nathan on 27/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {
    func setArrondie(color: UIColor) {
        self.backgroundColor = color
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 20
        
    }
    
    func setBorderCorner(){
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.8
        layer.cornerRadius = 10
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -2.0, 2.0, 0.0 ]
        layer.add(animation, forKey: "transform.translation.x")
    }
}
