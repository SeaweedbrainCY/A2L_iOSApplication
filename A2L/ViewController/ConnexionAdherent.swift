//
//  ConnexionAdherent.swift
//  A2L
//
//  Created by Nathan on 27/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

let informationConnexionAdhrent = "infoConnexion.txt" // de la forme 'Stchepinsky Nathan#14/11/2002'
var infosAdherent = ["nil": "nil"]

class ConnexionAdherent: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var nomField: UITextField!
    @IBOutlet weak var jourField: UITextField!
    @IBOutlet weak var moisField: UITextField!
    @IBOutlet weak var anneeField: UITextField!
    @IBOutlet weak var connexionButton: UIButton!
    @IBOutlet weak var chargement: UIActivityIndicatorView!
    @IBOutlet weak var switchToAdminPage: UIButton!
    
    var timer = Timer() //Compteur pour le chrono
    var reponse = "nil" // réponse du serveur
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBackground() // On met le background en 2 couleurs différentes -> On doit dire à tous les éléments d'aller au dessus :
        self.titreLabel.superview?.addSubview(titreLabel)
        self.prenomField.superview?.addSubview(prenomField)
        self.nomField.superview?.addSubview(nomField)
        self.jourField.superview?.addSubview(jourField)
        self.moisField.superview?.addSubview(moisField)
        self.anneeField.superview?.addSubview(anneeField)
        self.connexionButton.superview?.addSubview(connexionButton)
        self.chargement.superview?.addSubview(chargement)
        self.switchToAdminPage.superview?.addSubview(switchToAdminPage)
        
        //On utilise le delegate pour autoriser ou non certains charactères
        prenomField.delegate = self
        nomField.delegate = self
        jourField.delegate = self
        moisField.delegate = self
        anneeField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // Enlève le clavier au toucher
        self.view.endEditing(true)
    }
    
    func alert(_ title: String, message: String) { // Pop up simple
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Pardon ...", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setViewBackground(){ // Instaure un fond de couleur verte et noire
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradient.colors = [UIColor.green.cgColor, UIColor.black.cgColor]// rgb(173, 204, 255), rgb(113, 166, 252)
        self.view.layer.addSublayer(gradient)
        self.view.backgroundColor = .blue
    }
    
    //On n'autorise pas les charactères suivants : impossible de les tapes ou les coller dans les champs
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet(charactersIn: "\"\\/.;,%:()»«¿¡[]{}|~<>•")) == nil
    }
    
    @IBAction func connexionSelected(sender: UIButton){ // Lorsque l'on se connecte
        
       var isValid = true
        let listeField = [self.prenomField, self.nomField, self.jourField, self.moisField, self.anneeField]
        
        for field in listeField { // On vérifie que les champs sont remplis
            if field!.text == "" || field!.text == nil {
                field!.shake()
                isValid = false
            }
        }
        
        let listeDateField = [self.jourField, self.moisField, self.anneeField]
        for field in listeDateField { // On verifie que les champs sont remplis de nombre entier uniquement
            if Int((field?.text!)!) == nil {
                isValid = false
                field?.shake()
            }
        }
        
        if isValid {
            //On commence le chargement :
            //On cache le bouton pour changer de page
            self.switchToAdminPage.isHidden = true
            self.connexionButton.isHidden = true// On cache le bouton pour se connecter
            self.chargement.startAnimating() // On le remplace par une icone de chargement
            //On associe le nom et prénom :
            let database = APIConnexion()
            var nom = self.nomField.text!
            var prenom = self.prenomField.text!
            
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
            self.startCompteur() // On débute la recherche de réponse du serveur
            nom = database.convertionToHexaCode(nom)
            prenom = database.convertionToHexaCode(prenom) // On convertit pour qu'ils soient confromes à l'URL
            let nomPrenom = "\(nom)%20\(prenom)"
            let dateNaissance = "\(self.anneeField.text!)%2d\(self.moisField.text!)%2d\(self.jourField.text!)"
            database.adherentConnexion(nom: nomPrenom, dateNaissance: dateNaissance) // On lance la requète au serveur via le PHP
        }
    }
    
    func startCompteur(){ // On lance un compteur qui permet de verfier toutes les secondes si on a une réponse du serveur
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
    }
    
    @objc private func verificationReponse(){ // est appelé par le compteur pour verifier si on a une réponse
        do { // Va chercher dans les mémoires si on a une réponse d'enregistrée
            reponse = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(erreurPath), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        if reponse != "nil" { // Si on a une réponse
            timer.invalidate() // On désactive le timer il ne sert plus a rien
            
            //Voici les différents type d'erreur qui peuvent arriver:
            if reponse == "inconnue" {
                self.alert("Aucune réponse du serveur", message: "J'crois que le serveur s'est mis en mode avion ...")
            } else if reponse == "Date de naissance incorrect" {
                self.alert("Date de naissance non valide", message: "Tu n'aurais quand même pas oublié ta propre date de naissance ?????")
            } else if reponse == "Élève introuvable" {
                self.alert("Adhérent introuvable", message: "T'es sûr et certain d'avoir payé ta cotisisation ? ;)")
                //On regarde s'il y a déjà eu des erreur dans le mot de passe :
                var nbrErreurString = "0"
                do {
                    nbrErreurString = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(nbrInvalidateMdpPath), encoding: .utf8)
                } catch {
                    print("Fichier introuvable.")
                }
                let nbrErreur = Int(nbrErreurString)!
                if nbrErreur <= 5 {
                    self.alert("Mot de passe incorrect", message: "\(nomField.text!) note ton mot de passe voyons !")
                } else if nbrErreur > 5 {
                    
                }
            } else if reponse == "success" {
                //La connexion est réussi et acceptée par le serveur
                performSegue(withIdentifier: "connexionReussie", sender: self)
            } else { // erreur inconnue
                self.alert("Impossible de se connecter au serveur", message: reponse)
            }
            if reponse != "success" { // On vide les champs si la connexion n'est pas réussie
                self.nomField.text = ""
                self.prenomField.text = ""
                self.anneeField.text = ""
                self.moisField.text = ""
                self.jourField.text = ""
            }
            //On réinitialise l'erreur :
            let file = FileManager.default
            file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(erreurPath).path, contents: "nil".data(using: String.Encoding.utf8), attributes: nil)
            self.chargement.stopAnimating()
            self.connexionButton.isHidden = false
            self.switchToAdminPage.isHidden = false
        }
    }
    
}
