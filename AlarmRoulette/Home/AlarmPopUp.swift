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
    @EnvironmentObject var alarmNetwork: AlarmNetwork
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                DigitalClock()
                VStack(alignment: .leading){
                    WakeUpClock(date: Date())
                    Button(action: stopAlarm) {
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
    
    func stopAlarm(){
        // make the network call to that you stopped the notification
        alarmNetwork.stopAlarm(alarmid: alarmGlobal.alarmid, userid: user.uid!)
        
        var alarm_ids_to_remove = [String]()
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            print("self.alarmGlobal.alarmid \(self.alarmGlobal.alarmid)")
            for request in requests {
                let alarmid = request.content.userInfo["alarmid"] as! String
                print("alarmid \(alarmid)")
                if alarmid == self.alarmGlobal.alarmid {
                    alarm_ids_to_remove.append(request.identifier)
                }
                    
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: alarm_ids_to_remove)
        })
//        print("alarm_ids_to_remove \(alarm_ids_to_remove)")
        
    }
    
}

struct AlarmPopUp_Previews: PreviewProvider {
    static var previews: some View {
        AlarmPopUp().environmentObject(AlarmGlobal()).environmentObject(RealTime())
    }
}
