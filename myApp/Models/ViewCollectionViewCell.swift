//
//  ViewCollectionViewCell.swift
//  SwitchMenu
//
//  Created by Gleb on 17.01.2021.
//  Copyright © 2021 Gleb. All rights reserved.
//

import UIKit

class ViewCollectionViewCell: UICollectionViewCell {
    
    
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var descript: UILabel!
//    @IBOutlet weak var price: UILabel!
//    @IBOutlet weak var checkmark: UIImageView!
//    @IBOutlet weak var icon: UIImageView!
//    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var stack: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
