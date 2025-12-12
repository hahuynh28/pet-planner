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
        
        // NEW: Round the image view
        // (We assume the image view will be 60x60 in storyboard)
        petImageView.layer.cornerRadius = 30
        petImageView.clipsToBounds = true
        petImageView.contentMode = .scaleAspectFill
    }

    func configure(with appointment: Appointment) {
        let name = appointment.petName ?? "Unknown Pet"
        petNameLabel.text = name
        
        // NEW: Simple logic to pick the image based on name
        // (Since we don't have a real Pet database relationship yet)
        if name.lowercased().contains("milo") {
            petImageView.image = UIImage(named: "milo-avatar")
        } else if name.lowercased().contains("whisker") {
            petImageView.image = UIImage(named: "whiskers-avatar")
        } else {
            petImageView.image = UIImage(systemName: "pawprint.circle.fill") // Fallback
            petImageView.tintColor = UIColor(named: "BrandPurple")
        }
        
        let date = appointment.dateText ?? ""
        let time = appointment.timeText ?? ""
        dateTimeLabel.text = (!date.isEmpty && !time.isEmpty) ? "\(date) at \(time)" : date + time
        
        clinicLabel.text = appointment.clinicName ?? "No Clinic"
        notesLabel.text = appointment.notes ?? "No notes"
    }
}
