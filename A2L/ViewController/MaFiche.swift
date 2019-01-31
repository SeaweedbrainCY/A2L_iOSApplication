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
    
    var nom = "Error"
    var statut = "Error"
    var dateNaissanceString = "Error"
    
    var timer = Timer() //Se charge de verifier l'arrivée de l'image
    
    override func viewDidLoad() { // lancée quand la vue load
        super.viewDidLoad()
        print("listeInfoAdherent = \(listeInfoAdherent)")
        var statut = "Adhérent"
        do {
            statut = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(testeur), encoding: .utf8)
        } catch {
            print("^^^^^^^^^Fichier introuvable.^^^^^^^^")
        }
        
        var infosConnexion = "nil"
        do {
            infosConnexion = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(informationConnexionAdhrent), encoding: .utf8)
        } catch {
            nom = "Error"
            dateNaissanceString = "Error"
        }
        
        if infosConnexion.contains("#") { // Si on trouve qqchose
            let infos = infosConnexion.split(separator: "#")
            nom = String(infos[0]) // Et enregistré de cette manière
            dateNaissanceString = String(infos[1])
        } else {
            nom = "Error"
            dateNaissanceString = "Error"
        }
        // On lance un compteur qui permet de verfier toutes les secondes si on a une réponse du serveur
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
        loadAllView()
        
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
        dateNaissance.topAnchor.constraint(equalToSystemSpacingBelow: photoId.bottomAnchor, multiplier: 4).isActive = true
        dateNaissance.textColor = .blue
        dateNaissance.font = UIFont(name: "Comfortaa-Regular", size: 18)
        dateNaissance.text = "Date de naissance : \(listeInfoAdherent["DateNaissance"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        var coloration = NSMutableAttributedString(string: dateNaissance.text!)
        coloration.setColorForText(textForAttribute: "Date de naissance :", withColor: .black)
        coloration.setFontForText(textForAttribute: "Date de naissance :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        dateNaissance.attributedText = coloration
        
        
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
    
    
    @objc func verificationReponse(){ // Est appelé pour verifier les réponses du serveur
        if imageView?.image != UIImage(named: "Logo_A2L"){
            timer.invalidate() // On arrète le timer
            print("image non validée")
            if reponseURLRequestImage == "success" {
                print("success")
                if self.chargementView != nil {
                    self.chargementView?.stopAnimating() // On arrète le chargement en cours
                }
            }
            print("Error loading image: \(reponseURLRequestImage)")
            reponseURLRequestImage = "nil" // On réinitialise
        }
    }
    
    
}

