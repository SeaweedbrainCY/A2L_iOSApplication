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
    
    //View :
    let helpTitle = UILabel()
    let helpDesciption = UILabel()
    
    var titleTransmitted = "Error"
    var descriptionTransmitted = "Error"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        loadElement()
    }
    
    private func loadElement(){
        self.backgroundView.addSubview(self.helpTitle)
        helpTitle.translatesAutoresizingMaskIntoConstraints = false
        helpTitle.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 4).isActive = true
        helpTitle.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.topAnchor, multiplier: 3).isActive = true
        helpTitle.font = UIFont(name: "Comfortaa-Bold", size: 23)
        helpTitle.textColor = .blue
        helpTitle.text = titleTransmitted
        
        self.backgroundView.addSubview(self.helpDesciption)
        helpDesciption.translatesAutoresizingMaskIntoConstraints = false
        helpDesciption.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 4).isActive = true
        helpDesciption.topAnchor.constraint(equalToSystemSpacingBelow: helpTitle.bottomAnchor, multiplier: 4).isActive = true
        helpDesciption.widthAnchor.constraint(equalToConstant: self.scrollView.frame.size.width - 20).isActive = true
        helpDesciption.numberOfLines = 50
        helpDesciption.lineBreakMode = .byWordWrapping
        helpDesciption.font = UIFont(name: "Comfortaa-Light", size: 16)
        
    }
}
