//
//  UIView.swift
//  A2L
//
//  Created by Nathan on 08/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

// Cette classe ne correspond à aucun viewController mais au controller INITIAl. Il permet de gerer les icon des itemTabBar et leur nom. Il permet aussi de detecter lorsqu'un item est cliqué

class TabBarController : UITabBarController, UITabBarControllerDelegate {
    
    let tabBarCnt = UITabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) { // inutile pour l'instant
        super.viewWillAppear(animated)
        let maFiche = MaFiche()
        maFiche.title = "Ma fiche"
        maFiche.tabBarItem.image = UIImage.init(named: "MaFiche")
        
        let qrCode = QRCode()
        //let navigationController2 = UINavigationController(rootViewController: qrCode)
        qrCode.title = "Mon QR code"
        qrCode.tabBarItem.image = UIImage.init(named: "qrCode")
        
        //viewControllers = [navigationController, qrCode]
        
        //self.view.addSubview(tabBarCnt.view)
    }
    
    //lorsque l'on tape sur un item, on load la vue choisie -> Cela sert surtout dans le mode testeur. Lorsque l'on modifie notre statut de testeur, il faut qu'on re-vérifie nos privilège pour savoir si on peut afficher les button (scanner/liste)
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "Ma fiche"{
            let maFiche = MaFiche()
            maFiche.loadView()
        } else if viewController.title == "QR code" {
            let QRcode = QRCode()
            QRcode.loadView()
        }
        return true;
    }

    
    
}
