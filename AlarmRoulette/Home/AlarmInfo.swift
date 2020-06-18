//
//  AlarmInfo.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

class AlarmInfo {
    var time: DateComponents
    var days_of_the_week: Array<Bool>
    var name: String
    var charity: String
    var donation: Float
    
    init (time: DateComponents, days_of_the_week: Array<Bool>, name: String, charity: String, donation: Float) {
        self.time = time
        self.days_of_the_week = days_of_the_week
        self.name = name
        self.charity = charity
        self.donation = donation
    }
}
