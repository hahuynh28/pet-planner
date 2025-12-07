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
    func configure(with event: DashboardViewController.Event) {
        titleLabel.text   = event.title
        petNameLabel.text = event.pet
        dateLabel.text    = event.date
        petImageView.image = UIImage(named: event.image)
        
        // Hide badge if not needed
//        badgeLabel.isHidden = !event.hasBadge
    }
}
