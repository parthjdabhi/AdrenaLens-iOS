//
//  MyPhotoCollectionViewCell.swift
//  AdrenaLens
//
//  Created by iParth on 8/29/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

class MyPhotoCollectionViewCell: UICollectionViewCell {

    static let identifier = "MyPhotoCollectionViewCell"
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var lblCaption: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
//    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.ini (nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        // Custom initialization
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
