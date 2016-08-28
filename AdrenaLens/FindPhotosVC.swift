//
//  FindPhotosVC.swift
//  AdrenaLens
//
//  Created by iParth on 8/23/16.
//  Copyright © 2016 Harloch. All rights reserved.
//

import UIKit

class FindPhotosVC: UIViewController {
    
    //@IBOutlet weak var txtImages: UITextField!
    @IBOutlet weak var txtSport: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtSport.setBorder(nil, color: nil)
        txtLocation.setBorder(nil, color: nil)
        txtDate.setBorder(nil, color: nil)
        btnSearch.setBorder(nil, color: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func actionSearchPhotos(sender: UIButton) {
    }
    @IBAction func actionCantFindLocation(sender: UIButton) {
    }
}
