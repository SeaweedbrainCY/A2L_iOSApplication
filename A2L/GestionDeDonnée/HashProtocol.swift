//
//  HashProtocol.swift
//  A2L
//
//  Created by Nathan on 21/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

//Le but est ici de hasher les mot de passes en SHA 256

class HashProtocol {
    
    //On hash en SHA256 qui est le hachage le plus sur de nos jours
    func SHA256(text: String) -> String {
        let data = text.data(using: .utf8)
        var digest = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digest.withUnsafeMutableBytes { (digestBytes) in
            data!.withUnsafeBytes { (stringBytes) in
                CC_SHA256(stringBytes, CC_LONG(data!.count), digestBytes)
            }
        }
        return digest.map { String(format: "%02hhx", $0) }.joined() // On return bien une String
    }
}
