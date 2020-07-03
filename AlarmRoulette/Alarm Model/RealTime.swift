//
//  RealTime.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

class RealTime: ObservableObject {
    @Published var date = Date()

    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
          self.date = Date()
        })
    }
}

