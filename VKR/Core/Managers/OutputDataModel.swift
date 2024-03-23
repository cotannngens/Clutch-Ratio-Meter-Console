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
    var latitudeDeg: UInt8?
    var latitudeMin: UInt8?
    var latitudeMinFraq: UInt8?
    var longitudeDeg: UInt8?
    var longitudeMin: UInt8?
    var longitudeMinFraq: UInt8?
    var latitudeLetter: UInt8?
    var longitudeLetter: UInt8?
    var battery: UInt8?
}

enum GpsMode: UInt8 {
    case NO_GPS = 0
    case TWO_D = 1
    case THREE_D = 2
}
