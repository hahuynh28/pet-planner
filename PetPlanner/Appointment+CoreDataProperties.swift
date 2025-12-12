//
//  Appointment+CoreDataProperties.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-12.
//
//

import Foundation
import CoreData


extension Appointment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointment> {
        return NSFetchRequest<Appointment>(entityName: "Appointment")
    }

    @NSManaged public var clinicName: String?
    @NSManaged public var dateText: String?
    @NSManaged public var notes: String?
    @NSManaged public var petName: String?
    @NSManaged public var timeText: String?
    @NSManaged public var titleText: String?
    @NSManaged public var pet: Pet?

}

extension Appointment : Identifiable {

}
