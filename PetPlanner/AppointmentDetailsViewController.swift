//
//  AppointmentDetailsViewController.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-12.
//

import UIKit
import CoreData

class AppointmentDetailsViewController: UIViewController {

    var appointment: Appointment! // Data injected from the list

    // Header
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel! // (Optional, we might just use "Dog/Cat")

    // Cards
    @IBOutlet weak var dateTimeCard: UIView!
    @IBOutlet weak var infoCard: UIView!
    
    // Data Labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEdit",
           let dest = segue.destination as? EditAppointmentViewController {
            dest.appointment = self.appointment
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Appointment Details"
        
        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        
        setupStyle()
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        populateData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupStyle() {
        // 1. Style the Pet Image
        petImageView.layer.cornerRadius = 30
        petImageView.clipsToBounds = true
        petImageView.contentMode = .scaleAspectFill
        
        // 2. Style the Cards (White with Shadow)
        [dateTimeCard, infoCard].forEach { card in
            card?.backgroundColor = .white
            card?.layer.cornerRadius = 12
            card?.applyShadow(color: .black, opacity: 0.1, x: 0, y: 0, blur: 3)
        }
        
        // 3. Style Buttons (Outline Style)
        styleOutlineButton(editButton, color: UIColor(named: "BrandPurple") ?? .systemBlue)
        styleOutlineButton(deleteButton, color: .systemRed)
    }
    
    func styleOutlineButton(_ button: UIButton, color: UIColor) {
        button.layer.borderWidth = 1.5
        button.layer.borderColor = color.cgColor
        button.layer.cornerRadius = 12 // Match card radius
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = .clear
    }

    func populateData() {
        // Pet Info
        let name = appointment.petName ?? "Unknown"
        petNameLabel.text = name
        
        if let pet = appointment.pet, let breed = pet.breed, !breed.isEmpty {
            breedLabel.text = breed
        } else {
            breedLabel.text = "Pet" // Fallback
        }
        
        petImageView.image = nil
        petImageView.tintColor = UIColor(named: "BrandPurple")
        petImageView.contentMode = .scaleAspectFill
        
        if let pet = appointment.pet, let imgName = pet.imageName {
            // Try Asset (Dummy data)
            if let assetImage = UIImage(named: imgName) {
                petImageView.image = assetImage
            }
            // Try Disk (User uploads)
            else {
                let filename = getDocumentsDirectory().appendingPathComponent(imgName)
                if let diskImage = UIImage(contentsOfFile: filename.path) {
                    petImageView.image = diskImage
                } else {
                    // Fallback
                    petImageView.image = UIImage(systemName: "pawprint.circle.fill")
                    petImageView.contentMode = .scaleAspectFit
                }
            }
        } else {
            // No image
            petImageView.image = UIImage(systemName: "pawprint.circle.fill")
            petImageView.contentMode = .scaleAspectFit
        }
        
        // Details
        dateLabel.text = appointment.dateText
        timeLabel.text = appointment.timeText
        clinicLabel.text = appointment.clinicName
        reasonLabel.text = appointment.notes
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Appointment?", message: "This cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            CoreDataStack.shared.context.delete(self.appointment)
            CoreDataStack.shared.saveContext()
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
