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
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var listeButtonItem: UIBarButtonItem!
    
    var listeInfoAdherent = infosAdherent //listeDeToutes les infos
    var chargementView: UIActivityIndicatorView?
    var dateNaissanceAnchor:NSLayoutConstraint? // doit pouvoir être désactivée si besoin
    
    //Label du text
    let statut = UILabel()
    let nomAdherent = UILabel()
    let photoId = UIImageView()
    let dateNaissance = UILabel()
    let classe = UILabel()
    let pointFidelite = UILabel()
    
    
    var waitReponseImage = Timer()
    var timer = Timer()
    
    var currentTextColor = UIColor.black
    var currentTitleColor = UIColor.blue
    
    override func viewDidLoad() { // lancée quand la vue load
        super.viewDidLoad()
        darkMode()
        let localData = LocalData()
        localData.returnDataFrom(stockInfosAdherent) // On enregistre la data de l'user dans la base local
        listeInfoAdherent = infosAdherent
        print("=> \(listeInfoAdherent)")
        if listeInfoAdherent != ["nil":"nil"]{ // Si on a les infos
            
            loadAllView()
        }
        //On lance un timer pour verifier toutes les secondes si on a une réponse
        waitReponseImage = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(verificationReponseImage), userInfo: nil, repeats: true)
        
        if let _ = listeInfoAdherent["MdpHashed"] {
            listeButtonItem.image = UIImage(named: "liste")
            listeButtonItem.isEnabled = true
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        darkMode()
        if loadAnOtherAdherent != "nil" {
            self.afficheAllAdherentButtonSelected(sender: self.listeButtonItem)
        } else {
            if listeInfoAdherent == ["nil":"nil"]{ // On ne detecte aucune informations en local, on ne sait pas qui est l'adhérent donc on load la page de connexion
                reponseURLRequestImage = "no data"
                performSegue(withIdentifier: "connexionAdherent", sender: self)
            }
        }
        
        
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    private func loadAllView(){ // est appelé pour agencé les différents élements de la page
        print("load ....")
        self.backgroundView.addSubview(nomAdherent)
        nomAdherent.translatesAutoresizingMaskIntoConstraints = false
        nomAdherent.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        nomAdherent.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.topAnchor, multiplier: 4).isActive = true
        nomAdherent.textColor = currentTitleColor
        nomAdherent.font = UIFont(name: "Comfortaa-Bold", size: 30)
        nomAdherent.text = listeInfoAdherent["Nom"] ?? "Error"
        
        
        self.backgroundView.addSubview(photoId)
        photoId.translatesAutoresizingMaskIntoConstraints = false
        photoId.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        photoId.topAnchor.constraint(equalToSystemSpacingBelow: nomAdherent.bottomAnchor, multiplier: 2).isActive = true
        photoId.image = UIImage(named: "chargementEnCours")
        photoId.imageFromDatabase(idAdherent: listeInfoAdherent["id"]!)
        photoId.widthAnchor.constraint(equalToConstant: 300).isActive = true
        photoId.heightAnchor.constraint(equalToConstant: 300).isActive = true
        photoId.layer.cornerRadius = 20
        photoId.clipsToBounds = true
        
        
        
        
        self.backgroundView.addSubview(dateNaissance)
        dateNaissance.translatesAutoresizingMaskIntoConstraints = false
        dateNaissance.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        dateNaissanceAnchor = dateNaissance.topAnchor.constraint(equalToSystemSpacingBelow: photoId.bottomAnchor, multiplier: 4)
        dateNaissanceAnchor?.isActive = true
        dateNaissance.textColor = currentTitleColor
        dateNaissance.font = UIFont(name: "Comfortaa-Regular", size: 18)
        dateNaissance.text = "Date de naissance : \(listeInfoAdherent["DateNaissance"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        var coloration = NSMutableAttributedString(string: dateNaissance.text!)
        coloration.setColorForText(textForAttribute: "Date de naissance :", withColor: currentTextColor)
        coloration.setFontForText(textForAttribute: "Date de naissance :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        dateNaissance.attributedText = coloration
        
        
        self.backgroundView.addSubview(classe)
        classe.translatesAutoresizingMaskIntoConstraints = false
        classe.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        classe.topAnchor.constraint(equalToSystemSpacingBelow: dateNaissance.bottomAnchor, multiplier: 3).isActive = true
        classe.textColor = currentTitleColor
        classe.font = UIFont(name: "Comfortaa-Regular", size: 18)
        classe.text = "Classe : \(listeInfoAdherent["Classe"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: classe.text!)
        coloration.setColorForText(textForAttribute: "Classe :", withColor: currentTextColor)
        coloration.setFontForText(textForAttribute: "Classe :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        classe.attributedText = coloration
        
        
        
        self.backgroundView.addSubview(statut)
        statut.translatesAutoresizingMaskIntoConstraints = false
        statut.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        statut.topAnchor.constraint(equalToSystemSpacingBelow: classe.bottomAnchor, multiplier: 3).isActive = true
        statut.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 10).isActive = true
        statut.heightAnchor.constraint(equalToConstant: 50).isActive = true
        statut.lineBreakMode = .byClipping
        statut.numberOfLines = 2
        statut.textColor = currentTitleColor
        statut.font = UIFont(name: "Comfortaa-Regular", size: 18)
        var statutText = "Statut : \(listeInfoAdherent["Statut"] ?? "Error")"
        if let _ = listeInfoAdherent["MdpHashed"]{ // On indique comment il est connecté
            statutText.append(" (connecté \(listeInfoAdherent["Statut"]!))")
        } else {
            statutText.append(" (connecté adhérent)")
        }
        statut.text = statutText
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: statut.text!)
        coloration.setColorForText(textForAttribute: "Statut :", withColor: currentTextColor)
        coloration.setFontForText(textForAttribute: "Statut :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        statut.attributedText = coloration
        
        
        self.backgroundView.addSubview(pointFidelite)
        pointFidelite.translatesAutoresizingMaskIntoConstraints = false
        pointFidelite.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        pointFidelite.topAnchor.constraint(equalToSystemSpacingBelow: statut.bottomAnchor, multiplier: 3).isActive = true
        pointFidelite.textColor = currentTitleColor
        pointFidelite.font = UIFont(name: "Comfortaa-Regular", size: 18)
        pointFidelite.text = "Points de fidélité : \(listeInfoAdherent["PointFidelite"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: pointFidelite.text!)
        coloration.setColorForText(textForAttribute: "Points de fidélité :", withColor: currentTextColor)
        coloration.setFontForText(textForAttribute: "Points de fidélité :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        pointFidelite.attributedText = coloration
        
        putTextColor() // on affiche les couleurs
        
    }
    
    @objc func verificationReponseImage() { // Est appelé pour verifier si on a une réponse ou non du serveur
        print("verifcation image MaFiche = \(reponseURLRequestImage)")
        if reponseURLRequestImage != "nil" {
            if reponseURLRequestImage != "success" {
                if reponseURLRequestImage != "no data" { // sinon le bottom anchor n'est pas instancié et l'appli plante
                    print("error line 184")
                    self.photoId.image = UIImage(named: "binaireWorld") //image de bug
                    self.photoId.widthAnchor.constraint(equalToConstant: 150).isActive = true
                    self.photoId.heightAnchor.constraint(equalToConstant: 150).isActive = true
                    
                    let errorLabel = UILabel()
                    self.backgroundView.addSubview(errorLabel)
                    errorLabel.translatesAutoresizingMaskIntoConstraints = false
                    errorLabel.widthAnchor.constraint(equalToConstant: 390).isActive = true
                    errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    errorLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
                    errorLabel.topAnchor.constraint(equalToSystemSpacingBelow: (self.photoId.bottomAnchor), multiplier: -0.5).isActive = true
                    errorLabel.numberOfLines = 3
                    errorLabel.textColor = .red
                    errorLabel.font = UIFont(name: "Comfortaa-Light", size: 12)
                    errorLabel.text = "\(reponseURLRequestImage)"
                    errorLabel.textAlignment = .center
                    
                    
                    dateNaissanceAnchor?.isActive = false // On la désactive pour en instancier une nouvelle
                    dateNaissance.topAnchor.constraint(equalToSystemSpacingBelow: errorLabel.bottomAnchor, multiplier: 2).isActive = true

                    }
                } else {
                self.photoId.image = imageId!
            }
            reponseURLRequestImage = "nil"
            waitReponseImage.invalidate()
        }
        
        
    }
    
    @IBAction func afficheAllAdherentButtonSelected(sender:UIBarButtonItem){
        sender.tintColor = .gray
        sender.isEnabled = false // on empêche de cliquer 2 fois sinon BUUUUUUg youpi
        let api = APIConnexion()
        api.exctractAllData(nom: api.convertionToHexaCode(infosAdherent["Nom"] ?? "Error"), mdpHashed: infosAdherent["MdpHashed"] ?? "Error")
        //On lance un timer pour verifier toutes les secondes si on a une réponse
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(listeSelectedVerificationReponse), userInfo: nil, repeats: true)
        if waitReponseImage.isValid{
            reponseURLRequestImage = "Le chargement a été interrompu;( Pas cool .."
        }
    }
    
    
    @objc private func listeSelectedVerificationReponse(){
        
        if serveurReponse != "nil" { // on detecte une réponse
            timer.invalidate() // on desactive le compteur il ne sert plus à rien
            listeButtonItem.tintColor = .blue
            listeButtonItem.isEnabled = true
            
            if serveurReponse == "success" {
                //On a réussi, on transmet les données et on change de view
                performSegue(withIdentifier: "afficheAllAdherent", sender: self)
            } else { // Une erreur est survenue
                self.alert("Erreur lors de la connexion au serveur", message: serveurReponse)
            }
            serveurReponse = "nil"
        }
    }
    
    var waitReponse = Timer()
    func searchForData() { // regarde si on peut acceder au serveur et chargé les données les plus récentes :
        let api = APIConnexion()
        if let mdp = listeInfoAdherent["MdpHashed"] { // connecté admin
            api.adminConnexion(nom: api.convertionToHexaCode(listeInfoAdherent["Nom"]!), mdpHashed: api.convertionToHexaCode(mdp))
        } else { // connecté adhérent
            api.adherentConnexion(nom: api.convertionToHexaCode(listeInfoAdherent["Nom"]!), dateNaissance: listeInfoAdherent["DateNaissance"]!)
        }
        
        
        waitReponse = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(reponseServeurDataAdherent), userInfo: nil, repeats: true)
    }
    
    @objc private func reponseServeurDataAdherent() { // attend la réponse du serveur dans la recherche de données de l'utulisateur
        if serveurReponse != "nil" { // Si on a une réponse
            waitReponse.invalidate() // On désactive le timer il ne sert plus a rien
            
            if serveurReponse == "success" {
                listeInfoAdherent = infosAdherent // on actualise la variable local
            }
            
            loadAllView()
            
            //On réinitialise l'erreur :
            serveurReponse = "nil"
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "afficheAllAdherent" && loadAnOtherAdherent != "nil"{
            let transfere = segue.destination as! ListeAdherent
            transfere.loadAdherent = loadAnOtherAdherent
            loadAnOtherAdherent = "nil" // on réinitilise
        }
    }
    
    private func darkMode(){
        var isDarkMode = "false"
        do {
            isDarkMode = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(isDarkModeActivated), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        
        if isDarkMode == "true" {
            self.backgroundView.backgroundColor = .black
            self.tabBarController?.tabBar.barStyle = .black
            self.navigationController?.navigationBar.barStyle = .black
            self.currentTextColor = .white
            self.currentTitleColor = UIColor.init(red: 0.102, green: 0.483, blue: 1, alpha: 1)
            self.view.backgroundColor = .black
            if photoId.image != nil { // signifie que les view sont loaded
                putTextColor()
            }
            
        } else {
            self.backgroundView.backgroundColor = .white
            self.tabBarController?.tabBar.barStyle = .default
            self.navigationController?.navigationBar.barStyle = .default
            self.currentTextColor = .black
            self.currentTitleColor = .blue
            self.view.backgroundColor = .white
            if photoId.image != nil { // signifie que les view sont loaded
                putTextColor()
            }
        }
    }
    
    private func putTextColor(){ // instnacie/change la couleur
        
        nomAdherent.textColor = currentTitleColor
        
        
        dateNaissance.textColor = currentTitleColor
        var coloration = NSMutableAttributedString(string: dateNaissance.text!)
        coloration.setColorForText(textForAttribute: "Date de naissance :", withColor: currentTextColor)
        coloration.setFontForText(textForAttribute: "Date de naissance :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        dateNaissance.attributedText = coloration
        
        
        classe.textColor = currentTitleColor
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: classe.text!)
        coloration.setColorForText(textForAttribute: "Classe :", withColor: currentTextColor)
        coloration.setFontForText(textForAttribute: "Classe :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        classe.attributedText = coloration
        
        
        statut.textColor = currentTitleColor
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: statut.text!)
        coloration.setColorForText(textForAttribute: "Statut :", withColor: currentTextColor)
        coloration.setFontForText(textForAttribute: "Statut :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        statut.attributedText = coloration
        
        
        pointFidelite.textColor = currentTitleColor
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: pointFidelite.text!)
        coloration.setColorForText(textForAttribute: "Points de fidélité :", withColor: currentTextColor)
        coloration.setFontForText(textForAttribute: "Points de fidélité :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        pointFidelite.attributedText = coloration
    }
    
}

