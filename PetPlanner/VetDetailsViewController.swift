//
//  VetDetailsViewController.swift
//  PetPlanner
//
//  Created by Ha Huynh on 12/12/25.
//

import UIKit

class VetDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!

    @IBOutlet weak var infoCardView: UIView!
    @IBOutlet weak var hoursButton: UIButton!
    @IBOutlet weak var hoursLabel: UILabel!

    @IBOutlet weak var reviewsCardView: UIView!
    
    var clinic: Clinic?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupScroll()
        setupHeader()
        setupAvatar()
        setupText()
        setupButtons()
        setupCards()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupNavigation() {
        view.backgroundColor = .systemBackground
        navigationItem.title = ""
    }

    private func setupScroll() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func setupHeader() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.95, green: 0.65, blue: 0.42, alpha: 1).cgColor,
            UIColor(red: 0.90, green: 0.55, blue: 0.30, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = headerView.bounds
        headerView.layer.insertSublayer(gradient, at: 0)

        headerView.layer.cornerRadius = 24
        headerView.clipsToBounds = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        avatarImageView.makeRound(radius: avatarImageView.frame.height / 3)

        contentView.bringSubviewToFront(avatarImageView)
    }



    private func setupAvatar() {
        avatarImageView.image = UIImage(named: "milo-avatar")
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true

        avatarImageView.layer.borderWidth = 4
        avatarImageView.layer.borderColor = UIColor.white.cgColor

        avatarImageView.backgroundColor = .white
    }



    private func setupText() {
        guard let clinic = clinic else { return }

        nameLabel.text = clinic.name
        ratingLabel.text = clinic.rating
        avatarImageView.image = UIImage(named: clinic.imageName)
        hoursLabel.text = "Closes at 7:00 PM"
    }


    private func setupButtons() {
        let primaryColor = UIColor.brandPurple

        [callButton, emailButton].forEach {
            guard let button = $0 else { return }

            button.backgroundColor = primaryColor
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 14
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)

            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            button.contentEdgeInsets = UIEdgeInsets(
                top: 10,
                left: 20,
                bottom: 10,
                right: 20
            )
        }

        callButton.setTitle("Call Clinic", for: .normal)
        emailButton.setTitle("Email Clinic", for: .normal)

        hoursButton.backgroundColor = primaryColor
        hoursButton.setTitleColor(.white, for: .normal)
        hoursButton.layer.cornerRadius = 10
        hoursButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        hoursButton.setTitle("Hours", for: .normal)

        hoursButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        hoursButton.contentEdgeInsets = UIEdgeInsets(
            top: 6,
            left: 16,
            bottom: 6,
            right: 16
        )

        hoursLabel.text = "Closes at 7:00 PM"
        hoursLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        hoursLabel.textColor = primaryColor
    }


    private func setupCards() {
        styleCard(infoCardView)
        styleCard(reviewsCardView)
    }

    private func styleCard(_ view: UIView) {
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 10
    }
}
