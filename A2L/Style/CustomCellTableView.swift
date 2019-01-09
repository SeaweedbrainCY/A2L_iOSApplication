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

class CustomTableViewCell: UITableViewCell {
    
    let statut = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        statut.textColor = .gray
        statut.textAlignment = .right
        statut.frame = CGRect(x: 170, y: 9, width: 200, height: 30)
        contentView.addSubview(statut)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
