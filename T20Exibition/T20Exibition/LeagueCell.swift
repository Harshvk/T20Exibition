//
//  LeagueCell.swift
//  T20Exibition
//
//  Created by appinventiv on 16/02/17.
//  Copyright © 2017 appinventiv. All rights reserved.
//

import UIKit

class LeagueCell: UITableViewCell {

    @IBOutlet weak var leagueNameLabel: UILabel!
    
    @IBOutlet weak var leagueTeamCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

