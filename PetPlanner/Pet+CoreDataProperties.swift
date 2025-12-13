//
//  Pet+CoreDataProperties.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-12.
//
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet")
    }

    @NSManaged public var name: String?
    @NSManaged public var breed: String?
    @NSManaged public var dob: Date?
    @NSManaged public var imageName: String?
    @NSManaged public var weight: Double
    @NSManaged public var appointments: NSSet?

}

// MARK: Generated accessors for appointments
extension Pet {

    @objc(addAppointmentsObject:)
    @NSManaged public func addToAppointments(_ value: Appointment)

    @objc(removeAppointmentsObject:)
    @NSManaged public func removeFromAppointments(_ value: Appointment)

    @objc(addAppointments:)
    @NSManaged public func addToAppointments(_ values: NSSet)

    @objc(removeAppointments:)
    @NSManaged public func removeFromAppointments(_ values: NSSet)

}

extension Pet : Identifiable {

}
