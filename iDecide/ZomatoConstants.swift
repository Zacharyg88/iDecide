//
//  ZomatoConstants.swift
//  iDecide
//
//  Created by Zach Eidenberger on 10/30/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

extension ZomatoClient {
    
    
    struct  ZomatoConstants {
        
        static var userDistance = Int()
        static var user21 = Bool()
        static var userBudgetvsRating = String()
        static var userSearchKeyword = String()
        static var userBudget = Int()
        static var returnedRestaurants = [[String: AnyObject]]()
        static var parametersBool = Bool()
    }
    
    struct ZomatoParameterKeys {
        static var apiKey = ""
        static var keywordStringKey = "q"
        static var latKey = "lat"
        static var lonKey = "lon"
        static var radiusKey = "radius"
        static var orderKey = "order"
        static var sortKey = "sort"
    }
    
    struct ZomatoParameterValues {
        static var apiValue = "fd64e4ade5d0b6cbd7c37bcf7413d830"
        static var keywordStringValue = ""
        static var latValue = Double()
        static var lonValue = Double()
        static var radiusValue = Double()
        static var orderValue = "desc"
        static var sortValue = ""
        
    }
}
