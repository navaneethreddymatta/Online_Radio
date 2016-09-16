//
//  ProgramsTableViewCell.swift
//  HW02
//
//  Created by student on 7/24/16.
//  Copyright © 2016 mnr_iOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProgramsTableViewCell: UITableViewCell {
    
    var story:JSON? {
        didSet {
            updateUI()
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
    @IBOutlet weak var programTitleField: UILabel!

    @IBOutlet weak var programDescriptionField: UILabel!
    
    private func updateUI() {
        programTitleField.text = String((story?["title"]["$text"])!)
        programDescriptionField.text = String((story?["additionalInfo"]["$text"])!)
    }
}
