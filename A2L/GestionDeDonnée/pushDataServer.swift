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
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {                    if result as String == "Accès au serveur refusé" { //Si la connexion est refusée
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
    

    
    public func updateAllInfo(id: String, nom: String, classe: String, dateNaissance: String, statut: String){
        let url = "http://\(adresseIPServeur):8888/updateAllInfo.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "id=\(id)&Nom=\(nom)&Classe=\(classe)&DateNaissance=\(dateNaissance)&Statut=\(statut)&idAdmin=\(infosAdherent["id"]!)&MdpAdmin=\(infosAdherent["MdpHashed"]!)"
        print("post = \(postString)")
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    if result as String == "Accès au serveur refusé" { //Si la connexion est refusée
                        serveurReponse = "Accès au serveur refusé"
                    } else {
                        serveurReponse = "success"
                    }
                } else {
                    serveurReponse = "success"
                }
            }
            print("reponse url = \(reponseURLRequestImage)")
        }).resume()
    }
    
    /*----------------------------------------------------------------------------------------------
                                        STOCK IMAGE
     ---------------------------------------------------------------------------------------------*/
    
    public func uploadImage(imageDataString: String, id: String){
        
        let url = "http://\(adresseIPServeur):8888/uploadImage.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "data=\(imageDataString)&id=\(id)&idAdmin=\(infosAdherent["id"]!)&mdpAdmin=\(infosAdherent["MdpHashed"]!)"
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    if result as String == "Accès au serveur refusé" { //Si la connexion est refusée
                        reponseURLRequestImage = "Accès au serveur refusé"
                    } else {
                        reponseURLRequestImage = "success"
                    }
                } else {
                    reponseURLRequestImage = "success"
                }
            }
            print("\n\n****** REPONSE ===== \(serveurReponse)")
        }).resume()
    }
    
    /*----------------------------------------------------------------------------------------------
                                   AJOUT D'UN NOUVEL ADHÉRENT
     ---------------------------------------------------------------------------------------------*/
    
    public func addAdherent(nom: String, classe: String, imageData: String, dateNaissance: String, statut: String){
        let url = "http://\(adresseIPServeur):8888/addAdherent.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "Nom=\(nom)&Classe=\(classe)&ImageData=\(imageData)&DateNaissance=\(dateNaissance)&Statut=\(statut)&idAdmin=\(infosAdherent["id"]!)&MdpAdmin=\(infosAdherent["MdpHashed"]!)"
        print("post = \(postString)")
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    if result as String == "Accès au serveur refusé" { //Si la connexion est refusée
                        serveurReponse = "Accès au serveur refusé"
                        reponseURLRequestImage = "Accès au serveur refusé"
                    } else if result as String == "success"{
                        serveurReponse = "success"
                        reponseURLRequestImage = "success"
                    } else {
                        serveurReponse = "Une erreur inconnue est survenue lors de la connexion au serveur. \(result)"
                        reponseURLRequestImage = "Une erreur inconnue est survenue lors de la connexion au serveur"
                    }
                } else {
                    serveurReponse = "Une erreur inconnue est survenue et empêche la connexion au serveur"
                    reponseURLRequestImage = "Une erreur inconnue est survenue et empêche la connexion au serveur"
                }
            }
        }).resume()
    }
    
    /*----------------------------------------------------------------------------------------------
                                    SUPPRESSION D'UN ADHÉRENT
     ---------------------------------------------------------------------------------------------*/
    
    public func removeAdherent(nom: String, id:String){ // 2 paramètres pour s'assurer qu'on supprime le bonne adéhrent
        let url = "http://\(adresseIPServeur):8888/removeAdherent.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "Nom=\(nom)&id=\(id)&idAdmin=\(infosAdherent["id"]!)&MdpAdmin=\(infosAdherent["MdpHashed"]!)"
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    if result as String == "Accès au serveur refusé" { //Si la connexion est refusée
                        serveurReponse = "Accès au serveur refusé"
                        reponseURLRequestImage = "Accès au serveur refusé"
                    } else if result as String == "success"{
                        serveurReponse = "success"
                        reponseURLRequestImage = "success"
                    } else {
                        serveurReponse = "Une erreur inconnue est survenue lors de la connexion au serveur. \(result)"
                        reponseURLRequestImage = "Une erreur inconnue est survenue lors de la connexion au serveur"
                    }
                } else {
                    serveurReponse = "Une erreur inconnue est survenue et empêche la connexion au serveur"
                    reponseURLRequestImage = "Une erreur inconnue est survenue et empêche la connexion au serveur"
                }
            }
        }).resume()
    }
    
    
    /*----------------------------------------------------------------------------------------------
                                    AJOUT D'UN CODE CONFIDENTIEL
     ---------------------------------------------------------------------------------------------*/
    
    public func stockCodeTemporaire(id: String, codeTemporaire: String) {
        let url = "http://\(adresseIPServeur):8888/stockCodeTemporaire.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "idAdherent=\(id)&CodeTemporaire=\(codeTemporaire)&idAdmin=\(infosAdherent["id"]!)&MdpAdmin=\(infosAdherent["MdpHashed"]!)"
        print("PostSTRING = \(postString)")
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    print("result = \(result as String)")
                    
                    if result as String == "Success" { //Si la connexion est refusée
                        serveurReponse = "success"
                    } else if  result as String == "Accès au serveur refusé"{
                        serveurReponse = "Accès au serveur refusé"
                    }else {
                        serveurReponse = "Une erreur inconnue est survenue"
                    }
                } else {
                    serveurReponse = "Une erreur inconnue est survenue"
                }
                print("serveur = \(serveurReponse)")
            }
            
        }).resume()
    }
    
    /*----------------------------------------------------------------------------------------------
     
     ---------------------------------------------------------------------------------------------*/
    
    public func stockNewMdp(nom: String, mdp: String, codeTemporaire: String) {
        let url = "http://\(adresseIPServeur):8888/stockNewMdp.php"
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "Nom=\(nom)&CodeTemporaire=\(codeTemporaire)&Mdp=\(mdp)"
        print("PostSTRING = \(postString)")
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler : { (data, response, error) in
            if error != nil {
                print("error = \(String(describing: error))")
                serveurReponse = (error?.localizedDescription)!
            } else {
                if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString {
                    print("result = \(result as String)")
                    
                    if result as String == "Success" { //Si la connexion est refusée
                        serveurReponse = "success"
                    } else if  result as String == "Accès au serveur refusé"{
                        serveurReponse = "Accès au serveur refusé"
                    }else {
                        serveurReponse = "Une erreur inconnue est survenue"
                    }
                } else {
                    serveurReponse = "Une erreur inconnue est survenue"
                }
                print("serveur = \(serveurReponse)")
            }
            
        }).resume()
    }
    
}

