//
//  AddNewAdherent.swift
//  A2L
//
//  Created by Nathan on 06/02/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

var loadAnOtherAdherent = "nil" // est utilisé pour load les infos d'un adhérents automatiquement

class AddNewAdherent: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tabBarTitle: UINavigationItem!
    
    //Sont réutilisés dans le code pour de nombreuses raisons
    var nomTextField: UITextField?
    var classeTextField: UITextField?
    var dateNaissanceVariable: UIButton?
    var datePickerView: UIDatePicker?
    var statutVariable: UIButton?
    var pickerViewStatut: UIPickerView?
    var imageButton:UIButton?
    var datePickerHeight :NSLayoutConstraint?
    var pickerStatutHeight: NSLayoutConstraint?
    let chargement = UIActivityIndicatorView()
    let chargementView = UIView()
    
    //Si on modifie la fiche d'un adhérent, on reporte ses infomrations dans les champs requis :
    var titleView = "Ajouter un adhérent"
    var id = "nil"
    var oldNom = ""
    var oldClasse = ""
    var oldImage: UIImage?
    var oldDateNaissance = "14/11/2002"
    var oldStatut = " Adhérent  "
    var listeAllNom:[String] = [] // liste le nom de tous les adhérents
    
    var waitForServeur = Timer()
    var imageExtension = "unknown"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.tabBarTitle.title = titleView
        loadAllView() // on load toutes les View
        //On instancie le chargement
        chargement.style = .whiteLarge
        chargement.color = .blue
        self.backgroundView.addSubview(chargement)
        chargement.translatesAutoresizingMaskIntoConstraints = false
        chargement.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        chargement.centerYAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.centerYAnchor, multiplier: 1).isActive = true
        chargement.hidesWhenStopped = true
        chargement.stopAnimating()
        //On instancie le vue de chargement :
        self.backgroundView.addSubview(chargementView)
        chargementView.translatesAutoresizingMaskIntoConstraints = false
        chargementView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width).isActive = true
        chargementView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height).isActive = true
        chargementView.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        chargementView.centerYAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.centerYAnchor, multiplier: 1).isActive = true
        chargementView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        chargementView.isHidden = true
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true) // on enlève le clavier si on scroll
    }
    
    private func loadAllView(){ // load toutes les UIView
        
        let nomTitre = UILabel()
        backgroundView.addSubview(nomTitre)
        nomTitre.translatesAutoresizingMaskIntoConstraints = false
        nomTitre.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 3).isActive = true
        nomTitre.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.topAnchor, multiplier: 4).isActive = true
        nomTitre.text = "Nom Prénom : "
        nomTitre.font = UIFont(name: "Comfortaa-Bold", size: 18)
        
        let nomField = UITextField()
        nomField.delegate = self
        backgroundView.addSubview(nomField)
        nomField.translatesAutoresizingMaskIntoConstraints = false
        nomField.widthAnchor.constraint(equalToConstant: self.view.frame.size.width  - 40).isActive = true
        nomField.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 3).isActive = true
        nomField.topAnchor.constraint(equalToSystemSpacingBelow: nomTitre.bottomAnchor, multiplier: 1.5).isActive = true
        nomField.placeholder = "Nom Prénom"
        nomField.borderStyle = .roundedRect
        nomField.autocapitalizationType = .words
        nomField.textColor = .blue
        nomField.textContentType = .name
        nomField.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        nomField.text = self.oldNom // si on a déjà le nom de l'adhérent lors de la modification
        self.nomTextField = nomField
        
        let classeTitre = UILabel()
        backgroundView.addSubview(classeTitre)
        classeTitre.translatesAutoresizingMaskIntoConstraints = false
        classeTitre.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 3).isActive = true
        classeTitre.topAnchor.constraint(equalToSystemSpacingBelow: nomField.bottomAnchor, multiplier: 4).isActive = true
        classeTitre.text = "Classe : "
        classeTitre.font = UIFont(name: "Comfortaa-Bold", size: 18)
        
        
        let classe = UITextField()
        classe.delegate = self
        backgroundView.addSubview(classe)
        classe.translatesAutoresizingMaskIntoConstraints = false
        classe.centerYAnchor.constraint(equalToSystemSpacingBelow: classeTitre.centerYAnchor, multiplier: 1).isActive = true
        classe.leftAnchor.constraint(equalToSystemSpacingAfter: classeTitre.rightAnchor, multiplier: 3).isActive = true
        classe.widthAnchor.constraint(equalToConstant: 90).isActive = true
        classe.placeholder = "Classe"
        classe.borderStyle = .roundedRect
        classe.autocapitalizationType = .words
        classe.textColor = .blue
        classe.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        classe.text = oldClasse
        self.classeTextField = classe
        
        let imageButton = UIButton()
        self.backgroundView.addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageButton.topAnchor.constraint(equalToSystemSpacingBelow: classe.bottomAnchor, multiplier: 4).isActive = true
        imageButton.centerXAnchor.constraint(equalToSystemSpacingAfter: scrollView.centerXAnchor, multiplier: 1).isActive = true
        imageButton.imageView!.layer.cornerRadius = 20
        imageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        self.imageButton = imageButton
        if let oldImageAdherent = self.oldImage {
            self.imageButton?.setImage(oldImageAdherent, for: .normal)
        } else {
            imageButton.setImage(UIImage(named:"addImage"), for: .normal)
        }
        
        
        
        let dateNaissanceTitre = UILabel()
        backgroundView.addSubview(dateNaissanceTitre)
        dateNaissanceTitre.translatesAutoresizingMaskIntoConstraints = false
        dateNaissanceTitre.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 3).isActive = true
        dateNaissanceTitre.topAnchor.constraint(equalToSystemSpacingBelow: imageButton.bottomAnchor, multiplier: 5).isActive = true
        dateNaissanceTitre.text = "Date de naissance : "
        dateNaissanceTitre.font = UIFont(name: "Comfortaa-Bold", size: 18)
        
        let dateNaissanceButton = UIButton()
        backgroundView.addSubview(dateNaissanceButton)
        dateNaissanceButton.translatesAutoresizingMaskIntoConstraints = false
        dateNaissanceButton.leftAnchor.constraint(equalToSystemSpacingAfter: dateNaissanceTitre.rightAnchor, multiplier: 1).isActive = true
        dateNaissanceButton.centerYAnchor.constraint(equalToSystemSpacingBelow: dateNaissanceTitre.centerYAnchor, multiplier: 5).isActive = true
        dateNaissanceButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        dateNaissanceButton.setTitleColor(.blue, for: .normal)
        dateNaissanceButton.tintColor = .blue
        self.dateNaissanceVariable = dateNaissanceButton
        dateNaissanceButton.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 18)
        dateNaissanceButton.setBorderCorner()
        dateNaissanceButton.addTarget(self, action: #selector(dateNaissanceSelected) , for: .touchUpInside)
        dateNaissanceButton.setTitle(self.oldDateNaissance, for: .normal)
        
        let datePicker = UIDatePicker()
        self.backgroundView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 70).isActive = true
        self.datePickerHeight = datePicker.heightAnchor.constraint(equalToConstant: 0)
        self.datePickerHeight?.isActive = true
        datePicker.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        datePicker.topAnchor.constraint(equalToSystemSpacingBelow: dateNaissanceButton.bottomAnchor, multiplier: 1.5).isActive = true
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(newDateNaissance), for: .valueChanged)
        let localisation = Locale(identifier: "fr")
        datePicker.locale = localisation
        self.datePickerView = datePicker

        
        let statutTitre = UILabel()
        backgroundView.addSubview(statutTitre)
        statutTitre.translatesAutoresizingMaskIntoConstraints = false
        statutTitre.leftAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.leftAnchor, multiplier: 3).isActive = true
        statutTitre.topAnchor.constraint(equalToSystemSpacingBelow: datePicker.bottomAnchor, multiplier: 3).isActive = true
        statutTitre.text = "Statut : "
        statutTitre.font = UIFont(name: "Comfortaa-Bold", size: 18)
        
        let statutButton = UIButton()
        backgroundView.addSubview(statutButton)
        statutButton.translatesAutoresizingMaskIntoConstraints = false
        statutButton.leftAnchor.constraint(equalToSystemSpacingAfter: statutTitre.rightAnchor, multiplier: 1).isActive = true
        statutButton.centerYAnchor.constraint(equalToSystemSpacingBelow: statutTitre.centerYAnchor, multiplier: 5).isActive = true
        statutButton.setTitleColor(.blue, for: .normal)
        statutButton.tintColor = .blue
        self.statutVariable = statutButton
        statutButton.setBorderCorner()
        statutButton.titleLabel?.font = UIFont(name: "Comfortaa-Regular", size: 18)
        statutButton.addTarget(self, action: #selector(statutSelected) , for: .touchUpInside)
        statutButton.setTitle(self.oldStatut, for: .normal)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.backgroundView.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 70).isActive = true
        self.pickerStatutHeight = pickerView.heightAnchor.constraint(equalToConstant: 0)
        self.pickerStatutHeight?.isActive = true
        pickerView.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
        pickerView.topAnchor.constraint(equalToSystemSpacingBelow: statutTitre.bottomAnchor, multiplier: 1.5).isActive = true
        self.pickerViewStatut = pickerView
        
        let infosButton = UIButton()
        backgroundView.addSubview(infosButton)
        infosButton.translatesAutoresizingMaskIntoConstraints = false
        infosButton.centerYAnchor.constraint(equalToSystemSpacingBelow: statutTitre.centerYAnchor, multiplier: 1).isActive = true
        infosButton.leftAnchor.constraint(equalToSystemSpacingAfter: statutButton.rightAnchor, multiplier: 6).isActive = true
        infosButton.setTitle("Infos?", for: .normal)
        infosButton.setTitleColor(.lightGray, for: .normal)
        infosButton.titleLabel!.font = UIFont(name: "Comfortaa-Light", size: 18)
        infosButton.addTarget(self, action: #selector(infoSelected), for: .touchUpInside)
        
        
        if id != "nil" && oldStatut != " Développeur  " && oldNom != infosAdherent["Nom"]{ // on ne supprime pas un adhérent pas encore créé ou un developpeur ou soi même
            let supprButton = UIButton()
            self.backgroundView.addSubview(supprButton)
            supprButton.translatesAutoresizingMaskIntoConstraints = false
            supprButton.centerXAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.centerXAnchor, multiplier: 1).isActive = true
            supprButton.topAnchor.constraint(equalToSystemSpacingBelow: pickerView.bottomAnchor, multiplier: 5).isActive = true
            supprButton.setTitleColor(.red, for: .normal)
            supprButton.setTitle("Supprimer cet adhérent", for: .normal)
            supprButton.addTarget(self, action: #selector(supprAdherent), for: .touchUpInside)
        }
        
    }
    
    @objc private func dateNaissanceSelected(sender: UIButton) { // Quand on clique sur la date de naissance
        if datePickerView!.isHidden { // on l'affiche car il est caché
            //Si l'autre est affiché on l'enlève
            if !self.pickerViewStatut!.isHidden
            {
                self.pickerStatutHeight!.isActive = false // on désactive sont ancienne height
                self.pickerStatutHeight = self.pickerViewStatut!.heightAnchor.constraint(equalToConstant: 0) // On ajoute la nouvelle
                self.pickerStatutHeight!.isActive = true //on active la nouvelle height
                self.pickerViewStatut!.isHidden = true // on cache
            }
            
            self.view.endEditing(true) // on enlève le clavier
            self.datePickerView!.isHidden = false // on affiche le notre
            self.datePickerHeight!.isActive = false // on désactive sont ancienne height
            self.datePickerHeight = self.datePickerView!.heightAnchor.constraint(equalToConstant: 190) // On ajoute la nouvelle
            self.datePickerHeight!.isActive = true // on active la nouvelle height
            
            let dateFormatteur = DateFormatter()
            dateFormatteur.dateFormat = "dd/MM/yyyy" //format de la date
            self.datePickerView!.setDate(dateFormatteur.date(from: (self.dateNaissanceVariable?.currentTitle!)!)!, animated: true)//Date picker prend la valeur de la date déjà inscrite
        } else { // on le cache car il est affiché
                self.datePickerHeight!.isActive = false
                self.datePickerHeight = self.datePickerView!.heightAnchor.constraint(equalToConstant: 0)
                self.datePickerHeight!.isActive = true
            self.datePickerView!.isHidden = true
        }
        
    }
    
    @objc private func newDateNaissance(sender: UIDatePicker) { // Est appelé lorsqu'on modifie la date
        let dateFormatteur = DateFormatter()
        dateFormatteur.dateFormat = "dd/MM/yyyy" //format de la date
        let jour = Calendar.current.component(.day, from: sender.date)
        let mois = Calendar.current.component(.month, from: sender.date)
        let year = Calendar.current.component(.year, from: sender.date)
        let date = dateFormatteur.date(from: "\(jour)/\(mois)/\(year)")
        self.dateNaissanceVariable?.setTitle(String(dateFormatteur.string(from: date ?? dateFormatteur.date(from: "14/11/2002")!)), for: .normal) // update de la date
    }
    
    @objc private func statutSelected(sender: UIButton) { // lorsqu'on clique sur le statut
        if statutVariable!.currentTitle! == " Développeur  " {
            alert("Les développeurs ne peuvent être dégradés", message: "Je suis désolé, je ne fais que suivre leurs instructions ...")
        } else {
            self.view.endEditing(true)
            if self.pickerViewStatut!.isHidden { // Si il est caché
                
                if !self.datePickerView!.isHidden { //Si le datePicker est affciher alors on le cache
                    self.datePickerHeight!.isActive = false
                    self.datePickerHeight = self.datePickerView!.heightAnchor.constraint(equalToConstant: 0)
                    self.datePickerHeight!.isActive = true
                    self.datePickerView!.isHidden = true
                }
                
                self.pickerViewStatut!.isHidden = false // on affiche le notre
                self.pickerStatutHeight!.isActive = false // on désactive sont ancienne height
                self.pickerStatutHeight = self.datePickerView!.heightAnchor.constraint(equalToConstant: 50) // On ajoute la nouvelle
                self.pickerStatutHeight!.isActive = true
            } else { // il est déjà afficher alors on le cache
                self.pickerStatutHeight!.isActive = false // on désactive sont ancienne height
                self.pickerStatutHeight = self.pickerViewStatut!.heightAnchor.constraint(equalToConstant: 0) // On ajoute la nouvelle
                self.pickerStatutHeight!.isActive = true
                
                self.pickerViewStatut!.isHidden = true // on cache
            }
        }
        
        
    }
    
    @IBAction func saveSelected(sender: UIBarButtonItem) {
        // On vérifie que tius les champs sont remplis :
        print("listeAllNom = \(listeAllNom)")
        var isCorrect = true
        if nomTextField!.text != nil || nomTextField!.text != "" { // Le champ Nom Prénom est rempli
            if  !nomTextField!.text!.contains(" ") { // ne contient que le prénom ou que le nom
                isCorrect = false
                nomTextField!.shake()
            } else if listeAllNom.contains(nomTextField!.text!){ // Le nom existe déjà
                isCorrect = false
                nomTextField!.shake()
                alert("Cet adhérent est déjà enregistré", message: "La chance il aurait pu apparaitre 2 fois !")
            }
        } else { // Le nom n'est pas rensigné
            isCorrect = false
            nomTextField!.shake()
        }
        if classeTextField!.text == nil || classeTextField!.text == "" { // aucune classe renseigné
            isCorrect = false
            classeTextField!.shake()
        }
        if imageButton!.image(for: .normal) == UIImage(named: "addImage") { // la pdp n'a pas été modifiée A GARDER ??? A VOIR
            isCorrect = false
            imageButton!.shake()
            alert("Aucune photo de profil renseignée", message: "Ajouter une photo de profil en cliquant sur le cadre bleu")
        }
        
        
        if isCorrect { // on envoie les infos au serveur si tout est correct
            chargement.startAnimating()
            self.chargementView.isHidden = false
            self.scrollView.isScrollEnabled = false
            if id == "nil" { // si on a pas d'id cela veut dire que la fiche est en cours de création et non de modification. Il n'a donc aucun Id pour l'instant
                //On enlève les espaces :
                var statut = ""
                switch self.statutVariable!.currentTitle! {
                case " Adhérent  " : statut = "Adhérent"
                case " Membre du bureau  ": statut = "Membre du bureau"
                case " Super-admin  ": statut = "Super-admin"
                case " Développeur  ": statut = "Développeur"
                default : statut = "Adhérent"
                }
                
                let pushData = PushDataServer()
                let convertion = APIConnexion()
                let imageData = self.imageButton!.currentImage!.jpegData(compressionQuality: 0.2)
                let imageStr = imageData!.base64EncodedString(options:.endLineWithCarriageReturn)
                let stringData = convertion.convertionToHexaCode("\(imageStr)")
                print("nbr caracteres finaux : \(stringData.count)")
                pushData.addAdherent(nom: /*convertion.convertionToHexaCode*/(nomTextField!.text!), classe: /*convertion.convertionToHexaCode*/(classeTextField!.text!), imageData: stringData, dateNaissance: dateNaissanceVariable!.currentTitle!, statut: statut)
                    
                waitForServeur = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
                
            } else { // si on a un id alors l'adhérent existe déjà, on l'utilise donc:
                //On enlève les espaces :
                var statut = ""
                switch self.statutVariable!.currentTitle! {
                case " Adhérent  " : statut = "Adhérent"
                case " Membre du bureau  ": statut = "Membre du bureau"
                case " Super-admin  ": statut = "Super-admin"
                case " Développeur  ": statut = "Développeur"
                default : statut = "Adhérent"
                }
                
                
                let pushData = PushDataServer()
                let convertion = APIConnexion()
                if imageButton!.currentImage! != oldImage { // l'image a changé : on l'upload
                    let imageData = self.imageButton!.currentImage!.jpegData(compressionQuality: 0.2)
                    let imageStr = imageData!.base64EncodedString(options:.endLineWithCarriageReturn)
                    let stringData = convertion.convertionToHexaCode("\(imageStr)")
                    print("nbr charactere finale : \(stringData.count)")
                    pushData.uploadImage(imageDataString: stringData, id: infosOtherAdherent["id"]!)
                    
                } else { // on a pas changé l'image
                    reponseURLRequestImage = "success" // on fait comme si on avait réussi l'upload
                }
                
                pushData.updateAllInfo(id: id, nom: nomTextField!.text!, classe: classeTextField!.text!, dateNaissance: dateNaissanceVariable!.currentTitle!, statut: statut)
                waitForServeur = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { // nombre de colonne
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //nombre de ligne
        return 3
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let liste = ["Adhérent", "Membre du bureau", "Super-admin"]
        return liste[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let liste = ["Adhérent", "Membre du bureau", "Super-admin"]
        self.statutVariable?.setTitle(" \(liste[row])  ", for: .normal)
    }
    
    @objc private func infoSelected(sender: UIButton) { // affiche l'aide a propos de la modification des statuts. Pour ne pas faire n'importe quoi
        sender.setTitleColor(.white, for: .normal)
        alert("Statuts :", message: "✔︎Adhérent: Ils ont accès à leur fiche adhérent personnelle et se connectent avec leur nom/prénom et date de naissance\n✔︎Membre du bureau : Ils ont accès aux fiches de tous les adhérents et peuvent scanner les QR code. Ils ne peuvent modifier que les points de fidélité. Ils se connectent avec un mot de passe.\n✔︎Super-admin: Vous êtes un super-admin. Vous disposez donc de tous les privilèges et vous pouvez modifier toutes les informations des adhérents.\n✔︎Developpeur: Ils disposent des mêmes droits que les super-admin, mais ne peuvent être déstitués.\n\nPour de plus amples informations consulter la page 'aide'")
        sender.setTitleColor(.lightGray, for: .normal)
    }
    
    @objc private func addImage(sender: UIButton) { // quand on clique sur l'image
        //On lui demande d'où elle veut prendre l'image : ici pas le choix : l'album photo
        let alert = UIAlertController(title: "Photo de profil adhérent", message: "Les photos sont stockées uniquement sur les serveurs de l'A2L et sont strictement privées à l'association.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
            let image = UIImagePickerController()
            image.delegate = self
            
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(image, animated: true)
            {
                //une fois effectué (?)
            }
        })
        alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertAction.Style.cancel, handler: nil)) // Retour
        present(alert, animated: true)
    }
    
    @objc private func supprAdherent(sender: UIButton){ // Pour supprimer la fiche d'un adhérent
        sender.setTitleColor(.gray, for: .normal)
        
        //On demande la confirmation
        let alert = UIAlertController(title: "Voulez vous vraiment supprimer cet adhérent", message: "En supprimant cette fiche, vous supprimer l'adhérent des registres de l'A2L. Cette action est définitive", preferredStyle: .alert)
        let annuler = UIAlertAction(title: "Annuler", style: UIAlertAction.Style.cancel, handler: { (_) in
            sender.setTitleColor(.red, for: .normal)
        })
        let supprimer = UIAlertAction(title: "Supprimer", style: UIAlertAction.Style.destructive, handler: { (_) in
            sender.setTitleColor(.red, for: .normal)
            let pushData = PushDataServer()
            pushData.removeAdherent(nom: self.oldNom, id: self.id) // on ne supprime qu'un adhérent déjà enregistré donc on a forcément ses infos
            self.waitForServeur = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.verificationReponse), userInfo: nil, repeats: true)
            
        })
        alert.addAction(annuler)
        alert.addAction(supprimer)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func verificationReponse(){
        print("Reponse serveur = \(serveurReponse)")
        print("Reponse URL = \(reponseURLRequestImage)")
        if serveurReponse != "nil" && reponseURLRequestImage != "nil"{ // 2 réponse
            waitForServeur.invalidate()
            chargement.stopAnimating()
            self.chargementView.isHidden = true
            self.scrollView.isScrollEnabled = true
            if serveurReponse == "success" && reponseURLRequestImage == "success"{
                loadAnOtherAdherent = "\(nomTextField!.text!)%\(dateNaissanceVariable!.currentTitle!)"
                performSegue(withIdentifier: "returnHome", sender: self)
            } else {
                if serveurReponse == "sucess" { // image impossible
                    alert("Enregistrement de l'image impossible", message: "Les autres données ont bien pu être sauvegardées")
                } else if reponseURLRequestImage == "success" { //données impossibke
                    alert("Enregistrement des informations impossible", message: "L'image a elle été enregistrée avec succès")
                } else { // les deux impossible
                    alert("Aucune donnée n'a pas être transmise au serveur", message: "\(serveurReponse). Veuillez réessayer")
                }
            }
            serveurReponse = "nil"
            reponseURLRequestImage = "nil"
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //load l'image selectionnée
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if info[UIImagePickerController.InfoKey.imageURL] != nil {
                self.imageExtension = URL(fileURLWithPath: "\(info[UIImagePickerController.InfoKey.imageURL]!)").pathExtension
                print("\(String(describing: info[UIImagePickerController.InfoKey.originalImage]))")
                
                let defintiveImage = rogneImage(image: image)
                
                self.imageButton?.setImage(defintiveImage, for: .normal)
                let imageData = self.imageButton!.currentImage!.jpegData(compressionQuality: 0.2)
                let imageStr = imageData!.base64EncodedString(options:.endLineWithCarriageReturn)
                print("nbr charactere finale : \(imageStr.count)")
            }
            
        } else {
            print("Image non reconnue (l.143)")
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func rogneImage(image: UIImage) -> UIImage { // rogne les images en carrés parfaits 300/300
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(300)
        var cgheight: CGFloat = CGFloat(300)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    //On n'autorise pas les charactères suivants : impossible de les tapes ou les coller dans les champs
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet(charactersIn: "\"\\/.;,%:()»«¿¡[]{}|~<>•")) == nil
    }
    
    
    
}
