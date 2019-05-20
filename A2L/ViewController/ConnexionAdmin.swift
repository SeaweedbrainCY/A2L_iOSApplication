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
    @IBOutlet weak var mdpLost: UIButton!
    
    var timer = Timer()
    var setAlertView = Timer()
    var timerTempsRestant = Timer()
    
    //view added :
    let vue = UIView()
    let messageAlert = UILabel()
    let tempsRestant = UILabel()
    let refreshTimeButton = UIButton()
    
    let gradient = CAGradientLayer()
    
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
        mdpLost.superview?.addSubview(mdpLost)
        
        mdpLost.titleLabel?.textAlignment = .center
        mdpLost.titleLabel?.numberOfLines = 3
        
        if  self.view.frame.size.width < 350{
            prenomField.translatesAutoresizingMaskIntoConstraints = true
            nomField.translatesAutoresizingMaskIntoConstraints = true
            mdpField.translatesAutoresizingMaskIntoConstraints = true
            
            mdpField.textAlignment = .left
            
            prenomField.frame.size.width = 250
            prenomField.center = CGPoint(x: 20 + prenomField.frame.size.width / 2, y: self.titreLabel.frame.origin.y + self.titreLabel.frame.size.height + 50)
            
            nomField.frame.size.width = 250
            nomField.center = CGPoint(x: 20 + nomField.frame.size.width / 2, y: self.prenomField.frame.origin.y + self.prenomField.frame.size.height + 30)
            
            mdpField.frame.size.width = 250
            mdpField.center = CGPoint(x: 20 + mdpField.frame.size.width / 2, y: self.nomField.frame.origin.y + self.nomField.frame.size.height + 30)
            
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //On vérifie qu'il est bien en droit d'essayer de tester un mot de passe
        var nbrErreurString = "0"
        do {
            nbrErreurString = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(nbrInvalidateMdpPath), encoding: .utf8)
        } catch {
            print("Fichier introuvable.")
        }
        let nbrErreur = Int(nbrErreurString)!
        if nbrErreur > 5 { // Nombre de mot de passe maximum dépassé
            setPopUpAlertView()
        }
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
            self.mdpLost.isHidden = true
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
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
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
                    nbrErreur += 1
                    let file = FileManager.default
                    file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(nbrInvalidateMdpPath).path, contents: String(nbrErreur).data(using: String.Encoding.utf8), attributes: nil)
                } else if nbrErreur > 5 { // Nombre de mot de passe maximum dépassé
                    //setAlertView = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(alertView), userInfo: nil, repeats: true)
                    setPopUpAlertView()
                    let api = APIConnexion()
                    api.returnLocalHours(returnDate: false, nbrError: nbrErreur)
                }
            } else if serveurReponse == "success" {
                //On a réussi, on transmet les données et on change de view
                let file = FileManager.default
                file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(nbrInvalidateMdpPath).path, contents: "0".data(using: String.Encoding.utf8), attributes: nil)
                performSegue(withIdentifier: "connexionReussie", sender: self)
            } else { // pour les erreurs inconnues
                self.alert("Impossible de se connecter au serveur", message: serveurReponse)
            }
            //On réinitialise l'erreur :
            
            serveurReponse = "nil"
            self.chargement.stopAnimating()
            self.connexionButton.isHidden = false // On réactive tout
            self.switchToAdherentPage.isHidden = false
            self.mdpLost.isHidden = false
        }
    }
    
    @objc func alertView(){
        if self.view.backgroundColor == .blue {
            gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            gradient.colors = [UIColor.red.cgColor, UIColor.white.cgColor]// rgb(173, 204, 255), rgb(113, 166, 252)
            self.view.backgroundColor = .red
        } else {
            gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            gradient.colors = [UIColor.white.cgColor, UIColor.red.cgColor]// rgb(173, 204, 255), rgb(113, 166, 252)
            self.view.backgroundColor = .blue
        }
    }
    
    private func setPopUpAlertView(){
        
        self.view.addSubview(vue)
        vue.frame.size.width = self.view.frame.size.width
        vue.frame.size.height = self.view.frame.size.height
        vue.center = CGPoint(x: self.view.center.x, y: 1000)
        vue.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        
        self.view.addSubview(messageAlert)
        messageAlert.frame.size.width = self.view.frame.size.width - 20
        messageAlert.frame.size.height = 300
        messageAlert.center.x = self.view.center.x
        messageAlert.frame.origin.y = 1000
        messageAlert.text = "Tu as dépassé le nombre d'erreur autorisée ... Bravo !!"
        messageAlert.font = UIFont(name: "Comfortaa-Bold", size: 30)
        messageAlert.textColor = .white
        messageAlert.lineBreakMode = .byWordWrapping
        messageAlert.numberOfLines = 3
        messageAlert.textAlignment = .center
        
        
        
        
        self.view.addSubview(tempsRestant)
        tempsRestant.frame.size.height = 300
        tempsRestant.frame.size.width = self.view.frame.size.width
        tempsRestant.center.x = self.view.center.x
        tempsRestant.center.y = 1000
        tempsRestant.text = "365,25 jours"
        tempsRestant.font = UIFont(name: "Comfortaa-Light", size: 45)
        tempsRestant.textColor = .red
        tempsRestant.numberOfLines = 3
        tempsRestant.lineBreakMode = .byWordWrapping
        tempsRestant.textAlignment = .center
        
        
        self.view.addSubview(refreshTimeButton)
        refreshTimeButton.frame.size.width = 280
        refreshTimeButton.frame.size.height = 60
        refreshTimeButton.frame.origin.y = 1000
        refreshTimeButton.center.x = tempsRestant.center.x
        refreshTimeButton.setTitle("  Il me reste combien de temps ? ;(  ", for: .normal)
        refreshTimeButton.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 20)
        refreshTimeButton.setTitleColor(.white, for: .normal)
        refreshTimeButton.layer.borderColor = UIColor.white.cgColor
        refreshTimeButton.titleLabel?.textAlignment = .center
        refreshTimeButton.titleLabel?.numberOfLines = 2
        refreshTimeButton.titleLabel?.lineBreakMode = .byWordWrapping
        refreshTimeButton.layer.borderWidth = 2
        refreshTimeButton.layer.cornerRadius = 30
        refreshTimeButton.addTarget(self, action: #selector(tempsRestantSelected), for: .touchUpInside)
        tempsRestantSelected(sender: refreshTimeButton)
        
        let animation = UIViewPropertyAnimator(duration: 3, dampingRatio: 10, animations: {
            self.vue.center.y = self.view.center.y
            self.messageAlert.frame.origin.y = 5
            self.tempsRestant.center = self.view.center
            self.refreshTimeButton.frame.origin.y = self.tempsRestant.frame.origin.y + self.tempsRestant.frame.size.height + 40
        })
        animation.startAnimation()
    }
    
    @objc private func tempsRestantSelected(sender: UIButton){
        sender.isEnabled = false
        sender.setTitleColor(.black, for: .normal)
        sender.layer.borderColor = UIColor.black.cgColor
        var nbrErreurString = "0"
        do {
            nbrErreurString = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(nbrInvalidateMdpPath), encoding: .utf8)
        } catch {
            print("Fichier introuvable.")
        }
        let nbrErreur = Int(nbrErreurString)!
        let api = APIConnexion()
        api.returnLocalHours(returnDate: true, nbrError: nbrErreur)
        timerTempsRestant = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(reponseTempsRestant), userInfo: nil, repeats: true)
    }
    
    @objc private func reponseTempsRestant(){
        if serveurReponse != "nil" { // on detecte une erreur
            timerTempsRestant.invalidate() // on desactive le compteur il ne sert plus à rien
            
            //Voici les différents types d'erreur qui peuvent arriver :
            if serveurReponse == "Erreur inconnue" {
                self.alert("Aucune réponse du serveur", message: "Une erreur inconnue s'est produite")
            } else if serveurReponse == "permission refusée" {
                self.alert("Serveur HS", message: "Le serveur auquel nous cherchons de nous connecter vient de nous refuser l'entrée ;(")
            } else if serveurReponse == "success" {
                var nextDate = "nil"
                do {
                    nextDate = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(nextDateConnexionAllowed), encoding: .utf8)
                } catch {
                    print("Fichier introuvable. ERREUR GRAVE")
                }
                if nextDate != "nil" {
                    let dateFormatteur = DateFormatter()
                    dateFormatteur.dateFormat = "YYYY-MM-dd HH:mm:ss"
                    let date = dateFormatteur.date(from: nextDate)
                    let current = dateFormatteur.date(from: currentDate)
                    
                    let formatteur = DateComponentsFormatter()
                    formatteur.allowedUnits = [.hour, .minute, .second]
                    formatteur.unitsStyle = .full
                    let deltaDate = formatteur.string(from: current!, to: date!)
                    print("Today = \(String(describing: current))")
                    print("next = \(String(describing: date))")
                    print("deltaDate =\(String(describing: deltaDate))")
                    
                    if deltaDate!.contains("-"){ // un nbr négatif
                        let animation = UIViewPropertyAnimator(duration: 1, dampingRatio: 2) {
                            self.vue.frame.origin.y = 1000
                            self.messageAlert.frame.origin.y = 1000
                            self.tempsRestant.frame.origin.y = 1000
                            self.refreshTimeButton.frame.origin.y = 1000
                        }
                        animation.startAnimation()
                    } else {
                        self.tempsRestant.text = deltaDate!
                    }
                }
            } else { // pour les erreurs inconnues
                self.alert("Impossible de se connecter au serveur", message: serveurReponse)
            }
            //On réinitialise l'erreur :
            self.refreshTimeButton.isEnabled = true
            self.refreshTimeButton.setTitleColor(.white, for: .normal)
            self.refreshTimeButton.layer.borderColor = UIColor.white.cgColor
            serveurReponse = "nil"
        }
    }
    
    
}
