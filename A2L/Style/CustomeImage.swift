//
//  CustomeImage.swift
//  A2L
//
//  Created by Nathan on 29/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit



extension UIImageView {
    
    public func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -2.0, 2.0, 0.0 ]
        layer.add(animation, forKey: "transform.translation.x")
    }
    
    public func imageFromDatabase(idAdherent id: String){
        let url = URL(string: "http://\(adresseIPServeur)/api/loadImage.php")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let postString:String = "idAdherent=\(id))"
        request.httpBody = postString.data(using: .utf8)
        
       
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in // On load le PHP
            if error != nil {
                print("******ERROR FATAL. URL NON FONCTIONNEL. ECHEC : \(String(describing: error))")
                
                serveurReponse = error!.localizedDescription
                
                
            } else { // Si aucune erreur n'est survenu
                if let dataString = ((try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSString) as NSString??){ // On enregsitre la data  en JSON
                    if dataString == "Accès au serveur refusé" { // erreur
                        reponseURLRequestImage = "Une erreur s'est produite lors de la connexion au serveur"
                    } else if dataString == "Aucune données"{ // erreur
                        reponseURLRequestImage = "Impossible de trouver la photo associée"
                    } else if dataString == "none"{
                        reponseURLRequestImage = "none"
                        print("none")
                    } else { // pas d'erreur
                        let string = String(dataString ?? "")
                        print("nombre de caractère = \(string.count)")
                        if UIImage(data:Data(base64Encoded: string)!) != nil  {
                            let image: UIImage = UIImage(data:Data(base64Encoded: string)!)!
                            imageId = image
                            reponseURLRequestImage = "success"
                        } else { //l'image n'est pas compatible
                            reponseURLRequestImage = "Impossible de charger le fichier : L'image demandée n'est pas compatible"
                        }
                        
                        
                    }
                }
            }
        }).resume()
    }
}


//Permet de connaitre l'extension d'une image : trouvé sur https://stackoverflow.com/questions/29644168/get-image-file-type-programmatically-in-swift
import ImageIO

struct ImageHeaderData{
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
}

enum ImageFormat{
    case Unknown, PNG, JPEG, GIF, TIFF
}


extension NSData{
    var imageFormat: ImageFormat{
        var buffer = [UInt8](repeating: 0, count: 1)
        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
        if buffer == ImageHeaderData.PNG
        {
            return .PNG
        } else if buffer == ImageHeaderData.JPEG
        {
            return .JPEG
        } else if buffer == ImageHeaderData.GIF
        {
            return .GIF
        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02{
            return .TIFF
        } else{
            return .Unknown
        }
    }
}
