//
//  QRCodeData.swift
//  A2L
//
//  Created by Nathan on 13/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

/*NOTE IMPORTANTE : Le QR Code est accessible à tout le monde, et tout le monde peut en creer un. Afin d'éviter toutes triches, le QR code ne contiendra pas les infromation à afficher mais des informations qui rendront unique l'adhérent et qui permettront de le trouver dans la base de donnée
 Le QR code contiendra donc : Le nom et prénom, la date de naissance [avec ces 2 infos, les adhérents ont des QR code uniques], ainsi qu'une clé de controlle calculée par le programme.
La clé sera le reste dans la disivion euclidienne de la somme du jour, du mois et de l'année de naissance par 10. Cette méthode permet de garantir une sécurité supplementaire qui rends plus difficile le duplicat de QR code et permet une verifiaction immédiate des données
 Exemple : String du QR code = NathanStchepinsky#14/11/2002#7 car le reste est 7. Les # permmeteront de separer les 3 elements: nomPrénom, la date de naissance et le code de sécruité, afin qu'ils soient analysés séparemment*/

class QRCodeData { // cette classe s'occupe de toutes les données qui touchent les QRCode
    
    
    /**
     Cette fonction permet de générer le text qui sera transmis dans le QrCode. Il devra être conforme à la sécurité expliqué ci-dessus
     - Parameter nom : Correspond au nom de l'adhérent
     - Parameter dateNaissance : Correspond à la date de naissance de l'adhérente, sous la forme DD/MM/YYYY
     */
    public func generateStringQRCode(nom: String, dateNaissance : Date) -> String {
        var stringFinale = nom + "#"
        
        //On transforme la Date() en String :
        let dateFormatteur = DateFormatter()
        dateFormatteur.dateFormat = "dd/MM/yyyy"
        stringFinale.append(dateFormatteur.string(from: dateNaissance) + "#") //Mtn que la date est fromatté on peut l'associé à un String
        
        //On calcule la clé de sécurité :
        let day = Calendar.current.component(.day, from: dateNaissance) // on formate notre date de naissance.
        let month = Calendar.current.component(.month, from: dateNaissance)
        let year = Calendar.current.component(.year, from: dateNaissance)
        let nbr = day  + month  + year  // On calcule la somme voulue
        let clé = nbr % 10 // on regarde le reste dans le division euclidienne du nombre par 14.
        stringFinale.append(String(clé))
        return stringFinale
    }
    
}
