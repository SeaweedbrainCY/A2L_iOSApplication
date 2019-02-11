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
}
