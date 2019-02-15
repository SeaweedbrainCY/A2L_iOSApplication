//
//  PushDataServer.swift
//  A2L
//
//  Created by Nathan on 11/02/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class PushDataServer {// APIConnexion reçoit les données du serveur, cette classe là les envoie au serveur
    
    
    var reponseServeur = "nil"
    
    
    public func updatePointFidelite(id: String, pointFidelite: String) {
        let url = "http://\(adresseIPServeur):8888/stockNewPointFidelite.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "id=\(id)&PointFidelite=\(pointFidelite)&idAdmin=\(infosAdherent["id"]!)&mdpAdmin=\(infosAdherent["MdpHashed"]!)"
        print("\npostString = \(postString)")
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                print("response = \(String(describing: response))")
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    print("result = \(result)")
                    if result! as String == "Accès au serveur refusé" { //Si la connexion est refusée
                        serveurReponse = "Accès au serveur refusé"
                    } else {
                        serveurReponse = "success"
                    }
                } else {
                    serveurReponse = "success"
                }
                print("serveur = \(serveurReponse)")
            }
            
        }).resume()
    }
    
    public func updateAllInfo(id: String, nom: String, classe: String, URLimg: String, dateNaissance: String, statut: String){
            
        let url = "http://\(adresseIPServeur):8888/updateAllInfo.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "id=\(id)&Nom=\(nom)&Classe=\(classe)&URLimg=\(URLimg)&DateNaissance=\(dateNaissance)&Statut=\(statut)&idAdmin=\(infosAdherent["id"]!)&mdpAdmin=\(infosAdherent["MdpHashed"]!)"
        print("post = \(postString)")
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                print("response = \(String(describing: response))")
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    if result! as String == "Accès au serveur refusé" { //Si la connexion est refusée
                        serveurReponse = "Accès au serveur refusé"
                    } else {
                        serveurReponse = "success"
                    }
                } else {
                    serveurReponse = "success"
                }
            }
        }).resume()
    }
}
