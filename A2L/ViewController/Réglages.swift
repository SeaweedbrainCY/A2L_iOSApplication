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

let testeur = "testeurProfil.txt" // "Super-admin"/"Membre du bureau"/"Adhérent"

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
        case 0 : return 3
        case 1 : return 2
        case 2 : return 2
        default : return 0
            
        }
    }
    
    //Nom des cellules
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0 :
                var statut = ""
                do { // on va chercher le statut, et on le met dans le titre
                    statut = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(testeur), encoding: .utf8)
                } catch {
                    print("Fichier introuvable. ERREUR GRAVE")
                }
                cell.textLabel?.text = "📲 Testeur : \(statut)"
            case 1 :
                cell.textLabel?.text = "     Aide"
                cell.iconCell.image = UIImage(named: "helpLocation")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .gray
            case 2 :
                cell.textLabel?.text = "     Contribuer au projet"
                cell.iconCell.image = UIImage(named: "codeBalise")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .gray
            default : cell.textLabel?.text = "ERROR"
            }
        } else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "     Signaler"
                cell.iconCell.image = UIImage(named: "security")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .gray
            case 1 :
                cell.textLabel?.text = "     Visiter le site du developpeur"
                cell.iconCell.image = UIImage(named: "codePhone")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .gray
            default : cell.textLabel?.text = "ERROR"
            }
        } else {
            switch indexPath.row {
            case 0 :
                cell.textLabel?.text = "     Actualiser mes privilèges"
                cell.iconCell.image = UIImage(named: "refresh")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .gray
                cell.info.setImage(UIImage(named: "help"), for: .normal)
                cell.info.addTarget(self, action: #selector(helpSelected), for: .touchUpInside)
            case 1 :
                cell.textLabel?.text = "    Se déconnecter"
                cell.iconCell.image = UIImage(named: "croix")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.iconCell.tintColor = .red
                cell.textLabel?.textColor = .red
            default : cell.textLabel?.text = "ERROR"
            }
            
        }
        //On colore l'image en rouge
        
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
            case 0 : // on affiche un menu avec 3 options pour choisir notre statut de bêta testeur
                let alert = UIAlertController(title: "Changer de profil testeur", message: "Cette fonctionnalité ne sera disponible que durant les phases de tests de l'applications (toutes les droits sont présumés acquis)", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Adhérent", style: .default) { _ in
                    self.nouveauStatut("Adhérent")
                })
                alert.addAction(UIAlertAction(title: "Membre du bureau", style: .default) { _ in
                    self.nouveauStatut("Membre du bureau")
                })
                alert.addAction(UIAlertAction(title: "Super-admin", style: .default) { _ in
                    self.nouveauStatut("Super-admin")
                })
                alert.addAction(UIAlertAction(title: "Annuler", style: UIAlertAction.Style.cancel, handler: nil)) // Retour
                present(alert, animated: true)
            case 1 : break
            case 2:
                let alert = UIAlertController(title: "Contribuer au projet 'A2Lé", message: "Ces liens donnent un accès aux codes sources du projet (GitHub)", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "[GitHub] Code source application iOS", style: .default) { _ in
                    UIApplication.shared.open(URL(string: "https://github.com/DevNathan/A2L_Application")!, options: [:], completionHandler: nil)// on charge le lien dans le moteur de recherche par defaut de l'utilisateur
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
                    self.mailReport(objet: "J'ai trouvé un bug !", body: "")
                })
                alert.addAction(UIAlertAction(title: "Contacter le developpeur", style: .default) { _ in
                    self.mailReport(objet: "J'ai un message pour toi !", body: "")
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
            case 1 : // Se deconnecter
                performSegue(withIdentifier: "pageConnexion", sender: self)
            default : break
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //est appelé lorsqu'on change notre statut et donc modifie les privilège
    func nouveauStatut(_ statut : String){
        //on stock le nouveau statut
        let file = FileManager.default
        file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(testeur).path, contents: statut.data(using: String.Encoding.utf8), attributes: nil)
        self.tableView.reloadData()

    }
    
    @objc func helpSelected(sender: UIButton){ // help button
        alert("Actualiser mes privilèges", message: "Certaines fonctionnalités de l'application A2L, nécessitent des privilèges. Si un administrateur a modifié vos privilèges et qu'ils ne s'affichent pas, veuillez 'actualiser les privilèges'")
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
}
