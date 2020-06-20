//
//  AlarmPopUp.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/20/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct AlarmPopUp: View {
    @EnvironmentObject var myVar: Test
    var body: some View {
        
        VStack {
            Button(action:{
                withAnimation(.easeOut(duration: 0.2)) {
                    self.myVar.test_bool = false
                }
            }
            ) {
                Text("exit")
            }
            DigitalClock()
            WakeUpClock(date: Date())
            Button(action: turnOffAlarm) {
                Text("Stop")
            }
            Text(myVar.alarmid)
        }
        
    }
    
    func turnOffAlarm(){
        print(myVar.notification_ids)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: myVar.notification_ids)
        myVar.notification_ids = []
    }
    
//    func closePopUp(){
//
//
//    }
}

struct AlarmPopUp_Previews: PreviewProvider {
    static var previews: some View {
        AlarmPopUp()
    }
}
