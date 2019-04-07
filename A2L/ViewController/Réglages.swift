//
//  Réglages.swift
//  A2L
//
//  Created by Nathan on 09/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

//Associé à la page des réglage (page 3/3)



class Reglages: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell") //on associe la tableView au custom de Style/customeCelleTableView.swift
    }
    
    func alert(_ title: String, message: String) { // pop up simple, avec un seul bouton de sortie
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int { // nbr de section
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Cellules par section
        switch section {
        case 0 : return 2
        case 1 : return 2
        case 2 : return 2
        default : return 0
            
        }
    }
    
    //Nom des cellules
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.textLabel?.font = UIFont(name: "Comfortaa-Bold", size: 17)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0 :
                cell.textLabel?.text = "     Aide"
                cell.iconCell.image = UIImage(named: "helpLocation")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .black
                cell.imageAtEnd.image = UIImage(named: "next")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.imageAtEnd.tintColor = .gray
                cell.imageAtEnd.frame.origin.x = self.view.frame.size.width - cell.imageAtEnd.frame.size.width - 3
                //cell.imageAtEnd.center.y = cell.center.y
            case 1 :
                cell.textLabel?.text = "     Contribuer au projet"
                cell.iconCell.image = UIImage(named: "codeBalise")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .black
            default : cell.textLabel?.text = "ERROR"
            }
        } else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "     Signaler"
                cell.iconCell.image = UIImage(named: "security")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .black
            case 1 :
                cell.textLabel?.text = "     Visiter le site du developpeur"
                
                cell.iconCell.image = UIImage(named: "codePhone")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .black
            default : cell.textLabel?.text = "ERROR"
            }
        } else {
            switch indexPath.row {
            case 0 :
                cell.textLabel?.text = "     Actualiser mes infos"
                cell.iconCell.image = UIImage(named: "refresh")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .black
            case 1 :
                cell.textLabel?.text = "    Se déconnecter"
                cell.iconCell.image = UIImage(named: "croix")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .red
                cell.textLabel?.textColor = .red
            default : cell.textLabel?.text = "ERROR"
            }
            
        }
        return cell
    }
    
    //Nom des sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "L'application A2L"
        case 1 : return "Developpeur"
        case 2: return "Mon compte"
        default : return "ERROR"
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // cellule selctionnée
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0 :
                performSegue(withIdentifier: "helpPage", sender: self)
            case 1:
                let alert = UIAlertController(title: "Contribuer au projet A2L", message: "Ces liens donnent un accès aux codes sources du projet (GitHub)", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "[GitHub] Code source application iOS", style: .default) { _ in
                    UIApplication.shared.open(URL(string: "https://github.com/DevNathan/A2L_iOSApplication")!, options: [:], completionHandler: nil)// on charge le lien dans le moteur de recherche par defaut de l'utilisateur
                })
                
                alert.addAction(UIAlertAction(title: "[GitHub] Code source application Android", style: .default) { _ in
                    self.alert("Ce repository n'a pas encore été créé", message: "Vous pourrez consulter le code source quand il sera publié")
                })
                
                alert.addAction(UIAlertAction(title: "[GitHub] Code source backend (serveur)", style: .default) { _ in
                    UIApplication.shared.open(URL(string: "https://github.com/DevNathan/A2L_BackEnd")!, options: [:], completionHandler: nil)// on charge le lien dans le moteur de recherche par defaut de l'utilisateur
                })
                
                alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertAction.Style.cancel, handler: nil)) // Retour
                present(alert, animated: true)
                
            default : break
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0 : // Signaler
                let alert = UIAlertController(title: "Signaler", message: "Signaler un bug ou erreur permet au developpeur d'améliorer l'app. Merci beaucoup", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Signaler un bug", style: .default) { _ in
                    self.mailReport(objet: "J'ai trouvé un bug dans l'application iOS de l'A2L!", body: "")
                })
                alert.addAction(UIAlertAction(title: "Contacter le developpeur", style: .default) { _ in
                    self.mailReport(objet: "J'ai un message pour toi !", body: "Envoyé depuis l'application iOS de l'A2L\n")
                })
                alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertAction.Style.cancel, handler: nil)) // Retour
                present(alert, animated: true)
                
            case 1: // site du developpeur
                UIApplication.shared.open(URL(string: "https://nathanstchepinsky--nathans1.repl.co")!, options: [:], completionHandler: nil) // on charge le lien dans le moteur de recherche par defaut de l'utilisateur
            default : break
            }
        } else {
            switch indexPath.row {
            case 0 : //Actualiser les privilèges
                let chargement = UIActivityIndicatorView()
                self.tableView.addSubview(chargement)
                chargement.style = .white
                chargement.color = .red
                chargement.frame.origin = CGPoint(x: self.tableView.frame.size.width / 2, y: self.tableView.frame.size.height / 2) // on le place en plein milieu
                chargement.startAnimating()
                self.actualisationInformations() // on actualise les informations
            case 1 : // Se deconnecter
                performSegue(withIdentifier: "pageConnexion", sender: self)
                let file = FileManager.default
                file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(stockInfosAdherent).path, contents: "".data(using: String.Encoding.utf8), attributes: nil)
            default : break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Méthode servant à envoyer un mail avec les protocoles d'Apple ou avec du HTML
    func mailReport(objet: String, body: String){
        // ATTENTION ON A BESOIN DE 'import MessageUI' et du protocole: MFMailComposeViewControllerDelegate
        let email = "nathanstchepinsky@gmail.com"
        let subject = objet
        let bodyText = body
        if MFMailComposeViewController.canSendMail() {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([email])
            mailComposerVC.setSubject(subject)
            mailComposerVC.setMessageBody(bodyText, isHTML: true)
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            let coded = "mailto:\(email)?subject=\(subject)&body=\(bodyText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let emailURL = URL(string: coded!){
                if UIApplication.shared.canOpenURL(emailURL){
                    UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
                        if !result {
                            self.alert("Oupsi j'ai rencontré un bug !!", message: "Je n'arrive pas à acceder aux mails :(")
                        }
                    })
                }
            }
        }
    }
    
    /**
     Cette fonction est appelé par le **Delegate** lorsque l'utilisateur intéragit avec le bouton **envoyer/annuler** de l'email
     - Parameter _ controller : Correspond au MFMail encore ouvert
     - Parameter result : Donne le résultat des actions de l'utilisateur
     - Parameter error : Si une erreur est survenu, elle y sera détaillée. Par defaut, il vaut **nil**
     */
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        // Check the result or perform other tasks.
        
        
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
        if error != nil { // S'il y a une erreur
            alert("Une erreur est survenue", message: "Une erreur est survenu de cause inconnu. Veuillez signaler cette erreur : \(String(describing: error)) au developpeur. Merci.")
        }
    }
    
    var timer = Timer()
    func actualisationInformations(){
        let api = APIConnexion()
        let nom = api.convertionToHexaCode("\(infosAdherent["Nom"]!)")
        if let mdp = infosAdherent["MdpHashed"] { // Si on detecte un mdp c'est qu'on est admin
            api.adminConnexion(nom: nom, mdpHashed: api.convertionToHexaCode(mdp))
        } else { // sinon non
            api.adherentConnexion(nom: nom, dateNaissance: infosAdherent["DateNaissance"]!)
        }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(verificationReponse), userInfo: nil, repeats: true)
    }
    
    


@objc private func verificationReponse(){ // est appelé par le compteur pour verifier si on a une réponse
    
    if serveurReponse != "nil" { // Si on a une réponse
        timer.invalidate() // On désactive le timer il ne sert plus a rien
         if serveurReponse == "success" { // Si on y arrive on réinstalle les données
            //La connexion est réussi et acceptée par le serveur
            performSegue(withIdentifier: "backToHomePage", sender: self)
         } else { // sinon on se reconnecte : ex si le prénom à changé, on est obligé de déconnecter
            performSegue(withIdentifier: "pageConnexion", sender: self)
        }
    } else {
        
    }
        //On réinitialise l'erreur :
        serveurReponse = "nil"
        
    }
}




