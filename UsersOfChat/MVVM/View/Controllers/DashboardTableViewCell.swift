//
//  DashboardTableViewCell.swift
//  UsersOfChat
//
//  Created by Varshitha VRaj on 01/08/25.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
