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
    var generatedCodeLabelAnchor: NSLayoutConstraint?
    var generatedCodeLabel: UILabel?
    var dateNaissanceLabel: UILabel?
    var pointFideliteLabel: UILabel?
    var generateCodeButton: UIButton?
    var deleteCodeButton:UIButton?
    var stepper: UIStepper?
    var lastValidateNbrPoint = 0 // contient le nombre de point de fidélité validé par le serveur
    var listeAllNom:[String] = [] // contient le nom de tous les adhérents. Il sera passé a 'addNewAdhérent'
    var nombreAléatoire = "0000" // nombre aléatoire généré lors du clic
    
    var currentTextColor = UIColor.blue
    var currentTitleColor = UIColor.black
    
    
    var timerImage = Timer() //comme partout on a l'habitude mtn
    var timerPointFidelité = Timer()
    var timerCode = Timer()
    var timerAllName = Timer()
    
    override func viewDidLoad() { // lancée quand la vue load
        super.viewDidLoad()
        darkMode()
        listeInfoAdherent = infosOtherAdherent
        print("=> \(listeInfoAdherent)")
        if listeInfoAdherent != ["nil":"nil"]{ // Si on a les infos
            loadAllView()
        }
        if listeAllNom == [] {// n'est pas transmis par la liste adhérent car on vient du scann
            recupAllAdherentName()
        }
        if infosAdherent["Statut"] == "Développeur" || infosAdherent["Statut"] == "Super-admin" {
            modifierButton.title = "Modifier"
            if self.listeAllNom != []{
                modifierButton.isEnabled = true
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        nomAdherent.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 20).isActive = true
        nomAdherent.lineBreakMode = .byClipping
        nomAdherent.numberOfLines = 2
        nomAdherent.textAlignment = .center
        nomAdherent.textColor = currentTitleColor
        nomAdherent.font = UIFont(name: "Comfortaa-Bold", size: 30)
        nomAdherent.text = listeInfoAdherent["Nom"] ?? "Error"
        
        let photoId = UIImageView()
        self.backgroundView.addSubview(photoId)
        photoId.translatesAutoresizingMaskIntoConstraints = false
        photoId.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        photoId.topAnchor.constraint(equalToSystemSpacingBelow: nomAdherent.bottomAnchor, multiplier: 2).isActive = true
        photoId.image = UIImage(named: "chargementEnCours")
        photoId.imageFromDatabase(idAdherent: listeInfoAdherent["id"]!)
        photoId.widthAnchor.constraint(equalToConstant: 300).isActive = true
        photoId.heightAnchor.constraint(equalToConstant: 300).isActive = true
        self.imageView = photoId
        photoId.layer.cornerRadius = 20
        photoId.clipsToBounds = true
        //On lance un timer pour verifier toutes les secondes si on a une réponse
        timerImage = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
        
        let dateNaissance = UILabel()
        self.backgroundView.addSubview(dateNaissance)
        dateNaissance.translatesAutoresizingMaskIntoConstraints = false
        dateNaissance.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        dateNaissanceLabelAnchor = dateNaissance.topAnchor.constraint(equalToSystemSpacingBelow: photoId.bottomAnchor, multiplier: 4)
        dateNaissanceLabelAnchor?.isActive = true
        dateNaissance.textColor = currentTextColor
        dateNaissance.font = UIFont(name: "Comfortaa-Regular", size: 18)
        dateNaissance.text = "Date de naissance : \(listeInfoAdherent["DateNaissance"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        var coloration = NSMutableAttributedString(string: dateNaissance.text!)
        coloration.setColorForText(textForAttribute: "Date de naissance :", withColor: currentTitleColor)
        coloration.setFontForText(textForAttribute: "Date de naissance :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        dateNaissance.attributedText = coloration
        self.dateNaissanceLabel = dateNaissance
        
        
        let classe = UILabel()
        self.backgroundView.addSubview(classe)
        classe.translatesAutoresizingMaskIntoConstraints = false
        classe.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        classe.topAnchor.constraint(equalToSystemSpacingBelow: dateNaissance.bottomAnchor, multiplier: 3).isActive = true
        classe.textColor = currentTextColor
        classe.font = UIFont(name: "Comfortaa-Regular", size: 18)
        classe.text = "Classe : \(listeInfoAdherent["Classe"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: classe.text!)
        coloration.setColorForText(textForAttribute: "Classe :", withColor: currentTitleColor)
        coloration.setFontForText(textForAttribute: "Classe :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        classe.attributedText = coloration
        
        
        let statut = UILabel()
        self.backgroundView.addSubview(statut)
        statut.translatesAutoresizingMaskIntoConstraints = false
        statut.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        statut.topAnchor.constraint(equalToSystemSpacingBelow: classe.bottomAnchor, multiplier: 3).isActive = true
        statut.lineBreakMode = .byClipping
        statut.numberOfLines = 2
        statut.textColor = currentTextColor
        statut.font = UIFont(name: "Comfortaa-Regular", size: 18)
        statut.text = "Statut : \(listeInfoAdherent["Statut"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: statut.text!)
        coloration.setColorForText(textForAttribute: "Statut :", withColor: currentTitleColor)
        coloration.setFontForText(textForAttribute: "Statut :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!)
        statut.attributedText = coloration
        
        let pointFidelite = UILabel()
        self.backgroundView.addSubview(pointFidelite)
        pointFidelite.translatesAutoresizingMaskIntoConstraints = false
        pointFidelite.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
        pointFidelite.topAnchor.constraint(equalToSystemSpacingBelow: statut.bottomAnchor, multiplier: 3).isActive = true
        pointFidelite.textColor = currentTextColor
        pointFidelite.font = UIFont(name: "Comfortaa-Regular", size: 18)
        pointFidelite.text = "Points de fidélité : \(listeInfoAdherent["PointFidelite"] ?? "Error")"
        //On change la couleur que d'une seule partie du texte :
        coloration = NSMutableAttributedString(string: pointFidelite.text!)
        coloration.setColorForText(textForAttribute: "Points de fidélité :", withColor: currentTitleColor)
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
        stepper.value = Double(listeInfoAdherent["PointFidelite"]!) ?? 0
        stepper.stepValue = 1
        self.stepper = stepper
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
        
        //Générer un code temporaire
        if self.listeInfoAdherent["Statut"] != "Adhérent" && (infosAdherent["Statut"] == "Super-admin" || infosAdherent["Statut"] == "Développeur"){
            
            if listeInfoAdherent["HaveCodeTemporaire?"] == "true"{
                let deleteCode = UIButton()
                backgroundView.addSubview(deleteCode)
                deleteCode.translatesAutoresizingMaskIntoConstraints = false
                deleteCode.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
                deleteCode.topAnchor.constraint(equalToSystemSpacingBelow: qrCode.bottomAnchor, multiplier: 4).isActive = true
                deleteCode.setTitleColor(UIColor(red: 0.9, green: 0, blue: 0, alpha: 1), for: .normal)
                deleteCode.tintColor = currentTextColor
                deleteCode.titleLabel!.font = UIFont(name: "Comfortaa-Bold", size: 16)
                deleteCode.addTarget(self, action: #selector(deleteCodeSelected) , for: .touchUpInside)
                deleteCode.setTitle("Supprimer le code temporaire déjà actif", for: .normal)
                
                self.deleteCodeButton = deleteCode
            }
            
            let generateCode = UIButton()
            backgroundView.addSubview(generateCode)
            generateCode.translatesAutoresizingMaskIntoConstraints = false
            generateCode.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
            generateCode.widthAnchor.constraint(equalToConstant: self.scrollView.frame.size.width - 80).isActive = true
            generateCode.setTitleColor(UIColor(red: 0.26, green: 0.58, blue: 0.96, alpha: 1), for: .normal)
            generateCode.titleLabel?.lineBreakMode = .byWordWrapping
            generateCode.tintColor = currentTextColor
            generateCode.titleLabel!.font = UIFont(name: "Comfortaa-Bold", size: 16)
            generateCode.addTarget(self, action: #selector(generateCodeSelected) , for: .touchUpInside)
            if listeInfoAdherent["HaveCodeTemporaire?"] == "false"{
                generateCode.setTitle("Générer un code confidentiel temporaire", for: .normal)
                generateCode.topAnchor.constraint(equalToSystemSpacingBelow: qrCode.bottomAnchor, multiplier: 5).isActive = true
            } else {
                generateCode.setTitle("Supprimer et générer un nouveau code temporaire", for: .normal)
                generateCode.titleLabel?.numberOfLines = 2
                generateCode.titleLabel?.lineBreakMode = .byWordWrapping
                generateCode.topAnchor.constraint(equalToSystemSpacingBelow: deleteCodeButton!.bottomAnchor, multiplier: 3).isActive = true
                
            }
            self.generateCodeButton = generateCode
            
            let generatedCode = UILabel()
            backgroundView.addSubview(generatedCode)
            generatedCode.translatesAutoresizingMaskIntoConstraints = false
            generatedCode.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
            generatedCode.topAnchor.constraint(equalToSystemSpacingBelow: generateCode.bottomAnchor, multiplier: 3).isActive = true
            generatedCode.widthAnchor.constraint(equalToConstant: self.scrollView.frame.size.width - 50).isActive = true
            self.generatedCodeLabelAnchor = generatedCode.heightAnchor.constraint(equalToConstant:0)
            self.generatedCodeLabelAnchor!.isActive = true
            generatedCode.isHidden = true
            generatedCode.layer.borderColor = UIColor.blue.cgColor
            generatedCode.layer.borderWidth = 0.7
            generatedCode.layer.cornerRadius = 20
            generatedCode.font = UIFont(name: "Comfortaa-Bold", size: 60)
            generatedCode.textColor = .magenta
            generatedCode.shadowColor = .gray
            generatedCode.shadowOffset = CGSize(width: 0.2, height: 0.2)
            generatedCode.text = "6789"
            generatedCode.textAlignment = .center
            //On change la couleur que d'une seule partie du texte :
            coloration = NSMutableAttributedString(string: generatedCode.text!)
            let listeCouleur: [UIColor] = [.black, .blue, .red, .green, .magenta, .gray, .purple, .brown, .cyan, .orange]
            for i in 0 ..< listeCouleur.count {
                coloration.setColorForText(textForAttribute: "\(i)", withColor: listeCouleur[i])
            }
            generatedCode.attributedText = coloration
            self.generatedCodeLabel = generatedCode
            
            let infos = UIButton()
            backgroundView.addSubview(infos)
            infos.translatesAutoresizingMaskIntoConstraints = false
            infos.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 2).isActive = true
            infos.topAnchor.constraint(equalToSystemSpacingBelow: generatedCode.bottomAnchor, multiplier: 1.5).isActive = true
            infos.setTitleColor(.gray, for: .normal)
            infos.titleLabel!.font = UIFont(name: "Comfortaa-Light", size: 14)
            infos.addTarget(self, action: #selector(infosSelected) , for: .touchUpInside)
            infos.setTitle("Bah ouais ok mais c'est quoi ?", for: .normal)
        }
        
    }
    
    @objc func verificationReponse() { // Est appelé pour verifier si on a une réponse ou non du serveur pour le chargement de l'image
        print("reponseURL = \(reponseURLRequestImage)")
        if reponseURLRequestImage != "nil" {
            print("reponseUrl != nil")
            if reponseURLRequestImage != "success" && imageView != nil{
                if reponseURLRequestImage != "none"{
                print("image bug detected")
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
                
                reponseURLRequestImage = "nil"
                timerImage.invalidate()
                    
                } else {
                    self.imageView!.image = UIImage(named: "Image-1")
                    reponseURLRequestImage = "nil"
                    timerImage.invalidate()
                }
            } else {
                print("reponse = success")
                self.imageView?.image = imageId!
                reponseURLRequestImage = "nil"
                timerImage.invalidate()
            }
            if infosAdherent["Statut"] == "Développeur" || infosAdherent["Statut"] == "Super-admin" {
                modifierButton.title = "Modifier"
                if self.listeAllNom != []{
                    modifierButton.isEnabled = true
                }
                
            }
            
        }
        
        
    }
    
    @IBAction func modifierSelected(sender: UIBarButtonItem){ // Bouton modifier la fiche adhérent slectionné
        performSegue(withIdentifier: "modifier", sender: self)
    }
    
    @objc private func stepperSelected(sender: UIStepper) { // Lorsque le stepper (-|+) est selctionnée
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
            let pushData = PushDataServer()
            pushData.updatePointFidelite(id: listeInfoAdherent["id"]!, pointFidelite: String(Int(stepper!.value))) //On update cette version sur le serveur
            timerPointFidelité = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(verificationReponsePointFidelite), userInfo: nil, repeats: true)
            sender.tintColor = .gray // on le déactive en attendant une réponse du serveur
            sender.isEnabled = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Avant d'envoyer de segue
        //On enlève le nom de l'adhérent
        
        var listeNomWithoutAdherentName = self.listeAllNom
        listeNomWithoutAdherentName.remove(at: self.listeAllNom.firstIndex(of: self.listeInfoAdherent["Nom"]!)!)
        
        let modification = segue.destination as! AddNewAdherent
        //on préremplie les champs car on MODIFIE les infos d'un adhérent
        modification.titleView = "Modifier les infos"
        modification.oldNom = listeInfoAdherent["Nom"]!
        modification.oldClasse = listeInfoAdherent["Classe"]!
        modification.oldStatut = " \(listeInfoAdherent["Statut"]!)  "
        modification.oldDateNaissance = listeInfoAdherent["DateNaissance"]!
        modification.oldImage = imageView?.image ?? UIImage(named: "binaireWorld")
        modification.id = listeInfoAdherent["id"]!
        modification.listeAllNom = listeNomWithoutAdherentName
    }
    
    @objc private func verificationReponsePointFidelite() { // est appelé pour verifier les réponse du serveur
        if serveurReponse != "nil" {
            timerPointFidelité.invalidate()
            self.stepper!.isEnabled = true // on le réactive
            self.stepper?.tintColor = currentTextColor
            if serveurReponse == "success" { // si on a une bonne réponse du serveur on met à jour les points de fidelité :
                listeInfoAdherent.updateValue("\(Int(self.stepper!.value))", forKey: "PointFidelite") //On dans la variable local le nombre
                pointFideliteLabel!.text = "Points de fidélité : \(listeInfoAdherent["PointFidelite"]!)" //on update le text label
                let coloration = NSMutableAttributedString(string: pointFideliteLabel!.text!)
                coloration.setColorForText(textForAttribute: "Points de fidélité :", withColor: currentTitleColor)
                coloration.setFontForText(textForAttribute: "Points de fidélité :", withFont: UIFont(name: "Comfortaa-Bold", size: 18)!) //Pour la couleur et la police spéciale des titres
                pointFideliteLabel!.attributedText = coloration
                lastValidateNbrPoint = Int(self.stepper!.value) // on met a jour la dernière value priseen compte par le serveur
            } else { // sinon alert :
                alert("Une erreur serveur est survenue", message: serveurReponse)
                stepper!.value = Double(lastValidateNbrPoint) // on le réinitialise à sa derniere valeur car le serveur n'a pas validé la requète
            }
        }
        serveurReponse = "nil"
    }
    
    @objc private func generateCodeSelected(sender: UIButton) {
        sender.setTitleColor(.gray, for: .normal)
        sender.isEnabled = false
        sender.isSelected = true
        
        if (self.deleteCodeButton != nil) {
            self.deleteCodeButton!.isEnabled = false
            self.deleteCodeButton!.setTitleColor(.gray, for: .normal)
        }
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 4
        self.nombreAléatoire = formatter.string(from: Int.random(in: 1 ..< 9999) as NSNumber)!
        let pushData = PushDataServer()
        pushData.stockCodeTemporaire(id: "\(self.listeInfoAdherent["id"]!)", codeTemporaire: "\(self.nombreAléatoire)")
        timerCode = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(verificationReponseCode), userInfo: nil, repeats: true)
    }
    
    @objc private func deleteCodeSelected(sender:UIButton) {
        sender.setTitleColor(.gray, for: .normal)
        sender.isEnabled = false
        self.generateCodeButton?.setTitleColor(.gray, for: .normal)
        self.generateCodeButton?.isEnabled = false
        self.generateCodeButton?.isSelected = false
        let pushData = PushDataServer()
        pushData.stockCodeTemporaire(id: "\(self.listeInfoAdherent["id"]!)", codeTemporaire: "nil")
        timerCode = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(verificationReponseCode), userInfo: nil, repeats: true)
    }
    
    @objc private func verificationReponseCode(){
        if serveurReponse != "nil" {
            timerCode.invalidate()
            if self.generateCodeButton!.isSelected {
                if serveurReponse == "success" {
                
                    self.generatedCodeLabel!.text = "\(self.nombreAléatoire)"
                    let coloration = NSMutableAttributedString(string: generatedCodeLabel!.text!)
                    let listeCouleur: [UIColor] = [.black, .blue, .red, .green, .magenta, .gray, .purple, .brown, .cyan, .orange]
                    for i in 0 ..< listeCouleur.count {
                        coloration.setColorForText(textForAttribute: "\(i)", withColor: listeCouleur[i])
                    }
                    self.generatedCodeLabel!.attributedText = coloration
                    
                    
                    if self.generatedCodeLabel!.isHidden {
                        self.generatedCodeLabel!.isHidden = false
                        let animation = UIViewPropertyAnimator(duration: 7, dampingRatio: 1, animations: {
                            self.generatedCodeLabelAnchor?.isActive = false
                            self.generatedCodeLabelAnchor = self.generatedCodeLabel?.heightAnchor.constraint(equalToConstant: 100)
                            self.generatedCodeLabelAnchor?.isActive = true
                        })
                        animation.startAnimation()
                    }
                } else {
                    alert("Une erreur lors de la connexion au serveur est survenue", message: "Moi je bug jamais alors ça doit être toi ...")
                }
                
               
            } else {// on vient de supprimer un code temporaire
                 if serveurReponse == "success" {
                    self.deleteCodeButton?.setTitleColor(.red, for: .normal)
                    let animation = UIViewPropertyAnimator(duration: 4, curve: .linear, animations: {
                        self.deleteCodeButton?.setTitle("", for: .normal)
                        })
                    animation.startAnimation(afterDelay: 1000)
                    self.generateCodeButton?.setTitle("Générer un code confidentiel temporaire", for: .normal)
                 } else {
                alert("Une erreur lors de la connexion au serveur est survenue", message: "Moi je bug jamais alors ça doit être toi ...")
                }
                self.deleteCodeButton!.setTitleColor(UIColor(red: 0.9, green: 0, blue: 0, alpha: 1), for: .normal)
                self.deleteCodeButton!.isEnabled = true
                
            }
            self.generateCodeButton!.setTitleColor(UIColor(red: 0.26, green: 0.58, blue: 0.96, alpha: 1), for: .normal)
            self.generateCodeButton!.isEnabled = true
            self.generateCodeButton!.setTitle("Générer un nouveau code temporaire", for: .normal)
            self.generateCodeButton?.isSelected = false
            serveurReponse = "nil"
        }
        
    }
    
    @objc private func infosSelected(sender: UIButton) {
        sender.setTitleColor(UIColor.lightGray, for: .normal)
        alert("Code confidentiel temporaire", message: "Ce code est généré aléatoirement et doit être transmis à l'admin concerné afin qu'il puisse créer un mot de passe ou le réinitiliser\n\n⚠︎⚠︎⚠︎ATTENTION⚠︎⚠︎⚠︎\nGénérer un code suffit à le rendre valide. En générer un nouveau désactive le précédent. Ce code restera valide jusqu'à son utilisation s'il n'est pas re-généré.\nUne fois que vous quitterez cette page vous ne pourrez plus voir le code. Il faudra donc en créer un nouveau. Même si vous n'avez plus accès à son contenu le code restera valide quand vous aurez quitté la page")
    }
    
    func recupAllAdherentName(){
        let api = APIConnexion()
        api.exctractAllData(nom: api.convertionToHexaCode(infosAdherent["Nom"] ?? "Error"), mdpHashed: infosAdherent["MdpHashed"] ?? "Error")
        //On lance un timer pour verifier toutes les secondes si on a une réponse
        timerAllName = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(recupAllNameVerification), userInfo: nil, repeats: true)
    }
    
    
    @objc private func recupAllNameVerification(){
        
        if serveurReponse != "nil" { // on detecte une réponse
            timerAllName.invalidate() // on desactive le compteur il ne sert plus à rien
            if serveurReponse == "success" {
                //On a réussi, active le bouton
                for infos in infosAllAdherent {
                    if infos != [:] {
                        let nom = "\(infos["Nom"]!)"
                        
                        if listeAllNom == [] {
                            listeAllNom = [infos["Nom"]!]
                        } else {
                            listeAllNom.append(nom)
                        }
                    }
                }
                self.modifierButton.isEnabled = true
            } else { // Une erreur est survenue
                self.alert("Erreur lors de la connexion au serveur", message: serveurReponse)
            }
            serveurReponse = "nil"
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
            self.currentTextColor = UIColor.init(red: 0.102, green: 0.483, blue: 1, alpha: 1)
            self.currentTitleColor = .white
            self.view.backgroundColor = .black
        } else {
            self.backgroundView.backgroundColor = .white
            self.tabBarController?.tabBar.barStyle = .default
            self.navigationController?.navigationBar.barStyle = .default
            self.currentTextColor = .blue
            self.currentTitleColor = .black
            self.view.backgroundColor = .white
        }
    }
}
