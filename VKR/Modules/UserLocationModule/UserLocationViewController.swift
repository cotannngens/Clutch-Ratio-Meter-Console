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
        view.showsCompass = true
        return view
    }()

    private let blueetoothManager = BluetoothManager.shared
    private var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupLocationManager()
        displayCoordinates()
    }

    private func setupView() {
        view.backgroundColor = UIColor.backgroundBottomLayer
        view.addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func bind() {
        blueetoothManager.dataRecieved = { [weak self] in
            self?.displayCoordinates()
        }
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let polyline as MKPolyline:
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .accent
            renderer.lineWidth = 5
            return renderer
        default: fatalError("Unexpected MKOverlay type")
        }
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

extension UserLocationViewController {
    private func extractLocationDegrees(from string: String) -> CLLocationDegrees? {
        let components = string.components(separatedBy: " ")
        guard components.count == 3 else { return nil }
        let degreesString = components[0]
        let minutesString = components[1]
        let signChar = components[2]
        var sign: Double = 1
        switch signChar {
        case "N", "E": sign = 1
        case "S", "W": sign = -1
        default: return nil
        }
        guard let degrees = Double(degreesString), let minutes = Double(minutesString) else { return nil }
        let locationDegreesDouble = sign * (degrees + (minutes / 60))
        return CLLocationDegrees(locationDegreesDouble)
    }

    private func displayCoordinates() {
        mapView.removeOverlays(mapView.overlays)
        let coordinates: [CLLocationCoordinate2D] = blueetoothManager.outputDataModel.locationCoordinates.compactMap { location in
            guard let latitude = extractLocationDegrees(from: location.0), let longitude = extractLocationDegrees(from: location.1) else { return nil }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
    }
}
