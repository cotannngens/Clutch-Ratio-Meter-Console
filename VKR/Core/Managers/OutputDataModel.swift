//
//  OutputDataModel.swift
//  VKR
//
//  Created by Константин Хамицевич on 23.03.2024.
//

struct OutputDataModel {
    var drivingWheelSpeed: Float?
    var measuringWheelSpeed: Float?
    var frictionCoeff: Float?
    var force: Float?
    var current: Float?
    var temperature: UInt8?
    var gpsMode: GpsMode?
    var latitudeDeg: Int?
    var latitudeMin: Float?
    var latitudeMinFraq: Float?
    var longitudeDeg: Int?
    var longitudeMin: Float?
    var longitudeMinFraq: Float?
    var latitudeLetter: UInt8?
    var longitudeLetter: UInt8?
    var battery: UInt8?

    var latitudeString: String?
    var longitudeString: String?
    var locationCoordinates = [(String, String)]()
}

enum GpsMode: UInt8 {
    case NO_GPS = 0
    case TWO_D = 1
    case THREE_D = 2
}
