//
//  ZomatoClient.swift
//  iDecide
//
//  Created by Zach Eidenberger on 10/30/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import Foundation

class ZomatoClient: NSObject {
    
    func getResturantsFromZomato(completeionHandlerForGetResturantsFromZomato: @escaping (_ results: [String: AnyObject], _ errorString: String)-> Void) {
        var zomatoURL = String()
        if ZomatoConstants.parametersBool == true {
        zomatoURL = "https://developers.zomato.com/api/v2.1/search?\(ZomatoParameterKeys.keywordStringKey)=\(ZomatoParameterValues.keywordStringValue)&\(ZomatoParameterKeys.latKey)=\(ZomatoParameterValues.latValue)&\(ZomatoParameterKeys.lonKey)=\(ZomatoParameterValues.lonValue)&\(ZomatoParameterKeys.radiusKey)=\(ZomatoParameterValues.radiusValue)&\(ZomatoParameterKeys.sortKey)=\(ZomatoParameterValues.sortValue)&order=desc"
        
        }else {
            zomatoURL = "https://developers.zomato.com/api/v2.1/search?lat=\(ZomatoParameterValues.latValue)&lon=\(ZomatoParameterValues.lonValue)&radius=12875"
        }
        print(zomatoURL)
        
        var request = URLRequest(url: URL(string: zomatoURL)!)
        request.addValue(ZomatoParameterValues.apiValue, forHTTPHeaderField: "user-key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        var parsedData = [String: AnyObject]()
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completeionHandlerForGetResturantsFromZomato(("" as AnyObject) as! [String : AnyObject], "\(error)")
            }else {
                do {
                    parsedData = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                    print(parsedData)
                }
            }
            completeionHandlerForGetResturantsFromZomato((parsedData as AnyObject) as! [String : AnyObject], "")
        }
        task.resume()
    }
    
    
    
    
    class func sharedInstance() -> ZomatoClient {
        struct Singleton {
            static var sharedInstance = ZomatoClient()
        }
        return Singleton.sharedInstance
    }
}
