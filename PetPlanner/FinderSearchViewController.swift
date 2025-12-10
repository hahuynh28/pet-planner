//
//  FinderSearchViewController.swift
//  PetPlanner
//
//  Created by Ha Huynh on 12/10/25.
//

import UIKit

class FinderSearchViewController: UIViewController {
    
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchUI()
    }

    func setupSearchUI() {
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
}
