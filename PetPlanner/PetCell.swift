//
//  PetCell.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit

class PetCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Make image circular based on its frame size
        petImageView.makeRound(radius: petImageView.frame.height / 2)
//        petImageView.layer.borderColor = UIColor(named: "BrandPurple")?.cgColor
//        petImageView.layer.borderWidth = 1.0
        
        // Add border for separation, if needed
        // petImageView.layer.borderColor = UIColor.lightGray.cgColor
        // petImageView.layer.borderWidth = 0.5
    }
}

