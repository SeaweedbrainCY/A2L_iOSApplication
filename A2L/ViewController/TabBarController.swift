//
//  UIView.swift
//  A2L
//
//  Created by Nathan on 08/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController, UITabBarControllerDelegate {
    
    let tabBarCnt = UITabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let maFiche = MaFiche()
        if viewController.title == "Ma fiche"{
            maFiche.loadView()
        }
        return true;
    }

    
    
}
