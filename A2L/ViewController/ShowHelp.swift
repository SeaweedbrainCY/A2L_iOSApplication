//
//  ShowHelp.swift
//  A2L
//
//  Created by Nathan on 06/03/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class ShowHelp: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var titleTransmitted = "Error"
    var descriptionTransmitted = "Error"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Title transmitted = \(titleTransmitted)")
        loadElement()
        self.backgroundView.layer.cornerRadius = 50
    }
    
    func loadElement(){
        let helpTitle = UILabel()
        self.backgroundView.addSubview(helpTitle)
        helpTitle.translatesAutoresizingMaskIntoConstraints = false
        helpTitle.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 4).isActive = true
        helpTitle.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.topAnchor, multiplier: 3).isActive = true
        if self.view.frame.size.width < 350 {
            helpTitle.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 70).isActive = true
        } else {
            helpTitle.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 50).isActive = true
        }
        
        helpTitle.lineBreakMode = .byWordWrapping
        helpTitle.numberOfLines = 3
        helpTitle.font = UIFont(name: "Comfortaa-Bold", size: 23)
        helpTitle.textColor = .blue
        helpTitle.text = titleTransmitted
        helpTitle.shadowColor = .black
        helpTitle.shadowOffset = CGSize(width: 1, height: 1)
        
        let helpDescription = UILabel()
        self.backgroundView.addSubview(helpDescription)
        helpDescription.translatesAutoresizingMaskIntoConstraints = false
        if self.view.frame.size.width < 350 {
            helpDescription.widthAnchor.constraint(equalToConstant: self.scrollView.frame.size.width - 80).isActive = true
        } else {
            helpDescription.widthAnchor.constraint(equalToConstant: self.scrollView.frame.size.width - 50).isActive = true
        }
        
        helpDescription.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        helpDescription.topAnchor.constraint(equalToSystemSpacingBelow: helpTitle.bottomAnchor, multiplier: 4).isActive = true
        helpDescription.numberOfLines = 50
        helpDescription.lineBreakMode = .byWordWrapping
        helpDescription.font = UIFont(name: "Comfortaa-Bold", size: 18)
        helpDescription.text = self.descriptionTransmitted
        
        
    }
}
