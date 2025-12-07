//
//  DashboardViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertsButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    // sample pets
    let pets: [Pet] = [
        Pet(name: "Milo",      imageName: "milo-avatar"),
        Pet(name: "Whiskers",  imageName: "whiskers-avatar")
    ]
    
    struct Event {
        let title: String
        let pet: String
        let date: String
        let hasBadge: Bool
        let image: String
    }
    
    let events: [Event] = [
        Event(title: "Medication: Apoquel", pet: "Milo", date: "Wed, Nov 5", hasBadge: true, image: "milo-avatar"),
        Event(title: "Annual Check-up", pet: "Whiskers", date: "Fri, Dec 12", hasBadge: false, image: "whiskers-avatar"),
        Event(title: "Grooming", pet: "Milo", date: "Sat, Dec 20", hasBadge: false, image: "milo-avatar")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate   = self
        tableView.dataSource = self
        tableView.delegate = self
        
        alertsButton.applyShadow(opacity: 0.2, y: 3, blur: 6)
        alertsButton.makeRound(radius: 12)
        searchButton.applyShadow(opacity: 0.2, y: 3, blur: 6)
        searchButton.makeRound(radius: 12)
        tableView.separatorStyle = .none  // Hides lines so cards look floating
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    // 5. Build each card
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        let event = events[indexPath.row]
        
        // Use the configure function we wrote in Part A
        cell.configure(with: event)
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the nav bar on the Dashboard
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show it again when leaving (e.g., going to Pet Profile)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Collection View Data Source / Delegate
extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return pets.count + 1   // extra cell for "Add Pet"
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell",
                                                      for: indexPath) as! PetCell

        if indexPath.item < pets.count {
            let pet = pets[indexPath.item]
            cell.nameLabel.text = pet.name
            cell.petImageView.image = UIImage(named: pet.imageName)
        } else {
            // Last cell = Add Pet
            cell.nameLabel.text = "Add Pet"
            cell.petImageView.image = UIImage(systemName: "plus")
            cell.petImageView.backgroundColor = UIColor.systemGray6 // Light gray background
            cell.petImageView.tintColor = UIColor.gray // Gray plus icon
            cell.petImageView.contentMode = .center // Keep the plus icon centered and small
            cell.petImageView.layer.borderWidth = 0
        }
        return cell
    }

    // cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 125)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < pets.count {
            // existing pet selected – storyboard team will hook segue to PetProfileVC
            print("Selected pet: \(pets[indexPath.item].name)")
        } else {
            // Add Pet cell tapped – storyboard team can show Add Pet form
            print("Add Pet tapped")
        }
    }
}

extension UIView {
    func applyShadow(color: UIColor = .black, opacity: Float = 0.2, x: CGFloat = 0, y: CGFloat = 4, blur: CGFloat = 6) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = blur
        self.layer.masksToBounds = false // Important: Allows shadow to appear outside the frame
    }
    
    func makeRound(radius: CGFloat = 12) {
        self.layer.cornerRadius = radius
        // self.clipsToBounds = true // Note: Don't use this if you want shadows!
    }
}
