//
//  DashboardViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var alertsButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    var pets: [Pet] = []
    var appointments: [Appointment] = []
    
//    struct Event {
//        let title: String
//        let pet: String
//        let date: String
//        let hasBadge: Bool
//        let image: String
//    }
//    
//    let events: [Event] = [
//        Event(title: "Medication: Apoquel", pet: "Milo", date: "Wed, Nov 5", hasBadge: true, image: "milo-avatar"),
//        Event(title: "Annual Check-up", pet: "Whiskers", date: "Fri, Dec 12", hasBadge: false, image: "whiskers-avatar"),
//        Event(title: "Grooming", pet: "Milo", date: "Sat, Dec 20", hasBadge: false, image: "milo-avatar")
//    ]

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
        
        createDummyPetsIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        let appointment = appointments[indexPath.row]
        cell.configure(with: appointment) // Now passes the Core Data object
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the nav bar on the Dashboard
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show it again when leaving (e.g., going to Pet Profile)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func fetchData() {
        let context = CoreDataStack.shared.context
        do {
            pets = try context.fetch(Pet.fetchRequest())
            collectionView.reloadData()
        } catch { print("Error fetching pets: \(error)") }
        
        // 2. Fetch Appointments
        do {
            let request: NSFetchRequest<Appointment> = Appointment.fetchRequest()
            // Optional: Sort by creation or date string (Primitive sort)
            // Ideally we would sort by a real Date object, but this works for now
            appointments = try context.fetch(request)
            tableView.reloadData()
        } catch { print("Error fetching appointments: \(error)") }
    }
    
    func createDummyPetsIfNeeded() {
        let context = CoreDataStack.shared.context
        let request: NSFetchRequest<Pet> = Pet.fetchRequest()
        
        if (try? context.count(for: request)) == 0 {
            let p1 = Pet(context: context)
            p1.name = "Milo"
            p1.imageName = "milo-avatar"
            p1.breed = "Golden Retriever"
            
            let p2 = Pet(context: context)
            p2.name = "Whiskers"
            p2.imageName = "whiskers-avatar"
            p2.breed = "Tabby Cat"
            
            CoreDataStack.shared.saveContext()
            fetchData()
        }
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
            cell.nameLabel.text = pet.name ?? "Unknown"
            
            cell.petImageView.tintColor = UIColor(named: "BrandPurple")
                        
            if let imgName = pet.imageName {
                // Check if it's an Asset (like "milo-avatar") or a Disk File (UUID)
                if let assetImage = UIImage(named: imgName) {
                    cell.petImageView.image = assetImage
                } else {
                    // Try loading from Disk
                    let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imgName)
                    if let diskImage = UIImage(contentsOfFile: filename.path) {
                        cell.petImageView.image = diskImage
                    } else {
                        cell.petImageView.image = UIImage(systemName: "pawprint.circle.fill")
                    }
                }
            } else {
                cell.petImageView.image = UIImage(systemName: "pawprint.circle.fill")
            }
            
            // Reset style from "Add" cell
            cell.petImageView.backgroundColor = .clear
            cell.petImageView.layer.borderWidth = 0
            cell.petImageView.contentMode = .scaleAspectFill
        } else {
            // Last cell = Add Pet
            cell.nameLabel.text = "Add Pet"
            cell.petImageView.image = UIImage(systemName: "plus")
            cell.petImageView.backgroundColor = UIColor.systemGray6
            cell.petImageView.tintColor = UIColor.gray
            cell.petImageView.contentMode = .center
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
            let selectedPet = pets[indexPath.item]
            performSegue(withIdentifier: "showPetProfile", sender: selectedPet)
        } else {
            performSegue(withIdentifier: "showAddPet", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPetProfile",
           let dest = segue.destination as? PetDetailsViewController,
           let pet = sender as? Pet {
            
            dest.pet = pet
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        } else if segue.identifier == "showAddPet" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        }
    }
}
