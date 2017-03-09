//
//  AppViewController.swift
//  Test
//
//  Created by Jorge on 7/03/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import AlamofireImage

class AppsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CategoriesDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var listOfApps = [App]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceApps.sharedInstance.loadApps({ (lisOfApps) in
            self.listOfApps = lisOfApps
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }) { (error) in
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueCategories"{
            let navController = segue.destination as! UINavigationController
            let categoriesViewController = navController.topViewController as! CategoriesViewController
            categoriesViewController.delegate = self
        }
    }

    // MARK: TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfApps.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath as IndexPath) as! AppTableViewCell
        
        let app = self.listOfApps[indexPath.row]
        cell.appName.text = app.name
        cell.appCategory.text = app.category.categoryName
        cell.appCounter.text = "\(indexPath.row + 1)"
        
        if app.urlImage != "" {
            cell.appImage.af_setImage(withURL: URL(string: app.urlImage)!, placeholderImage: UIImage(named: "defaulIconApp"))
        }
        
        return cell
    }
    
    // MARK: CategoriesDelegate
    
    func categorySelected(category :AppCategory) {
        ServiceApps.sharedInstance.loadAppsFromCategories(category.categoryName, { (listOfApps: [App]) in
            self.listOfApps = listOfApps
            self.tableView.reloadData()
            self.collectionView.reloadData()
        }) { (NSError) in
            
        }
    }
    
    // MARK: UICollection
}

extension AppsViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfApps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->   UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCollectionCell", for: indexPath as IndexPath) as! AppCollectionViewCell

        let app = self.listOfApps[indexPath.row]
        cell.appName.text = app.name
        cell.appCategory.text = app.category.categoryName
        
        if app.urlImage != "" {
            cell.appImage.af_setImage(withURL: URL(string: app.urlImage)!, placeholderImage: UIImage(named: "defaulIconApp"))
        }
        
        return cell
    }
}
