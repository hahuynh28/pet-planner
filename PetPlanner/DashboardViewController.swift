//
//  DashboardViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    // sample pets
    let pets: [Pet] = [
        Pet(name: "Milo",      imageName: "milo-avatar"),
        Pet(name: "Whiskers",  imageName: "whiskers-avatar")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate   = self
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
        }
        return cell
    }

    // cell size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 110)
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
