//
//  Restaurant+CoreDataClass.swift
//  iDecide
//
//  Created by Zach Eidenberger on 11/4/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import Foundation
import CoreData


public class Restaurant: NSManagedObject {
    convenience init(id: Int16, lat: Float, lon: Float, menuURL: String, name: String, photoURL: String, priceRange: UInt16, rating: String, url: String, context: NSManagedObjectContext){
        if let ent = NSEntityDescription.entity(forEntityName: "Restaurant", in: context){
            self.init(entity: ent, insertInto: context)
            self.iD = id
            self.lat = lat
            self.lon = lon
            self.menuURL = menuURL
            self.name = name
            self.photoURL = photoURL
            self.priceRange = Int16(priceRange)
            self.rating = rating
            self.url = url
        }else {
            self.init()
        }
        
    }
    
}
