//
//  StudentTableViewCell.swift
//  iD Students
//
//  Created by Voltage on 6/10/15.
//  Copyright © 2015 Gabriel Revells. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

	@IBOutlet weak var alertImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
