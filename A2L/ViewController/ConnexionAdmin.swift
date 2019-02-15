//
//  ConnexionAdmin.swift
//  A2L
//
//  Created by Nathan on 24/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit



class ConnexionAdmin: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var nomField: UITextField!
    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var mdpField: UITextField!
    @IBOutlet weak var connexionButton: UIButton!
    @IBOutlet weak var chargement: UIActivityIndicatorView!
    @IBOutlet weak var switchToAdherentPage: UIButton!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //On utilise le delegate pour autoriser ou non certains charactères
        self.nomField.delegate = self
        self.prenomField.delegate = self
        self.mdpField.delegate = self
        
        setViewBackground() // On met le background en 2 couleurs différentes -> On doit dire à tous les éléments d'aller au dessus :
        
        titreLabel.superview?.addSubview(titreLabel)
        nomField.superview?.addSubview(nomField)
        prenomField.superview?.addSubview(prenomField)
        mdpField.superview?.addSubview(mdpField)
        connexionButton.superview?.addSubview(connexionButton)
        chargement.superview?.addSubview(chargement)
        switchToAdherentPage.superview?.addSubview(switchToAdherentPage)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // enlève le clavier au toucher
        self.view.endEditing(true)
    }
    
    func alert(_ title: String, message: String) { // pop up simple
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Pardon ...", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setViewBackground(){ // Instaure les couleurs de fond comme bleues et noires
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradient.colors = [UIColor.blue.cgColor, UIColor.black.cgColor]// rgb(173, 204, 255), rgb(113, 166, 252)
        self.view.layer.addSublayer(gradient)
        self.view.backgroundColor = .blue
    }
    
    @IBAction func connexionSelected(sender: UIButton){ // Connexion ...
        var isValid = true
        let listeField = [self.prenomField, self.nomField, self.mdpField]
        
        for field in listeField { // On verifie que tous les champs sont remplis
            if field!.text == "" || field!.text == nil {
                field!.shake()
                isValid = false
            }
        }
        
        if isValid { // Si tout est bon :
            //On commence le chargement :
            //On désactive le changement de page :
            self.switchToAdherentPage.isHidden = true
            self.connexionButton.isHidden = true // On cache le bouton de connexion
            self.chargement.startAnimating() // Pour afficher le chargement
            //On associe le nom et prénom :
            let database = APIConnexion()
            let hash = HashProtocol()
            var nom = self.nomField.text!
            var prenom = self.prenomField.text!
            let mdp = hash.SHA256(text: self.mdpField.text!) // DOIT ÊTRE IMPÉRATIVEMENT HASHER EN DEHORS DES PERIODES DE TEST
            
            if nom.contains(" "){ // Si on detecte un epsace
                let splitSpace = nom.split(separator: " ")
                for i in 0 ..< splitSpace.count {
                    //Explication : Cette boucle supprime les ' ' (espaces) indésirables à la fin du nom ou du prénom qui pourrait provoquer une erreur lors de la connexion. Ainsi pour s'assurer que l'espace contenu dans le nom est bien un espace séparant 2 MOTS, on découpe le nom en portion séparées pas des espaces, et on recolle les mots qui sont réels. Exemple 'Jean pierre' -> 'Jean pierre' et 'Jean pierre ' -> 'Jean pierre'
                    if i == 0 {
                        nom = String(splitSpace[i])
                    } else {
                        nom.append(String(splitSpace[i]))
                    }
                }
            }
            if prenom.contains(" "){ // Si on detecte un epsace
                let splitSpace = prenom.split(separator: " ")
                for i in 0 ..< splitSpace.count {
                    //idem que ci-dessus
                    if i == 0 {
                        prenom = String(splitSpace[i])
                    } else {
                        prenom.append(String(splitSpace[i]))
                    }
                }
            }
            self.startCompteur() //On lance la séquence de verification des reponses du serveur
            nom = database.convertionToHexaCode(nom)
            prenom = database.convertionToHexaCode(prenom) // Convertion pour convenir à l'URL
            let nomEtPrenom = "\(nom)%20\(prenom)"
            database.adminConnexion(nom: nomEtPrenom, mdpHashed: mdp) // On lance la requète au serveur via le PHP
        }
    }

    //On n'autorise pas les charactères suivants : impossible de les tapes ou les coller dans les champs
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet(charactersIn: "\"\\/.;,%:()»«¿¡[]{}|~<>•")) == nil
    }
    
    func startCompteur(){ // On lance un compteur qui permet de verfier toutes les secondes si on a une réponse du serveur
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
    }
    
    @objc private func verificationReponse(){ // est appelé par le compteur pour verifier si on a une réponse
        
        if serveurReponse != "nil" { // on detecte une erreur
            timer.invalidate() // on desactive le compteur il ne sert plus à rien
            
            //Voici les différents types d'erreur qui peuvent arriver :
            if serveurReponse == "inconnue" {
                self.alert("Aucune réponse du serveur", message: "J'crois que le serveur s'est mis en mode avion ...")
            } else if serveurReponse == "permission refusée" {
                self.alert("Permission refusée", message: "Rendez-vous à la prochaine AG de l'A2L, pour devenir membre du bureau ;)")
            } else if serveurReponse == "Mdp incorrect" {
                self.alert("Mot de passe incorrect", message: "Il faut noter son mot de passe voyons !")
                //On regarde s'il y a déjà eu des erreur dans le mot de passe :
                var nbrErreurString = "0"
                do {
                    nbrErreurString = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(nbrInvalidateMdpPath), encoding: .utf8)
                } catch {
                    print("Fichier introuvable.")
                }
                var nbrErreur = Int(nbrErreurString)!
                if nbrErreur <= 5 {
                    self.alert("Mot de passe incorrect", message: "\(nomField.text!) note ton mot de passe voyons !")
                } else if nbrErreur > 5 {
                    
                }
            } else if serveurReponse == "success" {
                //On a réussi, on transmet les données et on change de view
                performSegue(withIdentifier: "connexionReussie", sender: self)
            } else { // pour les erreurs inconnues
                self.alert("Impossible de se connecter au serveur", message: serveurReponse)
            }
            //On réinitialise l'erreur :
            
            if serveurReponse != "success" { // On vide les champs
                self.nomField.text = ""
                self.prenomField.text = ""
                self.mdpField.text = ""
            }
            serveurReponse = "nil"
            self.chargement.stopAnimating()
            self.connexionButton.isHidden = false // On réactive tout
            self.switchToAdherentPage.isHidden = false
        }
    }
}
