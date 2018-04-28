//
//  testJSON.swift
//  snowDay
//
//  Created by Theo Chemel on 4/13/18.
//  Copyright © 2018 Theo Chemel. All rights reserved.
//

import Foundation

let testJSON = """
{ "timeForecastRecieved" : 1523635200, "stormPossible" : true, "startTime" : 1523635500, "endTime" : 1523636100, "peakIntensity" : 0.968, "peakIntensityTime" : 1523636000, "totalAccumulation" : 53.21, "averageProbability" : 0.937 }
"""

let testJSONData = testJSON.data(using: String.Encoding.utf8)
