//
//  stormForecast.swift
//  snowDay
//
//  Created by Theo Chemel on 4/9/18.
//  Copyright © 2018 Theo Chemel. All rights reserved.
//

import Foundation
import CoreLocation

class stormForecast {
    var timeForecastRecieved: Date?
    var stormPossible: Bool = false
    var startTime: Date?
    var endTime: Date?
    var peakIntensity: Float?
    var peakIntensityTime: Date?
    var totalAccumulation: Float?
    var averageProbability: Float?

}
