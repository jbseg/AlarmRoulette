//
//  DigitalClock.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI


struct DigitalClock: View {
    @EnvironmentObject var RT: RealTime
    var body: some View {
        Text("\(timeString(date: RT.date))")
            .font(.system(size: 60))
            .fontWeight(.ultraLight)
//            .foregroundColor(Color.white)
//            .onAppear(perform: startClock)
    }
//    func startClock() {
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
//             self.date = Date()
//           })
//    }
    func timeString(date: Date) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = "h:mm:ss a"
         let time = formatter.string(from: date)
         return time
    }
}


struct DigitalClock_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
//            Color.black.edgesIgnoringSafeArea(.all)
            DigitalClock().environmentObject(RealTime())
        }
    }
}

