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
    
    var clinic: VetClinic?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupHeader()
        setupAvatar()
        setupText()
        setupButtons()
        setupCards()
        setupReviews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupNavigation() {
        view.backgroundColor = .systemBackground
        navigationItem.title = ""
    }

    private func setupHeader() {
        let gradient = CAGradientLayer()
        let brandColor = UIColor(named: "BrandPurple") ?? .systemPurple
        
        let topColor = brandColor.cgColor
        let bottomColor = brandColor.withAlphaComponent(0.8).cgColor
        
        gradient.colors = [topColor, bottomColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width + 100, height: 160)
        headerView.layer.insertSublayer(gradient, at: 0)
        headerView.layer.cornerRadius = 24
        headerView.clipsToBounds = true
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImageView.makeRound(radius: avatarImageView.frame.height / 2)
    }

    private func setupAvatar() {
        if let clinic = clinic {
            avatarImageView.image = UIImage(named: clinic.imageName)
        }
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 4
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.backgroundColor = .white
    }

    private func setupText() {
        guard let clinic = clinic else { return }
        nameLabel.text = clinic.name
//        ratingLabel.text = clinic.rating
        ratingLabel.text = "\(clinic.rating) (\(clinic.reviewsCount) reviews)"
//        ratingLabel.text = "\(clinic.rating) (\(clinic.reviews) reviews)"
        hoursLabel.text = "Closes at 7:00 PM"
        
        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        
        ratingLabel.textColor = .secondaryLabel
        ratingLabel.textAlignment = .center
    }

    private func setupButtons() {
        let primaryColor = UIColor(named: "BrandPurple") ?? .systemPurple

        [callButton, emailButton].forEach {
            $0?.backgroundColor = primaryColor
            $0?.setTitleColor(.white, for: .normal)
            $0?.layer.cornerRadius = 14
            $0?.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        }

        callButton.setTitle("Call Clinic", for: .normal)
        emailButton.setTitle("Email Clinic", for: .normal)
        
        callButton.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(emailTapped), for: .touchUpInside)

        hoursButton.backgroundColor = primaryColor
        hoursButton.setTitleColor(.white, for: .normal)
        hoursButton.layer.cornerRadius = 10
        hoursButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        hoursButton.setTitle("Hours", for: .normal)
        
        hoursLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        hoursLabel.textColor = primaryColor
    }
    
    @objc func callTapped() {
        guard let phone = clinic?.phone else { return }
        
        // Clean the string (remove spaces, brackets) -> e.g. "9051234567"
        let cleanPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if let url = URL(string: "tel://\(cleanPhone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // Fallback for Simulator
            let alert = UIAlertController(title: "Call Clinic", message: "Calling \(phone)...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc func emailTapped() {
        let domain = clinic?.website ?? "gmail.com"
        let email = "info@\(domain)"
        
        if let url = URL(string: "mailto:\(email)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let alert = UIAlertController(title: "Email Clinic", message: "Drafting email to \(email)...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
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
    
    private func setupReviews() {
        reviewsCardView.subviews.forEach { $0.removeFromSuperview() }
        
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.distribution = .equalSpacing
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Recent Reviews"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        
        let viewAllButton = UIButton(type: .system)
        viewAllButton.setTitle("View All", for: .normal)
        viewAllButton.setTitleColor(UIColor(named: "BrandPurple"), for: .normal)
        viewAllButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(viewAllButton)
        reviewsCardView.addSubview(headerStack)
        
        let reviewsStack = UIStackView()
        reviewsStack.axis = .vertical
        reviewsStack.spacing = 16
        reviewsStack.translatesAutoresizingMaskIntoConstraints = false
        
        if let reviews = clinic?.reviewsList.prefix(2) {
            for review in reviews {
                let rowStack = UIStackView()
                rowStack.axis = .vertical
                rowStack.spacing = 4
                
                let authorLabel = UILabel()
                authorLabel.text = review.author
                authorLabel.font = .systemFont(ofSize: 15, weight: .medium)
                
                let detailLabel = UILabel()
                detailLabel.text = "★\(review.rating) - \(review.text)"
                detailLabel.font = .systemFont(ofSize: 14)
                detailLabel.textColor = .secondaryLabel
                detailLabel.numberOfLines = 2
                
                rowStack.addArrangedSubview(authorLabel)
                rowStack.addArrangedSubview(detailLabel)
                reviewsStack.addArrangedSubview(rowStack)
            }
        }
        
        reviewsCardView.addSubview(reviewsStack)
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: reviewsCardView.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: reviewsCardView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: reviewsCardView.trailingAnchor, constant: -16),
            
            reviewsStack.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 16),
            reviewsStack.leadingAnchor.constraint(equalTo: reviewsCardView.leadingAnchor, constant: 16),
            reviewsStack.trailingAnchor.constraint(equalTo: reviewsCardView.trailingAnchor, constant: -16),
             reviewsStack.bottomAnchor.constraint(lessThanOrEqualTo: reviewsCardView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Programmatic Layout Constraints
    private func setupConstraints() {
        [scrollView, contentView, headerView, avatarImageView, nameLabel, ratingLabel, callButton, emailButton, infoCardView, hoursButton, hoursLabel, reviewsCardView].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let g = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 160),
            
            // Avatar
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: headerView.bottomAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Name & Rating
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),
            
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            ratingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Buttons
            callButton.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 24),
            callButton.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            callButton.widthAnchor.constraint(equalTo: emailButton.widthAnchor),
            callButton.heightAnchor.constraint(equalToConstant: 50),
            
            emailButton.topAnchor.constraint(equalTo: callButton.topAnchor),
            emailButton.leadingAnchor.constraint(equalTo: callButton.trailingAnchor, constant: 16),
            emailButton.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),
            emailButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Info Card
            infoCardView.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 30),
            infoCardView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),
            infoCardView.heightAnchor.constraint(equalToConstant: 180),
            
            hoursButton.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            hoursButton.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -16),
            hoursButton.widthAnchor.constraint(equalToConstant: 80),
            hoursButton.heightAnchor.constraint(equalToConstant: 34),
            
            hoursLabel.centerYAnchor.constraint(equalTo: hoursButton.centerYAnchor),
            hoursLabel.leadingAnchor.constraint(equalTo: hoursButton.trailingAnchor, constant: 12),
            hoursLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            
            // Reviews Card
            reviewsCardView.topAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: 24),
            reviewsCardView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            reviewsCardView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),
            reviewsCardView.heightAnchor.constraint(equalToConstant: 180),
            reviewsCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
}
