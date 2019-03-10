//
//  Help.swift
//  A2L
//
//  Created by Nathan on 05/03/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class Help: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let titleAboutSecurity = ["Qui a accès à mes informations ?", "Comment sont stockés mes informations ?", "Comment sont stockés les mots de passe ?", "Est-ce que 'Open Source' signifie que tout le monde a accès à mes données ?", "[Avancé] Comment l'accès au serveur est-il géré ?"]
    let descriptionAboutSecurity = [ "Seuls vous et les membres du bureau de l'A2L ont accès à vos informations. Elles ne sont partagées avec aucun autre service et les seuls moyens de récuprer vos données se font avec votre date de naissance ou le mot de passe des admin. Ainsi seuls les application officielles peuvent gerer vos données.\nAucune entorse de sera jamais toléré par l'association comme par lez développeurs.", "Lorsque qu'un membre du bureau crée votre fiche adhérent, toutes les données sont stockés sur le serveur de l'A2L.\n Elles ne peuvent être modifiées qu'avec la connexion au serveur avec un mot de passe spécifique aux applications et aux mots de passes des membres du bureau. Les méthodes de transmission de données sont sécurisées et capables de parer un grand nombre d'attaqie.", "Les mots de passe des admin sont stocké sur le serveur sous la forme d'un hash.\nOk mais c'est quoi ? La méthode de hashage est une méthode VITALE pour la conservation de mots de passes. Elle consiste à 'faire rentrer votre mots de passes dans un machine' qui va en sortir une chaine de caractère complétement imbuvable et avec laquelle il est strcitement impossible de rentrouver la chaine de caractère originale. Lorsque que vous vous connecter, on hash donc votre mot de passe et on regarde si le hash correspond au hash déjà enregsitré.\nDans le cas des applications dès l'instant où vous appuyez sur 'se connecter' votre mot de passe est immédiatement hashé par l'application. Ainsi à aucun moment l'application possède le mot de passe en clair. Ensuite, lors de sa connexion au serveur, il fournit donc son hash à la base de donnée. Elle va le hasher une 2e fois pour le stocker. Ainsi le hash stocké ne correspond pas au hash de l'application. Cela renforce grandement la sécurité des mots de passes. Cette dernière est pleinement fonctionnelle et sûre.", "Open source de l'anglais rivière ouverte (non je déconne 'source ouvrte') signifie que le code source de l'application et du serveur (qui gère la gestion des données) est connu, consultable et modifiable par tous. Cela signifie que tout le monde peut comprendre comment le programme tourne. EN REVANCHE, la base de donnée et les codes confidentiels de connexion à celle-ci sont strictement privés et ne sont pas dévoilé au grand public.\nPar exemple, on sait comment fonctionne la poste. Tous les jours, à tel heure, un camion passe et dépose dans notre boite au lettre des colis/lettres ou alors tous les jours les 'boites aux lettres jaunes' sont relevées pour transmettre les lettres postées. Ce fonctionnement est connu de tous. Date, horaire, lieu et fonction. Cependant cela ne vous permet de pas de voir le contenu des lettres. Un projet open source c'est la même chose. On en voit le fonctionnement mais pas les données qui transitent./n\nAinsi le gros avantage est que le projet peut être repris pour être amélioré !! Et j'encourage les petits génies de l'informatiques qui liront ceci à vite reprendre l'application pour l'améliorer encore et encore. Et en plus de cela, il est très facile de découvrir d'eventuels failles qui pourront être corrigées très rapidement.'", "Attention : cette partie necessite quelque connaissances en developpement. Rien ne t'empêche de lire ces lignes mais savoir changer une police dans word ne sera pas suffisant je le craint.\n\nL'accèes au serveur est géré par deux authentification. La première est la clé de connexion disposé par les applications. Elles sont stockées dans un fichier privé qui n'est pas partagé. Cette clé permet donc la connexion à la base MySQL afin de lancer la requète. Elles permettent donc de s'assurer que seuls les applications peuvent utiliser l'API du serveur. Enfin si ces informatiosn sont corrects, 99% des requètes nécessites le mot de passe de l'admin. Si celui est correct et UNIQUEMENT dans cette configuration, l'accès au serveur sera permis (le 1% concerne la connexion des ahdérents qui se fait avec la date de naissance.\nAinsi, la connexion se base sur 2 critères essentiels."]
    
    
    let titleAboutUsing = ["A quoi sert le QR code ?", "Qui sont les membres du bureau ?", "Pourquoi me demande-ton ma date de naissance ?", "[Admin] Quels sont mes privilèges ?", "[Admin] Comment devenir admin ?", "[Admin] Quels sont les critères requis pour ajouter un adhérent", "[Admin] Qu'est ce que le code temporaire ?", "[Admin] Comment créer ou modifier un mot de passe ?", "[Admin] Que se passe-t-il lorsqu'un admin perd son grade ?"]
    let titleAboutError = ["Impossible de me connecter car mon mot de passe est incorrect", "Impossible de me connecter car l'accès est refusé", "Impossible de me connexter : The request time out", "Impossible de me connecter au cause d'une erreur inconnue"]
    let titleAboutApp = ["Que siginfie open source ?", "Comment participer au projet de l'application ?", "Comment le serveur fonctionne-t-il ?"]
    
    var titleSelected = "Error"
    var descriptionSelected = "Error"
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // Cellules par section
        switch section {
        case 0 : return titleAboutSecurity.count
        case 1 : return titleAboutUsing.count
        case 2 : return titleAboutError.count
        default : return titleAboutApp.count
            
        }
    }
    
    //Nom des cellules
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.textLabel?.font = UIFont(name: "Comfortaa-Bold", size: 16)
        cell.textLabel?.numberOfLines = 2
        if indexPath.section == 0 {
            cell.textLabel?.text = titleAboutSecurity[indexPath.row]
            
            cell.imageAtEnd.image = UIImage(named: "next")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.imageAtEnd.tintColor = .black
        } else if indexPath.section == 1{
            cell.textLabel?.text = titleAboutUsing[indexPath.row]
            cell.imageAtEnd.image = UIImage(named: "next")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.imageAtEnd.tintColor = .black
        } else if indexPath.section == 2{
            cell.textLabel?.text = titleAboutError[indexPath.row]
            cell.imageAtEnd.image = UIImage(named: "next")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.imageAtEnd.tintColor = .black
            
        } else {
            cell.textLabel?.text = titleAboutApp[indexPath.row]
            cell.imageAtEnd.image = UIImage(named: "next")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            cell.imageAtEnd.tintColor = .black
        }
        return cell
    }
    
    //Nom des sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "Sécurité"
        case 1 : return "Utilisation de l'app"
        case 2 : return "Les erreurs"
        case 3 : return "A propos de l'application"
        default : return "ERROR"
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // cellule selctionnée
        let allTitle = [titleAboutSecurity, titleAboutUsing, titleAboutError, titleAboutApp]
        let allDescription = [descriptionAboutSecurity]
        titleSelected = allTitle[indexPath.section][indexPath.row]
        descriptionSelected = allDescription[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "showHelp", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHelp" {
            let transfere = segue.destination as! ShowHelp
            transfere.titleTransmitted = titleSelected
            transfere.descriptionTransmitted = descriptionSelected
        }
    }
}
