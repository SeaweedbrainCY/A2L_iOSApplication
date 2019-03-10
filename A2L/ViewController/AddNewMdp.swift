//
//  AddNewMdp.swift
//  A2L
//
//  Created by Nathan on 23/02/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class AddNewMdp: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var titreLabel: UILabel!
    @IBOutlet weak var prenomField: UITextField!
    @IBOutlet weak var nomField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var annulerButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var validerButton: UIButton!
    @IBOutlet weak var chargement: UIActivityIndicatorView!
    
    //View créée ici
    let mdpFieldLabel = UILabel()
    let mdpField = UITextField()
    let mdpConfirmedLabel = UILabel()
    let mdpConfirmedField = UITextField()
    
    var waitForServer = Timer()
    var nomPrenom = "nil"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewBackground()
        titreLabel.superview?.addSubview(titreLabel)
        codeField.superview?.addSubview(codeField)
        annulerButton.superview?.addSubview(annulerButton)
        helpButton.superview?.addSubview(helpButton)
        validerButton.superview?.addSubview(validerButton)
        prenomField.superview?.addSubview(prenomField)
        nomField.superview?.addSubview(nomField)
        chargement.superview?.addSubview(chargement)
        
        codeField.delegate = self
        codeField.textAlignment = .center
        
    }
    
    private func changementViews() { // Premières view qui sont montrées
        
        self.view.addSubview(self.mdpField)
        self.mdpField.frame.size.width = self.view.frame.size.width - 40
        self.mdpField.frame.size.height = 30
        self.mdpField.frame.origin = CGPoint(x: -500, y: self.titreLabel.frame.origin.y + 90)
        self.mdpField.borderStyle = .roundedRect
        self.mdpField.font = UIFont(name: "Comfortaa-Light", size: 17)
        self.mdpField.textColor = .blue
        self.mdpField.keyboardAppearance = .dark
        self.mdpField.isSecureTextEntry = true
        self.mdpField.placeholder = "Nouveau mot de passe"
        self.mdpField.clearButtonMode = .whileEditing
        
        self.view.addSubview(self.mdpFieldLabel)
        self.mdpFieldLabel.frame.size.width = self.view.frame.size.width - 15
        self.mdpFieldLabel.frame.size.height = 50
        self.mdpFieldLabel.frame.origin.y = self.mdpField.frame.origin.y - mdpField.frame.size.height - 10
        self.mdpFieldLabel.frame.origin.x = -500
        self.mdpFieldLabel.numberOfLines = 1
        self.mdpFieldLabel.text = "Nouveau mot de passe :"
        self.mdpFieldLabel.textColor = .white
        self.mdpFieldLabel.font = UIFont(name: "Comfortaa-Bold", size: 19)
        
        self.view.addSubview(self.mdpConfirmedField)
        self.mdpConfirmedField.frame.size.width = self.view.frame.size.width - 40
        self.mdpConfirmedField.frame.size.height = 30
        self.mdpConfirmedField.frame.origin = CGPoint(x: -500, y: self.mdpField.frame.origin.y + 90)
        self.mdpConfirmedField.borderStyle = .roundedRect
        self.mdpConfirmedField.font = UIFont(name: "Comfortaa-Light", size: 17)
        self.mdpConfirmedField.textColor = .blue
        self.mdpConfirmedField.keyboardAppearance = .dark
        self.mdpConfirmedField.isSecureTextEntry = true
        self.mdpConfirmedField.placeholder = "Confirmer le mot de passe"
        self.mdpConfirmedField.clearButtonMode = .whileEditing
        
        self.view.addSubview(self.mdpConfirmedLabel)
        self.mdpConfirmedLabel.frame.size.width = self.view.frame.size.width - 15
        self.mdpConfirmedLabel.frame.size.height = 50
        self.mdpConfirmedLabel.frame.origin.y = self.mdpConfirmedField.frame.origin.y  - self.mdpConfirmedField.frame.size.height - 10
        self.mdpConfirmedLabel.frame.origin.x = -500
        self.mdpConfirmedLabel.numberOfLines = 1
        self.mdpConfirmedLabel.text = "Confirmer le mot de passe :"
        self.mdpConfirmedLabel.textColor = .white
        self.mdpConfirmedLabel.font = UIFont(name: "Comfortaa-Bold", size: 19)
        
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func helpSelected(sedner: UIButton){
        alert("Code confidentiel", message: "Pour garantir la sécurité seule les membres du bureau peuvent vous fournir le code confidentiel à 4 chiffres.")
    }
    
    @IBAction func annulerSelected(_ sender: Any) {
        performSegue(withIdentifier: "returnToPageConnexion", sender: self)
    }
    
    @IBAction func validerSelected(sender: UIButton) {
        self.view.endEditing(true)
        if sender.currentTitle! == "Valider" {
            var isValid = true
            let listeField = [self.prenomField, self.nomField, self.codeField]
            
            for field in listeField { // On vérifie que les champs sont remplis
                if field!.text == "" || field!.text == nil {
                    field!.shake()
                    isValid = false
                }
            }
            
            if codeField.text?.count != 4 {
                codeField.shake()
                alert("Le code doit comporter 4 chiffres", message: "Allez on compte ensemble ! 1...2...3...et 4")
                isValid = false
            }
            
            if isValid {
                //On commence le chargement :
                //On cache le bouton pour changer de page
                self.annulerButton.isEnabled = false
                self.validerButton.isHidden = true// On cache le bouton pour se connecter
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
                self.waitForServer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
                nom = database.convertionToHexaCode(nom)
                prenom = database.convertionToHexaCode(prenom) // On convertit pour qu'ils soient confromes à l'URL
                let nomPrenom = "\(nom) \(prenom)"
                self.nomPrenom = nomPrenom
                database.checkCodeTemporaire(nom: nomPrenom, codeTemporaire: self.codeField.text!) // On lance la requète au serveur via le PHP
            }
        } else if sender.currentTitle! == "Confirmer"{
            var isValid = true
            let listeField = [self.mdpField, self.mdpConfirmedField]
            
            for field in listeField { // On vérifie que les champs sont remplis
                if field.text == "" || field.text == nil {
                    field.shake()
                    isValid = false
                }
            }
            
            if self.mdpField.text != self.mdpConfirmedField.text { // Les deux sont égaux
                self.mdpConfirmedField.shake()
                isValid = false
                alert("Les deux mots de passes ne correspondent pas", message: "Tu veux mes lunettes ? ;)")
            }
            
            if isValid{
                let pushServeur = PushDataServer()
                let hashProtocol = HashProtocol()
                pushServeur.stockNewMdp(nom: self.nomPrenom, mdp: hashProtocol.SHA256(text: self.mdpField.text!), codeTemporaire: self.codeField.text!)
                waitForServer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
            }
        }
        
    }
    
    
    func setViewBackground(){ // Instaure un fond de couleur verte et noire
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradient.colors = [UIColor.red.cgColor, UIColor.black.cgColor]// rgb(173, 204, 255), rgb(113, 166, 252)
        self.view.layer.addSublayer(gradient)
        self.view.backgroundColor = .blue
    }
    
    
    //On n'autorise que 4 caractères
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 < 4{
            return true // < à 4 donc on autorise
        } else {
            if (string.rangeOfCharacter(from: CharacterSet(charactersIn: "0123456789")) != nil) { // On autorise uniquement de supprimer les caractères pas en rajouter
                return false
            } else {
                return true
            }
            
        }
    }
    
    
    @objc private func verificationReponse(){
        if serveurReponse != "nil" {
            waitForServer.invalidate()
            self.chargement.stopAnimating()
                if validerButton.currentTitle == "Valider"{
                    self.validerButton.isHidden = false
                    self.annulerButton.isEnabled = true
                    if serveurReponse == "success" {
                        changementViews()
                        let animation = UIViewPropertyAnimator(duration: 1.5, dampingRatio: 5, animations: {
                            self.mdpField.frame.origin.x = 16
                            self.mdpFieldLabel.frame.origin.x = 16
                            self.mdpConfirmedField.frame.origin.x = 16
                            self.mdpConfirmedLabel.frame.origin.x = 16
                        })
                        animation.startAnimation()
                    self.validerButton.setTitle("Confirmer", for: .normal)
                    self.nomField.isHidden = true
                    self.prenomField.isHidden = true
                    self.codeField.isHidden = true
                    self.helpButton.isHidden = true
                    } else if serveurReponse == "Code temporaire faux"{
                        alert("Code faux", message: "Un membre du bureau doit accéder à l'application, liste adhérent -> votre fiche -> Générer un code confidentiel temporaire")
                    }else if serveurReponse == "Aucun code temporaire"{
                        alert("Aucun code temporaire vous est associé", message: "Un membre du bureau doit accéder à l'application, liste adhérent -> votre fiche -> Générer un code confidentiel temporaire")
                    } else if serveurReponse == "Accès au serveur refusé" {
                        alert("Accès au serveur refusé", message: "T'es sûr(e) et certain(e) que tu as le droit d'avoir un mot de passe ? Vérifie tes informations ;)")
                    } else {
                        alert("Une erreur mystérieuse est survenue", message: "Magie et serveurs ne font pas bon ménage ... Je ne sais même pas ce qu'il fait, je ne le trouve plus :(")
                    }
                } else if validerButton.currentTitle == "Confirmer" { // remplissage des mots de passe
                    if serveurReponse == "success" {
                        performSegue(withIdentifier: "returnToPageConnexion", sender: self)
                    } else if serveurReponse == "Accès au serveur refusé"{
                        alert("Accès au serveur refusé", message: "Vérifié que vous êtes bien membre du bureau et que les informations sont exactes")
                    } else {
                        alert("Une erreur mystérieuse est survenue", message: "Magie et serveurs ne font pas bon ménage ... Je ne sais même pas ce qu'il fait, je ne le trouve plus :(")
                    }
            }
                
        }
    }
    
    
}
