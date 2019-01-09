//
//  ViewController.swift
//  A2L
//
//  Created by Nathan on 08/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import UIKit

class MaFiche: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var afficheListeAdherent: UIBarButtonItem!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var statut = "Adhérent"
        do {
            statut = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(testeur), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        if statut == "Membre du bureau" || statut == "Super-admin" {
            afficheListeAdherent.image = UIImage(named: "liste")
            afficheListeAdherent.isEnabled = true
        } else {
            afficheListeAdherent.image = nil
            afficheListeAdherent.isEnabled = false
        }
    }
    
   
    
}

