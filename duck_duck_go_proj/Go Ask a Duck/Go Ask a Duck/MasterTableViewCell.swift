//
//  MasterTableViewCell.swift
//  Go Ask a Duck
//
//  Created by Samantha Rey on 8/12/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var descriptiveText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
