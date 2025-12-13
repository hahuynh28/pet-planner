//
//  FinderSearchViewController.swift
//  PetPlanner
//
//  Created by Ha Huynh on 12/10/25.
//

import UIKit
import CoreLocation

class FinderSearchViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var searchLabel: UILabel!
    
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var emergencyButton: UIButton!
    @IBOutlet weak var specialtyButton: UIButton!
    @IBOutlet weak var clinicListStackView: UIStackView!
    
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var selectedClinic: VetClinic?
    
    enum FilterType {
        case all
        case emergency
        case specialty
    }
    
    var activeFilter: FilterType = .all
    var filteredClinics: [VetClinic] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchUI()
        setupFilterUI()
        setupLayoutConstraints()
//        addClinicCards()
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        // Setup Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Initial Render
//        filteredClinics = VetClinic.sharedClinics
//        renderCards()
        
        applyFilters()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        renderCards()
    }
    
//    @objc func searchTextChanged() {
//        let text = searchTextField.text ?? ""
//        if text.isEmpty {
//            filteredClinics = VetClinic.sharedClinics
//        } else {
//            // Filter the shared list
//            filteredClinics = VetClinic.sharedClinics.filter {
//                $0.name.lowercased().contains(text.lowercased()) ||
//                $0.address.lowercased().contains(text.lowercased())
//            }
//        }
//        renderCards()
//    }
    
    @objc func searchTextChanged() {
        applyFilters()
    }
    
    func applyFilters() {
        let text = searchTextField.text?.lowercased() ?? ""
        
        filteredClinics = VetClinic.sharedClinics.filter { clinic in
            let matchesText = text.isEmpty ||
                              clinic.name.lowercased().contains(text) ||
                              clinic.address.lowercased().contains(text)
            
            let matchesCategory: Bool
            switch activeFilter {
            case .all:
                matchesCategory = true
            case .emergency:
                matchesCategory = clinic.services.contains("Emergency")
            case .specialty:
                matchesCategory = clinic.services.contains("Surgery") ||
                                  clinic.services.contains("Dentistry") ||
                                  clinic.services.contains("Feline") ||
                                  clinic.services.contains("Imaging")
            }
            
            return matchesText && matchesCategory
        }
        
        renderCards()
    }
    
    @objc func didTapAll() {
        updateActiveFilter(.all)
    }
    
    @objc func didTapEmergency() {
        updateActiveFilter(.emergency)
    }
    
    @objc func didTapSpecialty() {
        updateActiveFilter(.specialty)
    }
    
    func updateActiveFilter(_ type: FilterType) {
        activeFilter = type
        updateButtonStyles()
        applyFilters()
    }
    
    func updateButtonStyles() {
        // Helper to reset style
        let setStyle = { (btn: UIButton, isActive: Bool) in
            if isActive {
                btn.backgroundColor = UIColor(named: "BrandPurple")
                btn.setTitleColor(.white, for: .normal)
            } else {
                btn.backgroundColor = .systemGray5
                btn.setTitleColor(.darkGray, for: .normal)
            }
        }
        
        setStyle(allButton, activeFilter == .all)
        setStyle(emergencyButton, activeFilter == .emergency)
        setStyle(specialtyButton, activeFilter == .specialty)
    }
    
    func renderCards() {
        // Clear existing cards
        clinicListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        clinicListStackView.axis = .vertical
        clinicListStackView.spacing = 16
        
        if filteredClinics.isEmpty {
            let label = UILabel()
            label.text = "No clinics found."
            label.textAlignment = .center
            label.textColor = .secondaryLabel
            clinicListStackView.addArrangedSubview(label)
            return
        }
        
        for clinic in filteredClinics {
            // Calculate Distance
            var distanceText = "Calculating..."
            if let userLoc = userLocation {
                let distInMeters = userLoc.distance(from: clinic.location)
                let distInKm = distInMeters / 1000.0
                distanceText = String(format: "%.1f km", distInKm)
            }
            
            let card = ClinicCardView(
                name: clinic.name,
                services: clinic.services,
                distance: distanceText,
                rating: "\(clinic.rating) (\(clinic.reviewsCount))"
            )
            
            card.onTap = { [weak self] in
                self?.selectedClinic = clinic
                self?.openVetDetails()
            }
            
            clinicListStackView.addArrangedSubview(card)
        }
    }

    func setupSearchUI() {
        searchLabel.font = .systemFont(ofSize: 22, weight: .bold)

        searchContainer.backgroundColor = .white
        searchContainer.layer.cornerRadius = 14
        searchContainer.layer.shadowColor = UIColor.black.cgColor
        searchContainer.layer.shadowOpacity = 0.06
        searchContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        searchContainer.layer.shadowRadius = 6

        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.tintColor = .systemGray3

        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search for a clinic or address",
            attributes: [
                .foregroundColor: UIColor.systemGray3,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
    }

    func setupFilterUI() {
        filterStackView.axis = .horizontal
        filterStackView.alignment = .fill
        filterStackView.distribution = .fillEqually
        filterStackView.spacing = 12

        // Style & Add Actions
        setupButton(allButton, title: "All")
        allButton.addTarget(self, action: #selector(didTapAll), for: .touchUpInside)
        
        setupButton(emergencyButton, title: "Emergency")
        emergencyButton.addTarget(self, action: #selector(didTapEmergency), for: .touchUpInside)
        
        setupButton(specialtyButton, title: "Specialty")
        specialtyButton.addTarget(self, action: #selector(didTapSpecialty), for: .touchUpInside)
        
        // Set initial state
        updateButtonStyles()
    }
    
    func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    }

    func setupLayoutConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        clinicListStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            searchLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            searchLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            searchLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])

        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 12),
            searchContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            searchContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            searchContainer.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20)
        ])

        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -5),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 20),
            filterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            filterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            filterStackView.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            clinicListStackView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 24),
            clinicListStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            clinicListStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            clinicListStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
//    func addClinicCards() {
//
//        let clinic1 = VetClinic(
//            name: "Brampton Veterinary Clinic",
//            services: "Routine • Surgery • Dentistry",
//            distance: "1.5 km",
//            rating: "★ 4.8 (215 reviews)",
//            reviews: 215,
//            address: "123 Main Street, Brampton, ON",
//            phone: "(905) 123-4567",
//            website: "bramptonvet.com",
//            imageName: "milo-avatar"
//        )
//
//        let clinic2 = VetClinic(
//            name: "Heartwood Animal Hospital",
//            services: "Emergency • Imaging • Vaccinations",
//            distance: "3.2 km",
//            rating: "★ 4.5 (88 reviews)",
//            reviews: 88,
//            address: "456 Queen St, Brampton",
//            phone: "(905) 555-2222",
//            website: "heartwoodvet.com",
//            imageName: "milo-avatar"
//        )
//
//        let clinic3 = VetClinic(
//            name: "The Cat Clinic of Brampton",
//            services: "Feline Focus • Wellness Exams",
//            distance: "4.1 km",
//            rating: "★ 4.9 (23 reviews)",
//            reviews: 23,
//            address: "789 King St, Brampton",
//            phone: "(905) 999-8888",
//            website: "catclinic.com",
//            imageName: "milo-avatar"
//        )
//
//        let card1 = ClinicCardView(
//            name: clinic1.name,
//            services: clinic1.services,
//            distance: clinic1.distance,
//            rating: "\(clinic1.rating) (\(clinic1.reviews))"
//        )
//
//        card1.onTap = { [weak self] in
//            self?.selectedClinic = clinic1
//            self?.openVetDetails()
//        }
//
//        let card2 = ClinicCardView(
//            name: clinic2.name,
//            services: clinic2.services,
//            distance: clinic2.distance,
//            rating: clinic2.rating
//        )
//
//        card2.onTap = { [weak self] in
//            self?.selectedClinic = clinic2
//            self?.openVetDetails()
//        }
//
//        let card3 = ClinicCardView(
//            name: clinic3.name,
//            services: clinic3.services,
//            distance: clinic3.distance,
//            rating: clinic3.rating
//        )
//
//        card3.onTap = { [weak self] in
//            self?.selectedClinic = clinic3
//            self?.openVetDetails()
//        }
//
//        clinicListStackView.axis = .vertical
//        clinicListStackView.spacing = 16
//
//        [card1, card2, card3].forEach {
//            clinicListStackView.addArrangedSubview($0)
//        }
//    }

    
    func openVetDetails() {
        performSegue(withIdentifier: "showVetDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVetDetails",
           let vc = segue.destination as? VetDetailsViewController {
            vc.clinic = selectedClinic
        }
    }

}
