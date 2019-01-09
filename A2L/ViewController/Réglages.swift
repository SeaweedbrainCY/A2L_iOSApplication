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

let testeur = "testeurProfil.txt" // "Super-admin"/"Membre du bureau"/"Adhérent"

class Reglages: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func alert(_ title: String, message: String) {
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
        case 2 : return 1
        default : return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "basic")
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0 :
                var statut = ""
                do {
                    statut = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(testeur), encoding: .utf8)
                } catch {
                    print("Fichier introuvable. ERREUR GRAVE")
                }
                cell.textLabel?.text = "📲 Testeur : \(statut)"
            case 1 : cell.textLabel?.text = "🚨 Aide"
            default : cell.textLabel?.text = "ERROR"
            }
        } else if indexPath.section == 1{
            switch indexPath.row {
            case 0: cell.textLabel?.text = "✉️ Signaler"
            case 1 : cell.textLabel?.text = "💻 Visiter le site du developpeur"
            default : cell.textLabel?.text = "ERROR"
            }
        } else {
            cell.textLabel?.text = "❌ Se déconnecter"
            cell.textLabel?.textColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "En savoir plus ..."
        case 1 : return "Developpeur"
        default : return "ERROR"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // cellule selctionnée
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0 :
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
                UIApplication.shared.open(URL(string: "https://nathanstchepinsky--nathans1.repl.co")!, options: [:], completionHandler: nil)
                
            default : break
            }
        } else {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func nouveauStatut(_ statut : String){
        let file = FileManager.default
        file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(testeur).path, contents: statut.data(using: String.Encoding.utf8), attributes: nil)
        self.tableView.reloadData()

    }
    
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
