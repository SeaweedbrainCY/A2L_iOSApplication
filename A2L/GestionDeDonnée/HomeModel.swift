//
//  LocationModel.swift
//  A2L
//
//  Created by Nathan on 16/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation



class HomeModel {
    
    var allInfo: [[String:String]] = [[:]]// Voila le tableau qui résumera toutes les données de tous les adhérents
    
    //Va chercher et convertie les données codées en JSON
    public func exctractData(){
        //l'URL de l'API
        let url = URL(string: "http://192.168.1.64:8888/returnSpecificData.php")
        
        
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
                }
                OperationQueue.main.addOperation({
                    //Appelle la fonction une fois que l'opération est finie
                    let maFiche = MaFiche()
                    maFiche.listeInfoAdherent = self.allInfo //On stock la valeur
                    maFiche.loadInfo()//On lance la fonction associée
                    //self.test()
                })
            }
        }).resume()
    }
    
    public func test(){
       
    }
}
