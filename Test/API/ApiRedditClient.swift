//
//  ApiRedditClient.swift
//  Test
//
//  Created by Jorge on 7/03/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ReachabilitySwift

class ApiRedditClient: NSObject {
    static let sharedInstance:ApiRedditClient = ApiRedditClient()
    var listOfAppsCategory : Dictionary<String, Any>!
    var listOfApps : Array<App>!

    func appsRequest(_ url: String, success: @escaping (_ lisOfApps: [App]) -> Void, failure:@escaping (_ error: NSError) -> Void)  {
        let reachability = Reachability()!

        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).validate()
                .responseJSON { response in
                    
                    switch response.result {
                    case .success:
                        if let value: AnyObject = response.result.value as AnyObject? {
                            self.saveCache(json: value)
                            success(self.processData(value: value))
                        }
                        
                    case .failure( _):
                        if let value: AnyObject = self.loadCache() {
                            success(self.processData(value: value))
                            let userInfo = [NSLocalizedDescriptionKey: "conexión offline"]
                            failure(NSError(domain: "", code: 1, userInfo: userInfo))
                        }
                        break
                    }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            if let value: AnyObject = self.loadCache() {
                success(self.processData(value: value))
                let userInfo = [NSLocalizedDescriptionKey: "conexión offline"]
                failure(NSError(domain: "", code: 1, userInfo: userInfo))
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func getCategories(success: @escaping (_ lisOfCategories: [String]) -> Void, failure:(_ error: NSError) -> Void)  {
      success(Array(self.listOfAppsCategory.keys))
    }

    func getAppsFromCategory(_ category: String, success: @escaping (_ lisOfApps: [App]) -> Void, failure:(_ error: NSError) -> Void)  {
        if category == "all" {
            success(self.listOfApps)
        } else {
            success(self.listOfAppsCategory[category] as! [App])
        }
    }
    
    func processData(value: AnyObject) -> [App] {
        let json = JSON(value)
        var listOfApps = [App]()
        
        if let childrens = json["data"]["children"].array {
            for children in childrens {
                let app = App()
                app.name = children["data"]["title"].rawString()!
                app.urlImage = children["data"]["icon_img"].rawString()!
                app.descriptionApp = children["data"]["submit_text"].rawString()!
                
                let appCategory = AppCategory()
                if let categoryName = children["data"]["advertiser_category"].string {
                    appCategory.categoryName = categoryName
                } else {
                    appCategory.categoryName = "uncategorized"
                }
                
                app.category = appCategory
                
                listOfApps.append(app)
            }
        }
        
        self.listOfApps = listOfApps
        self.listOfAppsCategory = listOfApps.categorise { ($0.category.categoryName)}
        
        return listOfApps
    }
    
    // MARK: cache
    func saveCache(json: AnyObject) {
        let documentsDirectory =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let  writePath = documentsDirectory.appendingPathComponent("assets.json")
        let data: NSData = NSKeyedArchiver.archivedData(withRootObject: json) as NSData
        data.write(toFile: writePath.path, atomically: true)
    }
    
    func loadCache() -> AnyObject! {
        let documentsDirectory =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let  filePathURL = documentsDirectory.appendingPathComponent("assets.json")
        if FileManager.default.fileExists(atPath: filePathURL.path) {
            let data: NSData = NSData(contentsOfFile: filePathURL.path)!
            
            if let jsonObject: Dictionary = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Dictionary<String, AnyObject> {
                return jsonObject as AnyObject!
            }
        }
        
        return nil
    }
}


