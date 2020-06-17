//
//  BtnStyles.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct alarmBtnStyle: ButtonStyle {
    var bgColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 200, height: 20, alignment: .center)
            .foregroundColor(Color.white)
            .padding()
            .background(bgColor)
            .cornerRadius(40)
    }
}
