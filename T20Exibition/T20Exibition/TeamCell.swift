//
//  TeamCell.swift
//  T20Exibition
//
//  Created by appinventiv on 16/02/17.
//  Copyright © 2017 appinventiv. All rights reserved.
//

import UIKit

class TeamCell: UICollectionViewCell {

    @IBOutlet weak var addToFavouriteButtonOutlet: UIButton!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamPic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

}
