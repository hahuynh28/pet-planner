//
//  ClinicCardView.swift
//  PetPlanner
//
//  Created by Ha Huynh on 12/12/25.
//

import UIKit

class ClinicCardView: UIView {

    var onTap: (() -> Void)?

    private let nameLabel = UILabel()
    private let servicesLabel = UILabel()
    private let distanceLabel = UILabel()
    private let ratingLabel = UILabel()

    init(
        name: String,
        services: String,
        distance: String,
        rating: String
    ) {
        super.init(frame: .zero)
        setupTap()
        setupUI()
        setupLayout()
        nameLabel.text = name
        servicesLabel.text = services
        distanceLabel.text = distance
        ratingLabel.text = rating
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTap()
        setupUI()
        setupLayout()
    }

    private func setupTap() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        print("CARD TAPPED")
        onTap?()
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8

        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        servicesLabel.font = .systemFont(ofSize: 14)
        servicesLabel.numberOfLines = 2
        distanceLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        ratingLabel.font = .systemFont(ofSize: 14, weight: .medium)

        [nameLabel, servicesLabel, distanceLabel, ratingLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 120),

            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            servicesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            servicesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            servicesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            ratingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

