//
//  QRCode.swift
//  A2L
//
//  Created by Nathan on 08/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

class QRCode: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.image = UIImage.init(named: "qrCode")
        self.tabBarItem.title = "QR code"
    }
}
