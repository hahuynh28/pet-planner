//
//  EventCell.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-06.
//

import UIKit

class EventCell: UITableViewCell {

    // OUTLETS: Connect these to your Storyboard items!
    @IBOutlet weak var containerView: UIView!      // The White Card View
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var badgeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1. Style the Card Container
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .white
        
        // Use the shadow extension you added to DashboardViewController
        // (Copy that extension to a separate file if this errors, or just paste it at bottom)
        containerView.applyShadow(opacity: 0.1, y: 0.5, blur: 2)
        
        // 2. Style the Pet Image
        petImageView.makeRound(radius: petImageView.frame.height / 2)
        
        // 3. Style the Badge (Optional rounded corners)
//        badgeLabel.layer.cornerRadius = 4
//        badgeLabel.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        petImageView.layer.cornerRadius = petImageView.bounds.width / 2.0
        petImageView.clipsToBounds = true
    }
    
    // Helper to fill data
    func configure(with appointment: Appointment) {
        // 1. Map "Title" to the Reason/Notes (e.g., "Vaccination")
        titleLabel.text = appointment.notes ?? "Appointment"
        
        // 2. Map Pet Name (Use relationship first, then fallback)
        let name = appointment.pet?.name ?? appointment.petName ?? "Unknown Pet"
        petNameLabel.text = name
        
        // 3. Map Date (Combine Date & Time)
        let date = appointment.dateText ?? ""
        let time = appointment.timeText ?? ""
        dateLabel.text = "\(date) • \(time)"
        
        // 4. Load Image (Reusing logic from Dashboard)
        // Reset first to avoid recycling ghosts
        petImageView.image = UIImage(systemName: "pawprint.circle.fill")
        petImageView.tintColor = UIColor(named: "BrandPurple")
        petImageView.backgroundColor = .systemGray6
        
        if let pet = appointment.pet, let imgName = pet.imageName {
            if let assetImage = UIImage(named: imgName) {
                petImageView.image = assetImage
            } else {
                let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imgName)
                if let diskImage = UIImage(contentsOfFile: filename.path) {
                    petImageView.image = diskImage
                    petImageView.contentMode = .scaleAspectFill
                }
            }
        }
    }
}
