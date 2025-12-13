//
//  AppointmentCell.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-11.
//

import UIKit

class AppointmentCell: UITableViewCell {

    // Outlets for our card elements
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
    }

    func setupCardStyle() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
        
        cardView.layer.cornerRadius = 12
        cardView.backgroundColor = .white
        cardView.applyShadow(color: .black, opacity: 0.1, x: 0, y: 2, blur: 6)
        
        petImageView.layer.cornerRadius = 30
        petImageView.clipsToBounds = true
        petImageView.contentMode = .scaleAspectFill
    }

    func configure(with appointment: Appointment) {
        let name = appointment.petName ?? "Unknown Pet"
        petNameLabel.text = name
        
        petImageView.image = nil
        petImageView.tintColor = UIColor(named: "BrandPurple")
        petImageView.backgroundColor = .systemGray6
        petImageView.contentMode = .scaleAspectFill
        
        if let pet = appointment.pet, let imgName = pet.imageName {
            if let assetImage = UIImage(named: imgName) {
                petImageView.image = assetImage
                petImageView.backgroundColor = .clear
            }
            else {
                let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imgName)
                if let diskImage = UIImage(contentsOfFile: filename.path) {
                    petImageView.image = diskImage
                    petImageView.backgroundColor = .clear
                } else {
                    setFallbackImage()
                }
            }
        } else {
            setFallbackImage()
        }
        
        let date = appointment.dateText ?? ""
        let time = appointment.timeText ?? ""
        dateTimeLabel.text = (!date.isEmpty && !time.isEmpty) ? "\(date) at \(time)" : date + time
        
        clinicLabel.text = appointment.clinicName ?? "No Clinic"
        notesLabel.text = appointment.notes ?? "No notes"
    }
    
    func setFallbackImage() {
        petImageView.image = UIImage(systemName: "pawprint.circle.fill")
        petImageView.tintColor = UIColor(named: "BrandPurple")
        petImageView.backgroundColor = .systemGray6
        petImageView.contentMode = .scaleAspectFit
    }
}
