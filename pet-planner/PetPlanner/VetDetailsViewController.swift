//
//  VetDetailsViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit

class VetDetailsViewController: UIViewController {

    var clinic: VetClinic!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
    }

    private func populateView() {
        nameLabel.text        = clinic.name
        distanceLabel.text    = clinic.distance
        ratingLabel.text      = "⭐️ \(clinic.rating)"
        reviewsLabel.text     = "(\(clinic.reviews) reviews)"
        descriptionLabel.text = clinic.description
    }

    @IBAction func callButtonTapped(_ sender: UIButton) {
        print("Call \(clinic.name)")
        // later: open tel: URL if you want
    }

    @IBAction func emailButtonTapped(_ sender: UIButton) {
        print("Email \(clinic.name)")
        // later: MFMailComposeViewController if needed
    }
}
