//
//  EventCell.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-06.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var badgeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 12
        containerView.backgroundColor = .white
        
        containerView.applyShadow(opacity: 0.1, y: 0.5, blur: 2)
        
        petImageView.makeRound(radius: petImageView.frame.height / 2)
        
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
        titleLabel.text = appointment.notes ?? "Appointment"
        
        let name = appointment.pet?.name ?? appointment.petName ?? "Unknown Pet"
        petNameLabel.text = name
        
        let date = appointment.dateText ?? ""
        let time = appointment.timeText ?? ""
        dateLabel.text = "\(date) • \(time)"
        
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
