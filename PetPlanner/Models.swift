//
//  Models.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import Foundation

// Simple in-memory model for a pet
struct Pet {
    let name: String
    let imageName: String
}

// Simple in-memory model for a vet clinic
struct VetClinic {
    let name: String
    let distance: String
    let rating: String
    let reviews: Int
    let description: String 
}
