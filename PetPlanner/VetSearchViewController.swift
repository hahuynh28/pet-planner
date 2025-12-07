//
//  VetSearchViewController.swift
//  PetPlanner
//
//  Created by Amara Hussain on 2025-12-03.
//

import UIKit

class VetSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var alertsButton: UIButton!

    let allClinics: [VetClinic] = [
        VetClinic(name: "Brampton Veterinary Clinic",
                  distance: "1.5 km",
                  rating: "4.8",
                  reviews: 215,
                  description: "Routine • Care Surgery • Dentistry"),
        VetClinic(name: "Heartwood Animal Hospital",
                  distance: "3.2 km",
                  rating: "4.5",
                  reviews: 88,
                  description: "Emergency • Imaging • Vaccinations"),
        VetClinic(name: "The Cat Clinic of Brampton",
                  distance: "4.1 km",
                  rating: "4.9",
                  reviews: 23,
                  description: "Feline Focus • Wellness Exams")
    ]

    // list that the table actually uses
    var filteredClinics: [VetClinic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate   = self
        searchTextField.addTarget(self,
                                  action: #selector(searchTextChanged),
                                  for: .editingChanged)

        filteredClinics = allClinics
        
        setupHeader()
    }
    
    func setupHeader() {
        searchButton.backgroundColor = .white
        searchButton.applyShadow(opacity: 0.2, y: 3, blur: 6)
        searchButton.makeRound(radius: 12)
        
        alertsButton.backgroundColor = .white
        alertsButton.applyShadow(opacity: 0.2, y: 3, blur: 6)
        alertsButton.makeRound(radius: 12)
    }

    @objc private func searchTextChanged() {
        let text = searchTextField.text ?? ""
        if text.isEmpty {
            filteredClinics = allClinics
        } else {
            filteredClinics = allClinics.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
        }
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVetDetails",
           let indexPath = tableView.indexPathForSelectedRow,
           let dest = segue.destination as? VetDetailsViewController {

            dest.clinic = filteredClinics[indexPath.row]
        }
    }
}

// MARK: - Table View Data Source / Delegate
extension VetSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return filteredClinics.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "VetCell",
                                                 for: indexPath)

        let clinic = filteredClinics[indexPath.row]

        cell.textLabel?.text = clinic.name
        cell.detailTextLabel?.text =
            "\(clinic.distance) • ⭐️\(clinic.rating) (\(clinic.reviews) reviews)"

        return cell
    }
}
