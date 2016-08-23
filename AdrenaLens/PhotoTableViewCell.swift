//
//  PhotoTableViewCell.swift
//  AdrenaLens
//
//  Created by iParth on 8/23/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    static let identifier = "PhotoTableViewCell"
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
