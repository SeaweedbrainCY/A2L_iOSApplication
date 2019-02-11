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
    var imageView:UIImageView?
    var dateNaissanceLabelAnchor:NSLayoutConstraint? // doit pouvoir être désactivée si besoin
    var dateNaissanceLabel: UILabel?
    
    var timer = Timer()
    
    override func viewDidLoad() { // lancée quand la vue load
        super.viewDidLoad()
        
        let localData = LocalData()
        localData.returnDataFrom(stockInfosAdherent) // On enregistre la data de l'user dans la base local
        listeInfoAdherent = infosAdherent
        print("=> \(listeInfoAdherent)")
        if listeInfoAdherent != ["nil":"nil"]{ // Si on a les infos
            let api = APIConnexion()
            
            loadAllView()
        } 
        //On lance un timer pour verifier toutes les secondes si on a une réponse
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
        
        if let _ = listeInfoAdherent["Mdp"] {
            listeButtonItem.image = UIImage(named: "liste")
            listeButtonItem.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if listeInfoAdherent == ["nil":"nil"]{ // On ne detecte aucune informations en local, on ne sait pas qui est l'adhérent donc on load la page de connexion
            performSegue(withIdentifier: "connexionAdherent", sender: self)
        }
    }
    
    func alert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    private func loadAllView(){ // est appelé pour agencé les différents élements de la page
        let api = APIConnexion()
        let nomAdherent = UILabel()
        self.backgroundView.addSubview(nomAdherent)
        nomAdherent.translatesAutoresizingMaskIntoConstraints = false
        nomAdherent.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        nomAdherent.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.topAnchor, multiplier: 4).isActive = true
        nomAdherent.textColor = .blue
        nomAdherent.font = UIFont(name: "Comfortaa-Bold", size: 30)
        nomAdherent.text = listeInfoAdherent["Nom"] ?? "Error"
        
        let photoId = UIImageView()
        self.backgroundView.addSubview(photoId)
        photoId.translatesAutoresizingMaskIntoConstraints = false
        photoId.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        photoId.topAnchor.constraint(equalToSystemSpacingBelow: nomAdherent.bottomAnchor, multiplier: 2).isActive = true
        photoId.loadGif(name: "chargementGif")
        photoId.imageFromUrl(urlString: "http://192.168.1.64:8888/\(api.convertionToHexaCode(listeInfoAdherent["URLimg"]!))")
        photoId.widthAnchor.constraint(equalToConstant: 300).isActive = true
        photoId.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.imageView = photoId
        photoId.layer.cornerRadius = 20
        photoId.clipsToBounds = true
        
        
        
        let dateNaissance = UILabel()
        self.backgroundView.addSubview(dateNaissance)
        dateNaissance.translatesAutoresizingMaskIntoConstraints = false
        dateNaissance.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        dateNaissanceLabelAnchor = dateNaissance.topAnchor.constraint(equalToSystemSpacingBelow: photoId.bottomAnchor, multiplier: 4)
        dateNaissanceLabelAnchor?.isActive = true
        dateNaissance.textColor = .blue
        dateNaissance.font = UIFont(name: "Comfortaa-Regular", size: 18)
        dateNaissance.text = "Date de naissance : \(listeInfoAdherent["DateNaissance"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        var coloration = NSMutableAttributedString(string: dateNaissance.text!)
        coloration.setColorForText(textForAttribute: "Date de naissance :", withColor: .black)
        coloration.setFontForText(textForAttribute: "Date de naissance :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        dateNaissance.attributedText = coloration
        self.dateNaissanceLabel = dateNaissance
        
        let classe = UILabel()
        self.backgroundView.addSubview(classe)
        classe.translatesAutoresizingMaskIntoConstraints = false
        classe.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        classe.topAnchor.constraint(equalToSystemSpacingBelow: dateNaissance.bottomAnchor, multiplier: 3).isActive = true
        classe.textColor = .blue
        classe.font = UIFont(name: "Comfortaa-Regular", size: 18)
        classe.text = "Classe : \(listeInfoAdherent["Classe"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: classe.text!)
        coloration.setColorForText(textForAttribute: "Classe :", withColor: .black)
        coloration.setFontForText(textForAttribute: "Classe :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        classe.attributedText = coloration
        
        
        let statut = UILabel()
        self.backgroundView.addSubview(statut)
        statut.translatesAutoresizingMaskIntoConstraints = false
        statut.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        statut.topAnchor.constraint(equalToSystemSpacingBelow: classe.bottomAnchor, multiplier: 3).isActive = true
        statut.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 10).isActive = true
        statut.heightAnchor.constraint(equalToConstant: 50).isActive = true
        statut.lineBreakMode = .byClipping
        statut.numberOfLines = 2
        statut.textColor = .blue
        statut.font = UIFont(name: "Comfortaa-Regular", size: 18)
        var statutText = "Statut : \(listeInfoAdherent["Statut"] ?? "Error")"
        if let _ = listeInfoAdherent["Mdp"]{ // On indique comment il est connecté
            statutText.append(" (connecté \(listeInfoAdherent["Statut"]!))")
        } else {
            statutText.append(" (connecté adhérent)")
        }
        statut.text = statutText
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: statut.text!)
        coloration.setColorForText(textForAttribute: "Statut :", withColor: .black)
        coloration.setFontForText(textForAttribute: "Statut :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        statut.attributedText = coloration
        
        let pointFidelite = UILabel()
        self.backgroundView.addSubview(pointFidelite)
        pointFidelite.translatesAutoresizingMaskIntoConstraints = false
        pointFidelite.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        pointFidelite.topAnchor.constraint(equalToSystemSpacingBelow: statut.bottomAnchor, multiplier: 3).isActive = true
        pointFidelite.textColor = .blue
        pointFidelite.font = UIFont(name: "Comfortaa-Regular", size: 18)
        pointFidelite.text = "Points de fidélité : \(listeInfoAdherent["PointFidelite"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: pointFidelite.text!)
        coloration.setColorForText(textForAttribute: "Points de fidélité :", withColor: .black)
        coloration.setFontForText(textForAttribute: "Points de fidélité :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        pointFidelite.attributedText = coloration
        
    }
    
    @objc func verificationReponse() { // Est appelé pour verifier si on a une réponse ou non du serveur
        if reponseURLRequestImage != "nil" && reponseURLRequestImage != "success" && imageView != nil{
            self.imageView?.image = UIImage(named: "binaireWorld") //image de bug
            self.imageView?.widthAnchor.constraint(equalToConstant: 150).isActive = true
            self.imageView?.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            let errorLabel = UILabel()
            self.backgroundView.addSubview(errorLabel)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            errorLabel.widthAnchor.constraint(equalToConstant: 390).isActive = true
            errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
            errorLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
            errorLabel.topAnchor.constraint(equalToSystemSpacingBelow: (self.imageView?.bottomAnchor)!, multiplier: -0.5).isActive = true
            errorLabel.numberOfLines = 3
            errorLabel.textColor = .red
            errorLabel.font = UIFont(name: "Comfortaa-Light", size: 12)
            errorLabel.text = "\(reponseURLRequestImage)"
            errorLabel.textAlignment = .center
            
            
            dateNaissanceLabelAnchor?.isActive = false // On la désactive pour en instancier une nouvelle
            dateNaissanceLabel?.topAnchor.constraint(equalToSystemSpacingBelow: errorLabel.bottomAnchor, multiplier: 2).isActive = true
            
            timer.invalidate()
        }
    }
    
    @IBAction func afficheAllAdherentButtonSelected(sender:UIBarButtonItem){
        sender.tintColor = .gray
        sender.isEnabled = false // on empêche de cliquer 2 fois sinon BUUUUUUg youpi
        let api = APIConnexion()
        api.exctractAllData(nom: api.convertionToHexaCode(infosAdherent["Nom"] ?? "Error"), mdpHashed: api.convertionToHexaCode(infosAdherent["Mdp"] ?? "Error"))
        //On lance un timer pour verifier toutes les secondes si on a une réponse
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(listeSelectedVerificationReponse), userInfo: nil, repeats: true)
    }
    
    
    @objc private func listeSelectedVerificationReponse(){
        var reponse = "nil"
        do {// On regarde l'erreur qui est actuellement enregistrée dans les fichiers
            reponse = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(reponseServeur), encoding: .utf8)
        } catch {
            print("Fichier introuvable. ERREUR GRAVE")
        }
        if reponse != "nil" { // on detecte une réponse
            timer.invalidate() // on desactive le compteur il ne sert plus à rien
            listeButtonItem.tintColor = .blue
            listeButtonItem.isEnabled = true
            
            if reponse == "success" {
                //On a réussi, on transmet les données et on change de view
                performSegue(withIdentifier: "afficheAllAdherent", sender: self)
            } else { // Une erreur est survenue
                self.alert("Erreur lors de la connexion au serveur", message: reponse)
            }
            let file = FileManager.default
            file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(reponseServeur).path, contents: "nil".data(using: String.Encoding.utf8), attributes: nil)
        }
    }
}

