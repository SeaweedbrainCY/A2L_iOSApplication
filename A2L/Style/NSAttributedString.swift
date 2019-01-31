//
//  NSAttributedString.swift
//  A2L
//
//  Created by Nathan on 29/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    //Permet de ne changer la couleur que d'une seule partie du texte
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setFontForText(textForAttribute: String, withFont font : UIFont){
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
    
}
