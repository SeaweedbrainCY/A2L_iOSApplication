//
//  FicheAdhérent.swift
//  A2L
//
//  Created by Nathan on 10/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class FicheAdherent: UIViewController {
    
    @IBOutlet weak var QRCodeImage: UIImageView! // il faut generer nous même de QR code
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var chargement: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let returnQRcode = generateQRcode() 
        self.QRCodeImage.image = returnQRcode.generateQRCode(from: self.nomLabel.text!)// on génère le QR code associé à l'élève
        chargement.stopAnimating()
    }
}
