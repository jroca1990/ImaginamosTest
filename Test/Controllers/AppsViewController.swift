//
//  AppViewController.swift
//  Test
//
//  Created by Jorge on 7/03/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import AlamofireImage
import SwiftSpinner
import DeviceKit

class AppsViewController: UIViewController, CategoriesDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noConection: UILabel!

    var listOfApps = [App]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }

    @IBAction func loadData(){
        self.noConection.isHidden = true;
         SwiftSpinner.show("Loading data...")
        ServiceApps.sharedInstance.loadApps({ (lisOfApps) in
            DispatchQueue.main.async {
                self.listOfApps = lisOfApps
                let device = Device()

                if device.isPhone{
                    self.tableView.reloadData()
                } else {
                    self.collectionView.reloadData()
                }
                
                SwiftSpinner.hide()
            }
        }) { (error) in
            DispatchQueue.main.async {
                self.noConection.isHidden = false;
                SwiftSpinner.hide()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail"{
            let detailViewController = segue.destination as! DetailAppViewController
            let device = Device()
            if device.isPhone{
                let indexPath = self.tableView.indexPathForSelectedRow
                let app = self.listOfApps[(indexPath?.row)!]
                detailViewController.app = app
            } else {
                let indexPath = self.collectionView.indexPathsForSelectedItems?[0]
                let app = self.listOfApps[(indexPath?.row)!]
                detailViewController.app = app
            }
            
            
        }
        
        if segue.identifier == "segueCategories"{
            let navController = segue.destination as! UINavigationController
            let categoriesViewController = navController.topViewController as! CategoriesViewController
            categoriesViewController.delegate = self
        }
    }

    // MARK: CategoriesDelegate
    
    func categorySelected(category :AppCategory) {
        ServiceApps.sharedInstance.loadAppsFromCategories(category.categoryName, { (listOfApps: [App]) in
            self.listOfApps = listOfApps
            let device = Device()
            if device.isPhone{
                self.tableView.reloadData()
            } else {
                self.collectionView.reloadData()
            }
        }) { (NSError) in
            
        }
    }
    
    // MARK: UICollection
}

extension AppsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfApps.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath as IndexPath) as! AppTableViewCell
        cell.appImage.image = nil;
        let app = self.listOfApps[indexPath.row]
        cell.appName.text = app.name
        cell.appCategory.text = app.category.categoryName
        cell.appCounter.text = "\(indexPath.row + 1)"
        
        if app.urlImage != "" {
            cell.appImage.af_setImage(withURL: URL(string: app.urlImage)!, placeholderImage: UIImage(named: "defaulIconApp"))
        }
        
        return cell
    }
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
