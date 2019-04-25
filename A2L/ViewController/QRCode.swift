//
//  QRCode.swift
//  A2L
//
//  Created by Nathan on 08/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

//Class connecté au controller avec le QR code 

class QRCode: UIViewController {
    
    @IBOutlet weak var scanner: UIBarButtonItem! // lié au ItemButton du controller
    @IBOutlet weak var QRCodeImage: UIImageView!
    @IBOutlet weak var nomLabel: UILabel!
    
    var listeInfoAdherent = infosAdherent // liste de toutes les infos sur l'adherent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let localData = LocalData()
        localData.returnDataFrom(stockInfosAdherent)
        listeInfoAdherent = infosAdherent // on récupère les données stocké
        nomLabel.text = listeInfoAdherent["Nom"] ?? "Error"
        darkMode()
        
    }
    
    override func viewDidAppear(_ animated: Bool) { // lancée quand la vue load
        super.viewDidAppear(animated)
        if let _ = listeInfoAdherent["MdpHashed"]{ // connecté en tant qu'admin
            scanner.title = "Scanner"
            scanner.tintColor = self.nomLabel.textColor
            scanner.isEnabled = true
        }
        darkMode()
        
        let api = APIConnexion()
        let nom = api.convertionToHexaCode(listeInfoAdherent["Nom"] ?? "Error") // On converti en hexa decimal
        
        let qrCodeGenerator = generateQRcode()
        let stringForQRCode = qrCodeGenerator.generateStringQRCode(nom: nom, dateNaissance: listeInfoAdherent["DateNaissance"] ?? "Error")
        
        QRCodeImage.image = qrCodeGenerator.generateQRCode(from: stringForQRCode)
    }
    
    private func darkMode(){
        var isDarkMode = "false"
        do {
            isDarkMode = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(isDarkModeActivated), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        
        if isDarkMode == "true" {
            self.tabBarController?.tabBar.barStyle = .black
            self.navigationController?.navigationBar.barStyle = .black
            self.view.backgroundColor = .black
            self.nomLabel.textColor = UIColor.init(red: 0.102, green: 0.483, blue: 1, alpha: 1)
        } else {
            self.tabBarController?.tabBar.barStyle = .default
            self.navigationController?.navigationBar.barStyle = .default
            self.view.backgroundColor = .white
            self.nomLabel.textColor = .blue
        }
    }
}
