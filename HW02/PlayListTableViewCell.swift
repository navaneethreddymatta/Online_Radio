//
//  PlayListTableViewCell.swift
//  HW02
//
//  Created by student on 7/24/16.
//  Copyright © 2016 mnr_iOS. All rights reserved.
//

import UIKit

class PlayListTableViewCell: UITableViewCell {
    var track:Track? {
        didSet {
            updateCellUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellUI() {
    
    }

}
