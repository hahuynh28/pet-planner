//
//  FinderSearchViewController.swift
//  PetPlanner
//
//  Created by Ha Huynh on 12/10/25.
//

import UIKit

class FinderSearchViewController: UIViewController {

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
    
    var selectedClinic: Clinic?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchUI()
        setupFilterUI()
        setupLayoutConstraints()
        addClinicCards()
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

        allButton.backgroundColor = .brandPurple
        allButton.setTitleColor(.white, for: .normal)
        allButton.layer.cornerRadius = 10

        emergencyButton.backgroundColor = .systemGray5
        emergencyButton.setTitleColor(.darkGray, for: .normal)
        emergencyButton.layer.cornerRadius = 10

        specialtyButton.backgroundColor = .systemGray5
        specialtyButton.setTitleColor(.darkGray, for: .normal)
        specialtyButton.layer.cornerRadius = 10
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
    
    func addClinicCards() {

        let clinic1 = Clinic(
            name: "Brampton Veterinary Clinic",
            services: "Routine • Surgery • Dentistry",
            distance: "1.5 km",
            rating: "★ 4.8 (215 reviews)",
            address: "123 Main Street, Brampton, ON",
            phone: "(905) 123-4567",
            website: "bramptonvet.com",
            imageName: "milo-avatar"
        )

        let clinic2 = Clinic(
            name: "Heartwood Animal Hospital",
            services: "Emergency • Imaging • Vaccinations",
            distance: "3.2 km",
            rating: "★ 4.5 (88 reviews)",
            address: "456 Queen St, Brampton",
            phone: "(905) 555-2222",
            website: "heartwoodvet.com",
            imageName: "milo-avatar"
        )

        let clinic3 = Clinic(
            name: "The Cat Clinic of Brampton",
            services: "Feline Focus • Wellness Exams",
            distance: "4.1 km",
            rating: "★ 4.9 (23 reviews)",
            address: "789 King St, Brampton",
            phone: "(905) 999-8888",
            website: "catclinic.com",
            imageName: "milo-avatar"
        )

        let card1 = ClinicCardView(
            name: clinic1.name,
            services: clinic1.services,
            distance: clinic1.distance,
            rating: clinic1.rating
        )

        card1.onTap = { [weak self] in
            self?.selectedClinic = clinic1
            self?.openVetDetails()
        }

        let card2 = ClinicCardView(
            name: clinic2.name,
            services: clinic2.services,
            distance: clinic2.distance,
            rating: clinic2.rating
        )

        card2.onTap = { [weak self] in
            self?.selectedClinic = clinic2
            self?.openVetDetails()
        }

        let card3 = ClinicCardView(
            name: clinic3.name,
            services: clinic3.services,
            distance: clinic3.distance,
            rating: clinic3.rating
        )

        card3.onTap = { [weak self] in
            self?.selectedClinic = clinic3
            self?.openVetDetails()
        }

        clinicListStackView.axis = .vertical
        clinicListStackView.spacing = 16

        [card1, card2, card3].forEach {
            clinicListStackView.addArrangedSubview($0)
        }
    }

    
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
