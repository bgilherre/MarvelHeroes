//
//  Heroe+CoreDataProperties.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 27/11/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//
//

import Foundation
import CoreData


extension Heroe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Heroe> {
        return NSFetchRequest<Heroe>(entityName: "Heroe")
    }

    @NSManaged public var nombre: String?
    @NSManaged public var descripcion: String?
    @NSManaged public var imagen: NSData?

}
