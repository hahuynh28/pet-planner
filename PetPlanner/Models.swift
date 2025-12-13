//
//  Models.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import Foundation
import CoreLocation

//struct Pet {
//    let name: String
//    let imageName: String
//}

struct Review {
    let author: String
    let rating: Int
    let text: String
}

struct VetClinic {
    let name: String
    let services: String
//    let distance: String
    let rating: String
//    let reviews: Int
    let reviewsCount: Int
    let address: String
    let phone: String
    let website: String
    let imageName: String
    
    let lat: Double
    let long: Double
    
    let reviewsList: [Review]
    
    // Helper to get location
    var location: CLLocation {
        return CLLocation(latitude: lat, longitude: long)
    }
    
    static let sharedClinics: [VetClinic] = [
        VetClinic(
            name: "Brampton Veterinary Clinic",
            services: "Routine • Surgery • Dentistry",
            rating: "★ 4.8",
            reviewsCount: 215,
            address: "123 Main Street, Brampton, ON",
            phone: "(905) 123-4567",
            website: "bramptonvet.com",
            imageName: "milo-avatar",
            lat: 43.731547,
            long: -79.762417,
            reviewsList: [
                Review(author: "Sarah J.", rating: 5, text: "Amazing staff! They treated Milo with so much care."),
                Review(author: "Mike T.", rating: 4, text: "Great service, but the waiting room was a bit crowded.")
            ]
        ),
        
        VetClinic(
            name: "Heartwood Animal Hospital",
            services: "Emergency • Imaging • Vaccinations",
            rating: "★ 4.5",
            reviewsCount: 88,
            address: "456 Queen St, Brampton",
            phone: "(905) 555-2222",
            website: "heartwoodvet.com",
            imageName: "milo-avatar",
            lat: 43.688947,
            long: -79.759120,
            reviewsList: [
                Review(author: "Emily R.", rating: 5, text: "Saved my cat's life during an emergency. Forever grateful!"),
                Review(author: "David K.", rating: 5, text: "Very professional and clean facility.")
            ]
        ),
        
        VetClinic(
            name: "The Cat Clinic of Brampton",
            services: "Feline Focus • Wellness Exams",
            rating: "★ 4.9",
            reviewsCount: 23,
            address: "789 King St, Brampton",
            phone: "(905) 999-8888",
            website: "catclinic.com",
            imageName: "milo-avatar",
            lat: 43.684444,
            long: -79.754999,
            reviewsList: [
                Review(author: "Jessica W.", rating: 5, text: "Finally a place that understands cats! Whiskers was so calm."),
                Review(author: "Tom H.", rating: 4, text: "A bit pricey, but the expertise is worth it.")
            ]
        )
    ]
}
