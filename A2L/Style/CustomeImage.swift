//
//  CustomeImage.swift
//  A2L
//
//  Created by Nathan on 29/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

var reponseURLRequestImage = "nil" // Reponse su serveur

extension UIImageView {
    public func imageFromUrl(urlString: String) { // Pour download une image à partir d'une url
        print("urlString image = \(urlString)")
        if let url = URL(string: urlString) {
            print("url image = \(url)")
            DispatchQueue.main.async {
                URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                    if error != nil {
                        reponseURLRequestImage = error.debugDescription
                    } else { // Aucune erreur
                        if let imageData = data as Data? {
                            self.image = UIImage(data: imageData as Data)
                            reponseURLRequestImage = "success"
                        }
                    }
                }).resume()
                
            }
        } else { // URL non valide
            reponseURLRequestImage = "Accès aux données demandées impossible"
        }
    }
}
