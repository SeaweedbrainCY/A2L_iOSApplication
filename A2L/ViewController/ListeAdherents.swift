//
//  ListeAdherents.swift
//  A2L
//
//  Created by Nathan on 09/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

//Ce controller est associé à controller sur la liste de tous les adhérents.

class ListeAdherent: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Sert a la bêta
    let listeAdherentsNom = ["MARTER Corentin", "MAUCHAMP Paul", "STCHEPINSKY Nathan", "LALLEMENT Sidonie", "MULLER Clémentine", "SUBTIL Emilie", "COLIN Séléna", "LEMARQUAND Lucie", "CHARLE Lise", "FERRY Delphine", "MORTAJINE Inès", "BOSSU Vincent"]
    let listeStatuts = ["Adhérent", "Membre du bureau", "Membre du bureau", "Adhérent", "Adhérent", "Adhérent", "Adhérent", "Adhérent", "Adhérent", "Super-admin", "Super-admin", "Super-admin"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell") //on associe la tableView au custom de Style/customeCelleTableView.swift
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // nbr de section
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Cellules par section
        switch section {
        case 0 : return listeAdherentsNom.count
        default : return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // nom des cellules
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        var isFound = false // si on ne trouve pas de correspondance
        for i in 0 ..< self.listeAdherentsNom.count { // on parcours le nom de tous les adhérents
            if indexPath.row == i { // on associe la cellule au nom correspondant
                cell.textLabel?.text = self.listeAdherentsNom[i] // noms
                cell.statut.text = "(\(self.listeStatuts[i]))" // on affiche le statut au milieu a droite
                isFound = true // on indique qu'on a trouvé
            }
        }
        if !isFound { // bug on a pas trouvé
            cell.textLabel?.text = "ERROR ÉLÈVE INTROUVABLE"
        }
        return cell
    }
    
    //Nom des sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "Adhérents 2018/2019"
        default : return "ERROR"
        }
    }
    
    //Actions lorsqu'on clique sur une cellule
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // cellule selctionnée
            switch indexPath.row {
            case 0 : break
            case 1 : break
            case 2 : performSegue(withIdentifier: "afficheFiche", sender: nil) // on active le segue pour aller sur la fiche de l'adhérent
            default : break
            }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
