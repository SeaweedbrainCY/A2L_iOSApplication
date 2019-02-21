//
//  NoClassVariable.swift
//  A2L
//
//  Created by Nathan on 01/02/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit
//ATTENTION : Cette fichier ne sert qu'a stocker en un seul fichier les variables qui sont sorties des class. Elles sont donc utilisable directement dans toute l'application. Est-ce utilisable sur le long terme ? Est-ce optimisé ? est ce qu'on a la droit ? 

var serveurReponse = "nil" // reponse de notre chère serveur : erreur
var infosAdherent = ["nil": "nil"] //Infos de bases de l'adhérents qui servent dans l'immédiat
let stockInfosAdherent = "stockInfosAdherent.text"
let nbrInvalidateMdpPath = "nbrInvalidateMdp.text" // Nombre de fois qu'un mot de passe a été refusé = lutte contre la brut force
var reponseURLRequestImage = "nil" // Reponse du serveur lorsqu'on load l'image
var infosOtherAdherent = ["nil":"nil"] // toutes les infos d'un autre adhérent à afficher
var infosAllAdherent = [["nil":"nil"]]
var imageId: UIImage?
