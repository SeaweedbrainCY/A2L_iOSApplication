//
//  LocalData.swift
//  A2L
//
//  Created by Nathan on 01/02/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

// Se charge de recuperer ou stocker en local la data (en JSON)
class LocalData {
    var allInfo: [[String:String]] = [[:]]
    
    func returnDataFrom(_ path: String){
        
        var data = "nil"
        do {
            data = try String(contentsOf: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(path), encoding: .utf8)
            
            if let allDataUser = try? JSONSerialization.jsonObject(with: data.data(using: .utf8)!, options: .allowFragments) as? NSArray{ // On enregsitre le tableau total en JSON
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
                    self.allInfo = [temporaryDictionnary] // et on ajoute notre nouveau dico au tableau général
                    print("all info local = \(self.allInfo)")
                    infosAdherent = allInfo[0]
                }
                
            } else {
                print("bug")
            }
        } catch { // Fichier introuvable
            print("Fichier introuvable. ERREUR GRAVE")
        }
        
    }
    
    func stockDataTo(_ path: String) { // On stock toutes les données dans la data local
        var string = "\(infosAdherent)"
        string = string.replacingOccurrences(of: "[", with: "{") // JSON = [{"Nom":"Nathan", "DateNaissance":"2002-14-11"}]
        string = string.replacingOccurrences(of: "]", with: "}")
        let file = FileManager.default
        file.createFile(atPath: URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]).appendingPathComponent(stockInfosAdherent).path, contents: "[\(string)]".data(using: String.Encoding.utf8), attributes: nil)
    }
}
