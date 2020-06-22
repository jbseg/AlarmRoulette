//
//  AlarmInfo.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

class AlarmInfo: Identifiable {
      var time: DateComponents
      var days_of_the_week: [Bool]
      var name: String
      var charity: String
      var alarmid: String // will be used as the join id
      var ownerid: String

      init (ownerid: String,
            time: DateComponents,
            days_of_the_week: [Bool],
            name: String,
            charity: String,
            alarmid: String) {
            self.ownerid = ownerid
            self.time = time
            self.days_of_the_week = days_of_the_week
            self.name = name
            self.charity = charity
            self.alarmid = alarmid
      }
}
