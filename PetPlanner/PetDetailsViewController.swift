//
//  PetDetailsViewController.swift
//  PetPlanner
//
//  Created by Tristan Katwaroo on 2025-12-12.
//

import UIKit
import CoreData

class PetDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var pet: Pet! // Data injected from Dashboard

//    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel! // "4 years old"
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var appointments: [Appointment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show Nav Bar so we have a "Back" button
        navigationController?.setNavigationBarHidden(false, animated: animated)
        populateData() // Refresh in case we edited the pet
    }
    
    func setupUI() {
        // Style the image
        petImageView.layer.cornerRadius = 60 // Assuming 120x120 size
        petImageView.layer.borderWidth = 4
        petImageView.layer.borderColor = UIColor.white.cgColor
        petImageView.clipsToBounds = true
        petImageView.contentMode = .scaleAspectFill
        
        // Style buttons
//        deleteButton.layer.cornerRadius = 20 // Pill shape
        deleteButton.backgroundColor = .systemRed.withAlphaComponent(0.1)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        
//        editButton.layer.cornerRadius = 20
        editButton.backgroundColor = UIColor.systemGray6
        editButton.setTitleColor(.black, for: .normal)
    }
    
    func populateData() {
        nameLabel.text = pet.name
        breedLabel.text = pet.breed ?? "Unknown Breed"
        
        // Calculate Age (Optional logic)
        if let dob = pet.dob {
            let ageComponents = Calendar.current.dateComponents([.year], from: dob, to: Date())
            let years = ageComponents.year ?? 0
            ageLabel.text = "\(years) years old"
        } else {
            ageLabel.text = "Age Unknown"
        }
        
        // Image Logic
        if let imgName = pet.imageName {
            // 1. Try Asset Catalog (for dummy data like "milo-avatar")
            if let assetImage = UIImage(named: imgName) {
                petImageView.image = assetImage
            } else {
                // 2. Try Documents Directory (for user uploads)
                let filename = getDocumentsDirectory().appendingPathComponent(imgName)
                if let diskImage = UIImage(contentsOfFile: filename.path) {
                    petImageView.image = diskImage
                } else {
                    // 3. File not found anywhere
                    petImageView.image = UIImage(systemName: "pawprint.circle.fill")
                }
            }
        } else {
            // No image name saved
            petImageView.image = UIImage(systemName: "pawprint.circle.fill")
        }
        
        if let petAppointments = pet.appointments as? Set<Appointment> {
            self.appointments = Array(petAppointments).sorted {
                ($0.dateText ?? "") > ($1.dateText ?? "")
            }
            tableView.reloadData()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete \(pet.name ?? "Pet")?", message: "This will also delete all their appointments.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            CoreDataStack.shared.context.delete(self.pet)
            CoreDataStack.shared.saveContext()
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditPet",
           let dest = segue.destination as? EditPetViewController {
            dest.pet = self.pet
        }
    }
    
    // MARK: - Table View Logic
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // REUSE the "AppointmentCell" logic!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as? AppointmentCell else {
            return UITableViewCell()
        }

        let appt = appointments[indexPath.row]
        cell.configure(with: appt)
        cell.backgroundColor = .clear // Important for shadow

        return cell
    }
}
