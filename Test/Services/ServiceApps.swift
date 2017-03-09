//
//  ServiceApps.swift
//  Test
//
//  Created by Jorge on 7/03/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class ServiceApps: NSObject {
    static let sharedInstance:ServiceApps = ServiceApps()

    func loadApps(_ success: @escaping (_ lisOfApps: [App]) -> Void, failure:(_ error: NSError) -> Void)  {
        ApiRedditClient.sharedInstance.appsRequest(Constants.URL_APPI_REDDIT, success: { (lisOfApps) in
                success(lisOfApps)
        }) { (error) in
            
        }
    }
    
    func loadCategories(_ success: @escaping (_ lisOfCategories: [String]) -> Void, failure:(_ error: NSError) -> Void)  {
        ApiRedditClient.sharedInstance.getCategories(success: { (lisOfCategories) in
            success(lisOfCategories)
        }) { (error) in
            
        }
    }
    
    func loadAppsFromCategories(_ category: String, _ success: @escaping (_ lisOfApps: [App]) -> Void, failure:(_ error: NSError) -> Void)  {
        ApiRedditClient.sharedInstance.getAppsFromCategory(category, success: { (lisOfApps: [App]) in
            success(lisOfApps)
        }) { (NSError) in
            
        }
    }
}
