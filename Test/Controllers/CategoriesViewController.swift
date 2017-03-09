//
//  CategoriesViewController.swift
//  Test
//
//  Created by Jorge on 7/03/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

protocol CategoriesDelegate {
    func categorySelected(category :AppCategory)
}

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var lisOfCategories = [String]()
    var delegate : CategoriesDelegate?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceApps.sharedInstance.loadCategories({ (listOfCategories: [String]) in
            self.lisOfCategories = listOfCategories
            self.tableView.reloadData()
        }) { (NSError) in
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lisOfCategories.count + 1
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath as IndexPath) as! CategoryTableViewCell
        
        if indexPath.row == 0 {
            cell.categoryName.text = "All Categories"
        } else {
            let category = self.lisOfCategories[indexPath.row - 1]
            cell.categoryName.text = category
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = AppCategory()

        if indexPath.row == 0 {
            category.categoryName =  "all"
        } else {
            let categoryName = self.lisOfCategories[indexPath.row - 1]
            category.categoryName =  categoryName
        }

        self.delegate?.categorySelected(category: category)
        self.back()
    }
}
