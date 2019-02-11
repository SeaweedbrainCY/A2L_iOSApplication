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
    public func updatePointFidelite(id: String, pointFidelite: String) {
        //adresseIPServeurMaison = "192.168.1.64"
        //adresseIPServeurTelephone = "172.20.10.2"
        let adresseIPServeur = "192.168.1.64"
        let url = "http://\(adresseIPServeur):8888/stockNewPointFidelite.php"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString:String = "id=\(id)&PointFidelite=\(pointFidelite)"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print("error = \(String(describing: error))")
            } else {
                print("response = \(String(describing: response))")
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(String(describing: responseString))")
            }
            
        }
        task.resume()
    }
}
