//
//  ViewController.swift
//  A2L
//
//  Created by Nathan on 08/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import UIKit

//Connecté à la première page

class MaFiche: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var afficheListeAdherent: UIBarButtonItem!
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var dateDeNaissanceLabel: UILabel!
    @IBOutlet weak var statutLabel: UILabel!
    
    var listeInfoAdherent = [[String:String]]() //listeDeToutes les infos
    
    
    var nom: String?
    var statut: String?
    var dateDeNaissance: String?
    var mdp: String?
    
    override func viewDidAppear(_ animated: Bool) { // lancée quand la vue load
        super.viewDidAppear(animated)

        
        
        var statut = "Adhérent"
        do {
            statut = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(testeur), encoding: .utf8)
        } catch {
            print("^^^^^^^^^Fichier introuvable.^^^^^^^^")
        }
        if statut == "Membre du bureau" || statut == "Super-admin" { // on affiche le bouton
            afficheListeAdherent.image = UIImage(named: "liste")
            afficheListeAdherent.isEnabled = true
        } else { // on désactive le bouton
            afficheListeAdherent.image = nil
            afficheListeAdherent.isEnabled = false
        }
    }
    
    func loadInfo(){
        //lancée lorsque la data est loaded
    }
    
    
    
}

