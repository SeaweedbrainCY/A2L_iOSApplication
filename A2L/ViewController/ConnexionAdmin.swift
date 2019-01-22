//
//  ConnexionAdmin.swift
//  A2L
//
//  Created by Nathan on 19/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

let compteurEssai = "compteurEssai.text" // On y range le nombre de tentative effectuée sur un téléphone pour éviter les attaques par force brut

class connexionAdmin: UIViewController, UITextFieldDelegate {
    
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
        
        prenomField.delegate = self
        nomField.delegate = self
        mdpField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Pardon ...", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    func setViewBackground(){
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradient.colors = [UIColor.green.cgColor, UIColor.black.cgColor]// rgb(173, 204, 255), rgb(113, 166, 252)
        self.view.layer.addSublayer(gradient)
    }
    
    @IBAction func connexionSelected(sender: UIButton) {
        var autorisation = true
        var prenomText = self.prenomField.text
        var mdp = self.mdpField.text
        var nomText = self.nomField.text
        
        if prenomText != nil && prenomText != ""{ // Le champ est  remplie
            
            if autorisation { // Si il a bien passé les premiers tests
                if prenomText!.contains(" ") { // Si on detecte un commentaire
                    let splitSpace = prenomText!.split(separator: " ") // On découpe pour savoir cb on trouve d'espace
                    for i in 0 ..< splitSpace.count {
                        //Explication : On découpe le nom en plusieurs séquences s'il y a des espaces. Si les espaces sont au milieu d'un prénom comme 'Jean Claude', on a donc 2 séquence qu'on recolle l'une à l'autre avec un espace
                        //En revanche, si on a 'Jean Claude ', on a 2 espaces. Mais que 2 séquences. On ne recolle donc que les deux séquences et le dernier espace qui nous gène est viré.
                        if i == 0 {
                            prenomText! = String(splitSpace[i])
                        } else {
                            prenomText!.append(" \(splitSpace[i])")
                        }
                    }
                    self.prenomField.text = prenomText!
                }
            }
        } else {
            //Champ pas rempli
            autorisation = false
            self.prenomField.shake()
        }
        
        if autorisation { // Si on est toujours autorisé
            
            if nomText != nil && nomText != ""{ // Le champ est  remplie
                
                if autorisation { // Si il a bien passé les premiers tests
                    if nomText!.contains(" ") { // Si on detecte un commentaire
                        let splitSpace = nomText!.split(separator: " ") // On découpe pour savoir cb on trouve d'espace
                        for i in 0 ..< splitSpace.count {
                            //Explication : Voir ci-dessus
                            if i == 0 {
                                nomText! = String(splitSpace[i])
                            } else {
                                nomText!.append(" \(splitSpace[i])")
                            }
                        }
                        self.nomField.text = nomText!
                    }
                }
            } else {
                //Champ pas rempli
                autorisation = false
                self.nomField.shake()
            }
        }
        
        if autorisation { // Si on est toujours autorisé
            if mdp != nil && mdp != ""{ // Le champ est  remplie
            } else {
                //Champ pas rempli
                autorisation = false
                self.mdpField.shake()
            }
        }
        
        if autorisation { // Si tous nos champs sont remplis correctement
            let nomPrenom = "\(nomText!)%20\(prenomText!)" // On associe le nom au prénom
            let connexion = APIConnexion()
            let urlNomPrenom = connexion.convertionToHexaCode(nomPrenom) // Onvertion en url
            
            let hashage = HashProtocol()
            #warning("              Pour les phases de test on ne hash pas les mdp !!")
            let hashMdp = mdp! //hashage.SHA256(text: mdp!) // On hash le mot de passe : TRÈS IMPORTANT
            
            connexion.exctractData(nom: urlNomPrenom, mdpHashed: hashMdp) // Et on envoie la requète
        }
    }
    
    //Est appelé lorsque la connexion à la database est refusée
    func errorWhileConnectingToDatabase(erreur : String ){
        if erreur == "Autorisation refusée" {
            self.alert("Permission refusée", message: "Je suis vraiment désolé mais il semblerait que tu n'aies pas vraiment la permission ... File dans ta chambre !")
        } else if erreur == "Mdp incorrect" {
            self.alert("Un problème avec le mot de passe", message: "Boh pourquoi tu n'as pas rentré ton bon mot de passe ? :(")
        }
        // On recupère le nombre de tentative déjà effectuée
        var tentative = "0"
        do {
            tentative = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(compteurEssai), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        
        var nbrTentative = Int(tentative)! // On le convertit en nbr
        nbrTentative += 1 // On en ajoute une
        
        if nbrTentative > 5 { // Si on est déjà à plus de 5 tentatives on bloque l'accès
            
        }
    }
    
    //Liste des caractères NON autorisés. Il serviront à l'envoie via l'URL
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Si il fait parti de la liste des caractères autorisé : on l'affiche.
        if (string.rangeOfCharacter(from: CharacterSet(charactersIn: "/:;() »«.,¿¡’[]{}^|~<>•\\`'\""))) == nil {
            return true
        } else {
            return false
        }
        
    }
}
