//
//  ZomatoConvenience.swift
//  iDecide
//
//  Created by Zach Eidenberger on 10/30/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

extension ZomatoClient {
    
    func getResturantsFromParameters(convenienceMethodForGetResturantsFromParameters: @escaping(_ success: Bool, _ errorString: String)-> Void) {
        
        ZomatoClient.sharedInstance().getResturantsFromZomato(completeionHandlerForGetResturantsFromZomato:{ (results, error) in
            if error != "" {
                convenienceMethodForGetResturantsFromParameters(false, "\(error)")
            }else {
                let restaurants = results["restaurants"] as! [[String: AnyObject]]
                if ZomatoConstants.parametersBool == true {
                    for result in restaurants {
                        let restaurant = result["restaurant"] as! [String: AnyObject]
                        let priceRange = restaurant["price_range"] as! Int
                        if priceRange <= ZomatoConstants.userBudget {
                            ZomatoConstants.returnedRestaurants.append(restaurant)
                        }
                    }
                }else {
                    for result in restaurants {
                        let restaurant = result["restaurant"] as! [String: AnyObject]
                        ZomatoConstants.returnedRestaurants.append(restaurant)
                    }
                }
                convenienceMethodForGetResturantsFromParameters(true, "")
            }
        })
    }
    
}
