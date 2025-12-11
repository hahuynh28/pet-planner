//
//  FinderViewController.swift
//  PetPlanner
//
//  Created by Ha Huynh on 12/10/25.
//

import UIKit
import MapKit

class FinderViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        addAnnotations()
    }

    func setupMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        let region = MKCoordinateRegion(center: coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                               longitudeDelta: 0.05))
        mapView.setRegion(region, animated: false)
    }

    func addAnnotations() {
        let clinics = [
            ("Brampton Veterinary Clinic", 43.731547, -79.762417),
            ("Heartwood Animal Hospital", 43.688947, -79.759120),
            ("The Cat Clinic of Brampton", 43.684444, -79.754999)
        ]

        for clinic in clinics {
            let annotation = MKPointAnnotation()
            annotation.title = clinic.0
            annotation.coordinate = CLLocationCoordinate2D(latitude: clinic.1, longitude: clinic.2)
            mapView.addAnnotation(annotation)
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
}
