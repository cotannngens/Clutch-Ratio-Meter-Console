//
//  UserLocationViewController.swift
//  VKR
//
//  Created by Константин Хамицевич on 28.01.2024.
//

import UIKit
import MapKit
import CoreLocation

final class UserLocationViewController: UIViewController {

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        view.showsUserLocation = true
        view.userTrackingMode = .followWithHeading
        return view
    }()

    private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupLocationManager()
    }

    private func setupView() {
        view.backgroundColor = UIColor.backgroundBottomLayer
        view.addSubview(mapView)

        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone

        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestWhenInUseAuthorization()
                if self.locationManager.authorizationStatus == .denied || self.locationManager.authorizationStatus == .restricted {
                    self.showPermissionAlert()
                }
            }
        }

        locationManager.startUpdatingLocation()
    }

    private func showPermissionAlert() {
        let alertController = UIAlertController(title: "Geolocation is restricted",
                                                message: "Give permission to see your current location",
                                                preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension UserLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.userTrackingMode = .followWithHeading
        mapView.showsCompass = true
    }
}

extension UserLocationViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            showPermissionAlert()
        default: break
        }
    }
}
