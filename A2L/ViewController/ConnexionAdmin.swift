//
//  ConnexionAdmin.swift
//  A2L
//
//  Created by Nathan on 19/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class connexionAdmin: UIViewController {
    
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var nomField: UITextField!
    @IBOutlet weak var mdpField: UITextField!
    @IBOutlet weak var validerButton: UIButton!
    @IBOutlet weak var connexionAdherentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBackground()
        titreLabel.superview?.addSubview(titreLabel)
        prenomField.superview?.addSubview(prenomField)
        nomField.superview?.addSubview(nomField)
        mdpField.superview?.addSubview(mdpField)
        validerButton.superview?.addSubview(validerButton)
        connexionAdherentButton.superview?.addSubview(connexionAdherentButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setViewBackground(){
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradient.colors = [UIColor.green.cgColor, UIColor.black.cgColor]// rgb(173, 204, 255), rgb(113, 166, 252)
        self.view.layer.addSublayer(gradient)
        
        
    }
}
