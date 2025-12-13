//
//  FinderViewController.swift
//  PetPlanner
//
//  Created by Ha Huynh on 12/10/25.
//

import UIKit
import MapKit
import CoreLocation

class FinderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var alertsButton: UIButton!
    
    let locationManager = CLLocationManager()
    var selectedClinic: VetClinic?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupHeader()
        setupLocationManager()
        setupLocationButton()
        addAnnotations()
    }
    
    func setupHeader() {
        // Style Search Button
        searchButton.backgroundColor = .white
        searchButton.applyShadow(opacity: 0.2, y: 3, blur: 6)
        searchButton.makeRound(radius: 12)
        
        // Style Alerts Button
        alertsButton.backgroundColor = .white
        alertsButton.applyShadow(opacity: 0.2, y: 3, blur: 6)
        alertsButton.makeRound(radius: 12)
    }

    func setupMap() {
        mapView.delegate = self
        // Default start location (Brampton/Toronto area)
        let coordinate = CLLocationCoordinate2D(latitude: 43.688947, longitude: -79.759120)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupLocationButton() {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.setImage(UIImage(systemName: "location.fill"), for: .normal)
        btn.tintColor = UIColor(named: "BrandPurple")
        btn.layer.cornerRadius = 25
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 4
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 50),
            btn.heightAnchor.constraint(equalToConstant: 50),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        btn.addTarget(self, action: #selector(centerOnUser), for: .touchUpInside)
    }
    
    @objc func centerOnUser() {
        guard let location = locationManager.location else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
    }

    func addAnnotations() {
        for clinic in VetClinic.sharedClinics {
            let annotation = MKPointAnnotation()
            annotation.title = clinic.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: clinic.lat, longitude: clinic.long)
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "ClinicPin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) // Info button
        } else {
            view?.annotation = annotation
        }
        
        view?.markerTintColor = UIColor(named: "BrandPurple")
        view?.glyphImage = UIImage(systemName: "cross.case.fill")
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation, let title = annotation.title else { return }
        
        if let foundClinic = VetClinic.sharedClinics.first(where: { $0.name == title }) {
            self.selectedClinic = foundClinic
            performSegue(withIdentifier: "showMapDetail", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapDetail",
           let dest = segue.destination as? VetDetailsViewController {
            dest.clinic = selectedClinic
        }
    }
    
    @IBAction func didTapSearch(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FinderSearchViewController") as? FinderSearchViewController {
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.preferredCornerRadius = 24
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            }
            present(vc, animated: true)
        }
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            
            guard let self = self,
                  let placemark = placemarks?.first,
                  error == nil else { return }
            
            let city = placemark.locality ?? "Unknown"
            let region = placemark.administrativeArea ?? "" // e.g., "ON" or "CA"
            
            DispatchQueue.main.async {
                if region.isEmpty {
                    self.locationLabel.text = city
                } else {
                    self.locationLabel.text = "\(city), \(region)"
                }
            }
        }
    }
}
