//
//  FicheAdhérent.swift
//  A2L
//
//  Created by Nathan on 10/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class FicheAdherent: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var modifierButton: UIBarButtonItem!
    
    var listeInfoAdherent = infosOtherAdherent //listeDeToutes les infos
    var chargementView: UIActivityIndicatorView? //sert pour la création du Qr code
    var imageView:UIImageView? //imageView = photo d'identité adhérent
    var dateNaissanceLabelAnchor:NSLayoutConstraint? // doit pouvoir être désactivée si besoin
    var dateNaissanceLabel: UILabel?
    var pointFideliteLabel: UILabel?
    
    var timer = Timer() //comme partout on a l'habitude mtn
    
    override func viewDidLoad() { // lancée quand la vue load
        super.viewDidLoad()
        
        listeInfoAdherent = infosOtherAdherent
        print("=> \(listeInfoAdherent)")
        if listeInfoAdherent != ["nil":"nil"]{ // Si on a les infos
            loadAllView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        statut.lineBreakMode = .byClipping
        statut.numberOfLines = 2
        statut.textColor = .blue
        statut.font = UIFont(name: "Comfortaa-Regular", size: 18)
        statut.text = "Statut : \(listeInfoAdherent["Statut"] ?? "Error")"
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
        pointFideliteLabel = pointFidelite
        
        let stepper = UIStepper()
        self.backgroundView.addSubview(stepper)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.centerYAnchor.constraint(equalToSystemSpacingBelow: pointFidelite.centerYAnchor, multiplier: 1).isActive = true
        stepper.leftAnchor.constraint(equalToSystemSpacingAfter: pointFidelite.rightAnchor, multiplier: 2).isActive = true
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.value = Double(listeInfoAdherent["PointFidelite"]!)!
        stepper.stepValue = 1
        stepper.addTarget(self, action: #selector(stepperSelected), for: .touchUpInside)
        
        let qrCode = UIImageView()
        self.backgroundView.addSubview(qrCode)
        qrCode.translatesAutoresizingMaskIntoConstraints = false
        qrCode.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        qrCode.topAnchor.constraint(equalToSystemSpacingBelow: pointFidelite.bottomAnchor, multiplier: 2).isActive = true
        let generateQR = generateQRcode()
        let stringQR = generateQR.generateStringQRCode(nom: api.convertionToHexaCode(listeInfoAdherent["Nom"]!), dateNaissance: listeInfoAdherent["DateNaissance"]!)
        qrCode.image = generateQR.generateQRCode(from: stringQR)
        qrCode.widthAnchor.constraint(equalToConstant: 130).isActive = true
        qrCode.heightAnchor.constraint(equalToConstant: 130).isActive = true
        //self.imageView = qrCode
        
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
        } else {
            
            if infosAdherent["Statut"] == "Developpeur" || infosAdherent["Statut"] == "Super-admin" {
                modifierButton.title = "Modifier"
                modifierButton.isEnabled = true
            }
            
        }
    }
    
    @IBAction func modifierSelected(sender: UIBarButtonItem){ // Bouton modifier la fiche adhérent slectionné
        performSegue(withIdentifier: "modifier", sender: self)
    }
    
    @objc private func stepperSelected(sender: UIStepper) { // Lorsque le stepper (-|+) est selctionnée
        if Int(listeInfoAdherent["PointFidelite"]!) != nil { // Convertion possible
            listeInfoAdherent.updateValue("\(Int(sender.value))", forKey: "PointFidelite") //On dans la variable local le nombre
            pointFideliteLabel!.text = "Points de fidélité : \(listeInfoAdherent["PointFidelite"]!)" //on update le text label
            let coloration = NSMutableAttributedString(string: pointFideliteLabel!.text!)
            coloration.setColorForText(textForAttribute: "Points de fidélité :", withColor: .black)
            coloration.setFontForText(textForAttribute: "Points de fidélité :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!) //Pour la couleur et la police spéciale des titres
            pointFideliteLabel!.attributedText = coloration
            let pushData = PushDataServer()
            pushData.updatePointFidelite(id: listeInfoAdherent["id"]!, pointFidelite: listeInfoAdherent["PointFidelite"]!) //On update cette version sur le serveur
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Avant d'envoyer de segue
        let modification = segue.destination as! AddNewAdherent
        //modification.titre //on préremplie les champs car on MODIFIE les infos d'un adhérent
        modification.oldNom = listeInfoAdherent["Nom"]!
        modification.oldClasse = listeInfoAdherent["Classe"]!
        modification.oldStatut = " \(listeInfoAdherent["Statut"]!)  "
        modification.oldDateNaissance = listeInfoAdherent["DateNaissance"]!
        modification.oldImage = imageView!.image!
    }
    
    
}
