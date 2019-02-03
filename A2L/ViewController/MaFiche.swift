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
        if listeInfoAdherent != ["nil":"nil"]{ // Si on a les infos
            loadAllView()
        } else { // On ne detecte aucune informations en local, on ne sait pas qui est l'adhérent donc on load la page de connexion
            performSegue(withIdentifier: "connexionAdherent", sender: self)
        }
        //On lance un timer pour verifier toutes les secondes si on a une réponse
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
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
        
        let dateNaissance = UILabel()
        self.backgroundView.addSubview(dateNaissance)
        dateNaissance.translatesAutoresizingMaskIntoConstraints = false
        dateNaissance.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 5).isActive = true
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
        
        
        
        let statut = UILabel()
        self.backgroundView.addSubview(statut)
        statut.translatesAutoresizingMaskIntoConstraints = false
        statut.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 5).isActive = true
        statut.topAnchor.constraint(equalToSystemSpacingBelow: dateNaissance.topAnchor, multiplier: 4).isActive = true
        statut.textColor = .blue
        statut.font = UIFont(name: "Comfortaa-Regular", size: 18)
        statut.text = "Statut : \(listeInfoAdherent["Statut"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: statut.text!)
        coloration.setColorForText(textForAttribute: "Statut :", withColor: .black)
        coloration.setFontForText(textForAttribute: "Statut :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        statut.attributedText = coloration
        
        /*let chargement = UIActivityIndicatorView()
        self.backgroundView.addSubview(chargement)
        self.imageView?.addSubview(chargement)
        chargement.translatesAutoresizingMaskIntoConstraints = false
        chargement.style = .whiteLarge
        chargement.color = .blue
        chargement.centerXAnchor.constraint(equalToSystemSpacingAfter: photoId.centerXAnchor, multiplier: 1).isActive = true
         chargement.centerYAnchor.constraint(equalToSystemSpacingBelow: photoId.centerYAnchor, multiplier: 1).isActive = true
        chargement.startAnimating()
        chargement.hidesWhenStopped = true
        self.chargementView = chargement*/
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
}

