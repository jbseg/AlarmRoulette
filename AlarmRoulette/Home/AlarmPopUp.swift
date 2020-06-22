//
//  AlarmPopUp.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/20/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct AlarmPopUp: View {
    @EnvironmentObject var alarmGlobal: AlarmGlobal
    @EnvironmentObject var user : User
    @ObservedObject var alarmNetwork = AlarmNetwork()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                DigitalClock()
                VStack(alignment: .leading){
                    WakeUpClock(date: Date())
                    Button(action: turnOffAlarm) {
                        Text("Stop")
                    }.buttonStyle(alarmBtnStyle(bgColor: .gray))
                }
                .padding(.leading, 10)
                resultsPreview()
            }
            .padding(.leading, 10)
                .navigationBarItems(
                    trailing:
                    HStack{
                        Button(action:{
                            withAnimation(.easeOut(duration: 0.2)) {
                                self.alarmGlobal.alarmPopUpOn = false
                            }
                        }
                            , label: {
                                Image(systemName: "xmark.circle").resizable().aspectRatio(contentMode: .fit)
                                    .frame(width: 30.0, height: 30.0)
                        })
                })
        }
    }
    
    func turnOffAlarm(){
        // make the network call to that you stopped the notification
        alarmNetwork.alarmStop(userid: user.uid!, alarmid: alarmGlobal.alarmid)
        
        // clear all other notifications
        print(alarmGlobal.notification_ids)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: alarmGlobal.notification_ids)
        alarmGlobal.notification_ids = []
    }
    
}

struct AlarmPopUp_Previews: PreviewProvider {
    static var previews: some View {
        AlarmPopUp().environmentObject(AlarmGlobal()).environmentObject(RealTime())
    }
}
