//
//  DetailAppViewController.swift
//  Test
//
//  Created by Jorge on 9/03/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailAppViewController: UIViewController {
    var app : App!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var appCategory: UILabel!
    @IBOutlet weak var appDescription: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appName.adjustsFontSizeToFitWidth = true
        self.appName.text = self.app.name
        self.appCategory.text = self.app.category.categoryName
        self.appDescription.text = self.app.descriptionApp

        if self.app.urlImage != "" {
            self.appImage.af_setImage(withURL: URL(string: app.urlImage)!, placeholderImage: UIImage(named: "defaulIconApp"))
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
