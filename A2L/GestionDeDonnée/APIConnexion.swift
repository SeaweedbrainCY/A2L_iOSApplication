//
//  LocationModel.swift
//  A2L
//
//  Created by Nathan on 16/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

let erreurPath = "erreurPath.text"

class APIConnexion {
    
    var allInfo: [[String:String]] = [[:]]// Voila le tableau qui résumera toutes les données de tous les adhérents
    

    //Va chercher et convertie les données codées en JSON.
    public func exctractData(nom: String, mdpHashed: String) {
        //l'URL de l'API avec les données voulues.
        
        //ATTENTION : Les données transmises par l'URL doivent être sûr. Il doit bien s'agir d'un nom suivit d'un prénom, et d'un mot de passe hashé
        //Les caractères spéciaux devront être remplacés
        //L'API se charge juste de verifier et transmettre les données. Tout bug est donc de la responsbilité de l'application
        var reponse = "error"
        let urlString = "http://192.168.1.64:8888/returnSpecificData.php?Nom=\(nom)&Mdp=\(mdpHashed)"
        let url = URL(string: urlString)
        
        print("url \(String(describing: url))")
        if url != nil {
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in // On load le PHP
                if error != nil {
                    print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                    
                    let file = FileManager.default
                    file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(erreurPath).path, contents: error?.localizedDescription.data(using: String.Encoding.utf8), attributes: nil)
                    
                    
                } else { // Si aucune erreur n'est survenu
                    if let JSONObject = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray{ // On enregsitre le tableau total en JSON
                        
                        if JSONObject != nil {
                            for informations in JSONObject! {
                                if let information = informations as? NSDictionary { // On transforme le tableau total en dictionnaires
                                    //Pour une raison qui m'est obscure, les informations ne seront pas classés dans cet ordre ...
                                    var temporaryDictionnary: [String:String] = [:] // tableau temporaire qui sert à convertir les données avant de les enregsitrer
                                    temporaryDictionnary.updateValue(information.value(forKey: "id") as! String, forKey: "id")
                                    temporaryDictionnary.updateValue(information.value(forKey: "Nom") as! String, forKey: "Nom")
                                    temporaryDictionnary.updateValue(information.value(forKey: "Statut") as! String, forKey: "Statut")
                                    temporaryDictionnary.updateValue(information.value(forKey: "DateNaissance") as! String, forKey: "dateNaissance")
                                    temporaryDictionnary.updateValue(information.value(forKey: "URLimg") as! String, forKey: "URLimg")
                                    self.allInfo.append(temporaryDictionnary) // et on ajoute notre nouveau dico au tableau général
                                    reponse = "success"
                                }
                            }
                            
                        } else if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                            print("string")
                            //let pageConnexion = ConnexionAdmin()
                            
                            if result! as String == "Autorisation refusée" { //Si la connexion est refusée
                                reponse = "permission refusée"
                                //print("permission refusée")
                                //pageConnexion.errorWhileConnectingToDatabase(erreur: "Autorisation refusée")
                            } else if result! as String == "Mdp incorrect" {
                                reponse = "Mdp incorrect"
                                //print("mdp incorrect")
                                //pageConnexion.errorWhileConnectingToDatabase(erreur: "Mdp incorrect")
                            }
                        }
                    }
                    OperationQueue.main.addOperation({ // Une fois l'action effectuée on envoie le resultat
                        let file = FileManager.default
                        file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(erreurPath).path, contents: reponse.data(using: String.Encoding.utf8), attributes: nil)
                    })

                }
            }).resume()
        } else { //bug dans l'URL
            reponse =  "url nil"
           // let pageConnexion = ConnexionAdmin()
            //pageConnexion.errorWhileConnectingToDatabase(erreur : "url nil")
        }
        
    }
    
    //Gère la connexion d'un adhérent simple :
    public func adherentConnexion(nom: String, dateNaissance: String){
        //ATTENTION : Les données transmises par l'URL doivent être sûr. Il doit bien s'agir d'un nom suivit d'un prénom, et d'une date de la forme YYYY-MM-DD
        //Les caractères spéciaux devront être remplacés
        //L'API se charge juste de verifier et transmettre les données. Tout bug est donc de la responsbilité de l'application
        
        var reponse = "error"
        let urlString = "http://192.168.1.64:8888/infoAdherent.php?Nom=\(nom)&DateNaissance=\(dateNaissance)"
        let url = URL(string: urlString)
        print("url = \(url)")
        if url != nil {
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in // On load le PHP
                if error != nil {
                    print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                    
                    let file = FileManager.default
                    file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(erreurPath).path, contents: error?.localizedDescription.data(using: String.Encoding.utf8), attributes: nil)
                    
                    
                } else { // Si aucune erreur n'est survenu
                    
                    if let allDataUser = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray{ // On enregsitre le tableau total en JSON
                        print("dataUser = \(String(describing: allDataUser))")
                        if allDataUser != nil {
                            let dataUser: NSDictionary = allDataUser![0] as! NSDictionary // On a qu'une seule valeur -> voir API
                            //Pour une raison qui m'est obscure, les informations ne seront pas classés dans cet ordre ...
                            var temporaryDictionnary: [String:String] = [:] // tableau temporaire qui sert à convertir les données avant de les enregsitrer
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "id") as! String, forKey: "id")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Nom") as! String, forKey: "Nom")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "Statut") as! String, forKey: "Statut")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "DateNaissance") as! String, forKey: "DateNaissance")
                            temporaryDictionnary.updateValue(dataUser.value(forKey: "URLimg") as! String, forKey: "URLimg")
                            self.allInfo.append(temporaryDictionnary) // et on ajoute notre nouveau dico au tableau général
                            print("all info = \(self.allInfo)")
                            reponse = "success"
                        } else if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                            //let pageConnexion = ConnexionAdmin()
                            print("resulat = \(result)")
                            
                            if result! as String == "Élève introuvable" { //Si la connexion est refusée
                                reponse = "Élève introuvable"
                                //print("permission refusée")
                                //pageConnexion.errorWhileConnectingToDatabase(erreur: "Autorisation refusée")
                            } else if result! as String == "Date de naissance incorrect" {
                                reponse = "Date de naissance incorrect"
                                //print("mdp incorrect")
                                //pageConnexion.errorWhileConnectingToDatabase(erreur: "Mdp incorrect")
                            }
                        }
                    } else {
                        print("bug")
                    }
                    OperationQueue.main.addOperation({ // Une fois l'action effectuée on envoie le resultat
                        print("result message = \(reponse)")
                        //let adherentPage = ConnexionAdherent()
                        //adherentPage.saveData(self.allInfo[1])
                        infosAdherent = self.allInfo[1]
                        let file = FileManager.default
                        file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(erreurPath).path, contents: reponse.data(using: String.Encoding.utf8), attributes: nil)
                        
                        if reponse == "success" { // Si on a réussi on stock les infos de l'adhérent pour 'garder la session ouverte'
                            let file = FileManager.default
                            file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(informationConnexionAdhrent).path, contents: "\(nom)#\(dateNaissance)".data(using: String.Encoding.utf8), attributes: nil)
                        }
                    })
                    
                }
            }).resume()
        } else { //bug dans l'URL
            print("url = nil")
            let file = FileManager.default
            file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(erreurPath).path, contents: "Les informations saisies semblent comporter des caractères inconnus".data(using: String.Encoding.utf8), attributes: nil)
            // let pageConnexion = ConnexionAdmin()
            //pageConnexion.errorWhileConnectingToDatabase(erreur : "url nil")
        }
    }
    
    //Sert à convertir un text UTF8 en admissible par une URL
    //Charactères spéciaux autorisés : *$€£%ù+=?!@#&àç-
    public func convertionToHexaCode(_ letText: String) -> String{
        var text = letText
        let listeCharactereSpeciaux: [Character: String] = ["$": "%24", "€": "%80", "£": "%a3", "ù":"%C3%B9", "+":"%2b", "=":"%3d", "?":"%3f", "!":"%21", "@":"%40", "#":"%23", "&":"%26", "à":"%C3%A0", "ç":"%e7", "-":"%2d", " ":"%20", "*": "%2A", "é":"%C3%A9","è":"%C3%A8", "ê":"%C3%AA", "ë":"%CA%AB", "ü":"%C3%BC", "û":"%C3%BB", "É":"%C3%89",  "È":"%C3%88", "Ê":"%C3%8A", "Ë":"%C3%8B", "Û":"%C3%9B", "Ü":"%C39C"]
        for (charactere, code) in listeCharactereSpeciaux {
            if text.contains(charactere) { // Si on a un charactère spécial
                text = text.replacingOccurrences(of: String(charactere), with: code) // On le remplace par son code hexa
            }
        }
       return text
    }
}
