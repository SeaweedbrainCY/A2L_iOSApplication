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
    
    override func viewDidAppear(_ animated: Bool) { // lancée quand la vue load
        super.viewDidAppear(animated)
        
        var statut = "Adhérent"
        do { // on récupère les contenu de la mémoire 'testeur'
            statut = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(testeur), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        
        if statut == "Membre du bureau" || statut == "Super-admin" { // Si le statut du testeur possède des privilèges alors on lui donne accès au scanner
            print("activation button")
            scanner.title = "Scanner"
            scanner.isEnabled = true
        } else { // sinon on désactive le bouton
            print("desactiver button")
            scanner.title = " "
            scanner.isEnabled = false
        }
    }
}
