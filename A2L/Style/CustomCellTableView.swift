//
//  CustomCellTableView.swift
//  A2L
//
//  Created by Nathan on 09/01/2019.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation
import UIKit

//Custom qui permet d'ajouter un label au cellule des tableView

#warning("Afin de s'adpater à tous les appareils, il faudra récuprer les coordonnées des cellules et adapter la positon en fonction")

class CustomTableViewCell: UITableViewCell {
    
    let statut = UILabel()
    let info = UIButton()
    let iconCell = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        statut.textColor = .gray
        statut.textAlignment = .right
        statut.frame = CGRect(x: 170, y: 9, width: 200, height: 30)
        contentView.addSubview(statut)
        
        info.tintColor = .blue
        info.frame = CGRect(x: 340, y: 6, width: 30, height: 30)
        contentView.addSubview(info)
        
        iconCell.frame = CGRect(x: 5, y: 6, width : 30, height: 30)
        contentView.addSubview(iconCell)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
