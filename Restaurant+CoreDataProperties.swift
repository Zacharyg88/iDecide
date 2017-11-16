//
//  Restaurant+CoreDataProperties.swift
//  iDecide
//
//  Created by Zach Eidenberger on 11/4/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant");
    }

    @NSManaged public var iD: Int16
    @NSManaged public var lat: Float
    @NSManaged public var lon: Float
    @NSManaged public var menuURL: String?
    @NSManaged public var name: String?
    @NSManaged public var photoURL: String?
    @NSManaged public var priceRange: Int16
    @NSManaged public var rating: String?
    @NSManaged public var url: String?

}
