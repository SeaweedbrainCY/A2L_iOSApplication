//
//  GenerateQRcode.swift
//  A2L
//
//  Created by Nathan on 10/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

//Permet de generer un QR code à l'aide d'une string donnée
/*NOTE IMPORTANTE : Le QR Code est accessible à tout le monde, et tout le monde peut en creer un. Afin d'éviter toutes triches, le QR code ne contiendra pas les infromation à afficher mais des informations qui rendront unique l'adhérent et qui permettront de le trouver dans la base de donnée
 Le QR code contiendra donc : Le nom et prénom, la date de naissance [avec ces 2 infos, les adhérents ont des QR code uniques], ainsi qu'une clé de controlle calculée par le programme.
 Elle contiendra le jour,mois,année de naissance ainsi qu'en dernier chiffre, le reste dans la disivion euclidienne du nombre par 14. Cette méthode permet de garantir une sécurité supplementaire qui rends plus difficile le duplicat de QR code et permet une verifiaction immédiate des données
 Exemple : String du QR code = NathanStchepinsky#14/11/2002#14112002#2 car le reste est 2. Les # permmeteront de separer les 3 elements: nomPrénom, la date de naissance et le code de sécruité, afin qu'ils soient analysés séparemment*/
class generateQRcode {
    //func trouvée on https://www.hackingwithswift.com/example-code/media/how-to-create-a-qr-code
    
    //ATTENTION : LE TEXTE EST CONVERTIE EN HEXA DECIMAL CAR NE GÈRE PAS LES CARACTÈRES SPÉCIAUX 
        func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            } else {
                print("condition line 26 shut up")
            }
        } else {
            print("condition line 22 shut up")
        }
        
        return nil
    }
    
    /**
    Cette fonction permet de générer le text qui sera transmis dans le QrCode. Il devra être conforme à la sécurité expliqué ci-dessus
    - Parameter nom : Correspond au nom de l'adhérent
    - Parameter dateNaissance : Correspond à la date de naissance de l'adhérente, sous la forme DD/MM/YYYY
    */
    public func generateStringQRCode(nom: String, dateNaissance : String) -> String {
        var stringFinale = nom + "#"
        
        //On transforme la Date() en String :
        stringFinale.append(dateNaissance + "#") //Mtn que la date est fromatté on peut l'associé à un String
        
        stringFinale.append(String(securityKey(withDate: dateNaissance)))
        return stringFinale
    }
    
    func securityKey(withDate dateNaissance: String)-> Int { // calcul la clé de sécurité
        
        let dateFormatteur = DateFormatter()
        dateFormatteur.dateFormat = "dd/MM/yyyy"
        
        //On calcule la clé de sécurité :
        if let date = dateFormatteur.date(from: dateNaissance) {
            let day = Calendar.current.component(.day, from: date) // on formate notre date de naissance.
            let month = Calendar.current.component(.month, from: date)
            let year = Calendar.current.component(.year, from: date)
            let nbr = day  + month  + year  // On calcule la somme voulue
            return nbr % 10 // on regarde le reste dans le division euclidienne du nombre par 14.
        } else {
            return -1
        }
        
        
    }

}
