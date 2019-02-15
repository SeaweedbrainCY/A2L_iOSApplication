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
    public func imageFromUrl(urlString: String) { // Pour download une image à partir d'une url
        print("urlString image = \(urlString)")
        if let url = URL(string: urlString) {
            print("url image = \(url)")
            DispatchQueue.main.async {
                URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
                    if error != nil {
                        reponseURLRequestImage = (error?.localizedDescription)!
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
    
    public func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -2.0, 2.0, 0.0 ]
        layer.add(animation, forKey: "transform.translation.x")
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
