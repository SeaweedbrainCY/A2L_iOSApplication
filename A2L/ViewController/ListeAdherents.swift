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

class ListeAdherent: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Sert a la bêta
    var listeAdherentsNom:[String] = []
    var listeStatuts:[String] = []
    var listeDateNaissance:[String] = [] // sert à la connexion au serveur pour afficher les infos
    var listeClasse:[String] = []
    var chargement = UIActivityIndicatorView()
    
    var loadAdherent = "nil"
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //On stock manuelleme,t toutes les données dont on aura besoin pour le tableView
        for infos in infosAllAdherent {
            if infos != [:] {
                let nom = "\(infos["Nom"]!)"
                let statut = "\(infos["Statut"]!)"
                let dateNaissance = "\(infos["dateNaissance"]!)"
                let classe = "\(infos["Classe"]!)"
                if listeAdherentsNom == [] {
                    listeAdherentsNom = [infos["Nom"]!]
                } else {
                    listeAdherentsNom.append(nom)
                }
                if listeStatuts == [] {
                    listeStatuts = [infos["Statut"]!]
                } else {
                    listeStatuts.append(statut)
                }
                if listeDateNaissance == [] {
                    listeDateNaissance = [infos["dateNaissance"]!]
                } else {
                    listeDateNaissance.append(dateNaissance)
                }
                if listeClasse == [] {
                    listeClasse = [infos["Classe"]!]
                } else {
                    listeClasse.append(classe)
                }
            }
            tableView.delegate = self
            tableView.dataSource = self
            searchBar.delegate = self
            searchBar.superview?.addSubview(searchBar)
            
            tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell") //on associe la tableView au custom de Style/customeCelleTableView.swift
            
            //On instancie le viewActivity :
            chargement.hidesWhenStopped = true
            chargement.style = .whiteLarge
            chargement.color = .red
            self.tableView.addSubview(chargement)
            chargement.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            
            //Si on est super-admin ou developpeur on peut ajouter des élèves :
            if infosAdherent["Statut"] == "Développeur" || infosAdherent["Statut"] == "Super-admin" {
                self.addButton.image = UIImage(named: "add")
                self.addButton.isEnabled = true
            }
        }
        var isDarkMode = "false"
        do {
            isDarkMode = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(isDarkModeActivated), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        
        if isDarkMode == "true" {
            self.tableView.backgroundColor = UIColor.init(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
            self.tabBarController?.tabBar.barStyle = .black
            self.navigationController?.navigationBar.barStyle = .black
            self.view.backgroundColor = .black
            self.searchBar.barStyle = .black
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loadAdherent != "nil"{
            let infos = loadAdherent.split(separator: "%")
            let api = APIConnexion()
            api.otherAdherentData(nom: String(infos[0]), dateNaissance: String(infos[1]))
            //On lance un timer pour verifier toutes les secondes si on a une réponse
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(listeSelectedVerificationReponse), userInfo: nil, repeats: true)
            chargement.startAnimating()
            loadAdherent = "nil" //on réinitialise 
        }
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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
        var isDarkMode = "false"
        do {
            isDarkMode = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(isDarkModeActivated), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        
        if isDarkMode == "true" {
            cell.backgroundColor = .black
            cell.textLabel?.textColor = .white
        } else {
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
        }
        
        var isFound = false // si on ne trouve pas de correspondance
        for i in 0 ..< self.listeAdherentsNom.count { // on parcours le nom de tous les adhérents
            if indexPath.row == i { // on associe la cellule au nom correspondant
                cell.textLabel?.text = self.listeAdherentsNom[i] // noms
                cell.statut.text = "\(self.listeClasse[i])  (\(self.listeStatuts[i]))" // on affiche le statut au milieu a droite
                isFound = true // on indique qu'on a trouvé
                cell.addSubview(cell.statut)
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
        for i in 0 ..< listeAdherentsNom.count {
            if i == indexPath.row { //index.path = numéro du nom sélectionné
                let api = APIConnexion()
                api.otherAdherentData(nom: listeAdherentsNom[i], dateNaissance: listeDateNaissance[i])
                //On lance un timer pour verifier toutes les secondes si on a une réponse
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(listeSelectedVerificationReponse), userInfo: nil, repeats: true)
                chargement.startAnimating()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc private func listeSelectedVerificationReponse(){
        if serveurReponse != "nil" { // on detecte une réponse
            timer.invalidate() // on desactive le compteur il ne sert plus à rien
            chargement.stopAnimating()
            if serveurReponse == "success" {
                //On a réussi, on transmet les données et on change de view
                performSegue(withIdentifier: "afficheFicheAdherent", sender: self)
            } else { // Une erreur est survenue
                self.alert("Erreur lors de la connexion au serveur", message: serveurReponse)
            }
            serveurReponse = "nil"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "afficheFicheAdherent" {
            let transfere = segue.destination as! FicheAdherent
            transfere.listeAllNom = self.listeAdherentsNom
        } else if segue.identifier == "addNewAdherent" {
            let destination = segue.destination as! AddNewAdherent
            destination.listeAllNom = self.listeAdherentsNom
        }
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listeAdherentsNom = []
        listeDateNaissance = []
        listeStatuts = []
        listeClasse = []
        
        if searchText == ""{
            for infos in infosAllAdherent {
                if infos != [:]{
                    let nom = "\(infos["Nom"]!)"
                    let statut = "\(infos["Statut"]!)"
                    let dateNaissance = "\(infos["dateNaissance"]!)"
                    let classe = "\(infos["Classe"]!)"
                    
                    
                    
                    if listeAdherentsNom == [] {
                        listeAdherentsNom = [infos["Nom"]!]
                    } else {
                        listeAdherentsNom.append(nom)
                    }
                    if listeStatuts == [] {
                        listeStatuts = [infos["Statut"]!]
                    } else {
                        listeStatuts.append(statut)
                    }
                    if listeDateNaissance == [] {
                        listeDateNaissance = [infos["dateNaissance"]!]
                    } else {
                        listeDateNaissance.append(dateNaissance)
                    }
                    if listeClasse == [] {
                        listeClasse = [infos["Classe"]!]
                    } else {
                        listeClasse.append(classe)
                    }
                }
            }
        } else {
            for infos in infosAllAdherent {
                if infos != [:] && ((infos["Nom"]?.contains(searchText))! || (infos["Classe"]?.contains(searchText))! || (infos["Statut"]?.contains(searchText))!){
                    let nom = "\(infos["Nom"]!)"
                    let statut = "\(infos["Statut"]!)"
                    let dateNaissance = "\(infos["dateNaissance"]!)"
                    let classe = "\(infos["Classe"]!)"
                    
                    if listeAdherentsNom == [] {
                        listeAdherentsNom = [infos["Nom"]!]
                    } else {
                        listeAdherentsNom.append(nom)
                    }
                    if listeStatuts == [] {
                        listeStatuts = [infos["Statut"]!]
                    } else {
                        listeStatuts.append(statut)
                    }
                    if listeDateNaissance == [] {
                        listeDateNaissance = [infos["dateNaissance"]!]
                    } else {
                        listeDateNaissance.append(dateNaissance)
                    }
                    if listeClasse == [] {
                        listeClasse = [infos["Classe"]!]
                    } else {
                        listeClasse.append(classe)
                    }
                }
            }
        }
            tableView.reloadData()
    }
    
}
