//
//  LocationModel.swift
//  A2L
//
//  Created by Nathan on 16/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class APIConnexion {
    
    var allInfo: [[String:String]] = [[:]]// Voila le tableau qui résumera toutes les données de tous les adhérents
    

    //Va chercher et convertie les données codées en JSON
    public func exctractData(nom: String, mdpHashed: String){
        //l'URL de l'API avec les données voulues.
        
        //ATTENTION : Les données transmises par l'URL doivent être sûr. Il doit bien s'agir d'un nom suivit d'un prénom, et d'un mot de passe hashé
        //Les caractères spéciaux devront être remplacés
        //L'API se charge juste de verifier et transmettre les données. Tout bug est donc de la responsbilité de l'application
        let maFiche = MaFiche()
        
        
        
        let urlString = "http://192.168.1.64:8888/returnSpecificData.php?Nom=\(nom)&Mdp=\(mdpHashed)"
        print("urlstring = \(urlString)")
        let url = URL(string: urlString)
        
        print("url \(String(describing: url))")
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in // On load le PHP
            if error != nil {
                print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                
            } else { // Si aucune erreur n'est survenu
                if let JSONObject = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray{ // On enregsitre le tableau total en JSON
                    for informations in JSONObject! {
                        if let information = informations as? NSDictionary { // On transforme le tableau total en dictionnaires
                            //Pour une raison qui m'est obscure, les informations ne seront pas classés dans cet ordre ...
                            var temporaryDictionnary: [String:String] = [:] // tableau temporaire qui sert à convertir les données avant de les enregsitrer
                            temporaryDictionnary.updateValue(information.value(forKey: "id") as! String, forKey: "id")
                            temporaryDictionnary.updateValue(information.value(forKey: "Nom") as! String, forKey: "Nom")
                            temporaryDictionnary.updateValue(information.value(forKey: "Statut") as! String, forKey: "Statut")
                            temporaryDictionnary.updateValue(information.value(forKey: "DateNaissance") as! String, forKey: "dateNaissance")
                            self.allInfo.append(temporaryDictionnary) // et on ajoute notre nouveau dico au tableau général
                        }
                    }
                } else if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    let pageConnexion = connexionAdmin()
                    if result! as String == "Autorisation refusée" { //Si la connexion est refusée
                        
                        pageConnexion.errorWhileConnectingToDatabase(erreur: "Autorisation refusée")
                    } else if result! as String == "Mdp incorrect" {
                        pageConnexion.errorWhileConnectingToDatabase(erreur: "Mdp incorrect")
                    }

                OperationQueue.main.addOperation({
                    //Appelle la fonction une fois que l'opération est finie
                    maFiche.listeInfoAdherent = self.allInfo //On stock la valeur
                    maFiche.loadInfo()//On lance la fonction associée
                    //self.test()
                })
            }
            
        }
        }).resume()
    }
    
    //Sert à convertir un text UTF8 en admissible par une URL
    //Charactères spéciaux autorisés : *$€£%ù+=?!@#&àç-
    public func convertionToHexaCode(_ letText: String) -> String{
        var text = letText
        let listeCharactereSpeciaux: [Character: String] = ["$": "%24", "€": "%80", "£": "%a3", "%":"%25", "ù":"%fa", "+":"%2b", "=":"%3d", "?":"%3f", "!":"%21", "@":"%40", "#":"%23", "&":"%26", "à":"%e0", "ç":"%e7", "-":"%2d"]
        for (charactere, code) in listeCharactereSpeciaux {
            if text.contains(charactere) { // Si on a un charactère spécial
                text = text.replacingOccurrences(of: String(charactere), with: code) // On le remplace par son code hexa
            }
        }
        
       return text
    }
}
