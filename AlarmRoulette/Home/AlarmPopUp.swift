//
//  AlarmPopUp.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/20/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct AlarmPopUp: View {
    @EnvironmentObject var alarmGlobal: AlarmGlobal
    @EnvironmentObject var user : User
    @EnvironmentObject var alarmNetwork: AlarmNetwork
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                DigitalClock()
                VStack(alignment: .leading){
                    WakeUpClock(date: Date())
                    Button(action: stopAlarm) {
                        Text("Stop")
                        .frame(width: 200, height: 20, alignment: .center)
                        .foregroundColor(Color.white)
                        .padding()
                            .background(Color.gray)
                        .cornerRadius(40)
                    }
                }
                .padding(.leading, 10)
                resultsPreview(alarmid: alarmGlobal.alarmid)
            }
            .padding(.leading, 10)
            .navigationBarItems(
                trailing:
                HStack{
                    Button(action:{
                        withAnimation(.easeOut(duration: 0.2)) {
                            self.alarmGlobal.HomeView = "home"
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
        
        // Adding stopped time to the database
        let alarmActiveUsersRef = db.collection("alarms").document(alarmGlobal.alarmid).collection("active users").document(user.uid!)
        
        // Set the "capital" field of the city 'DC'
        alarmActiveUsersRef.updateData([
            "time stopped": Date()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        var alarm_ids_to_remove = [String]()
//        var new_alarm_requests = [DateComponents]()
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            print("self.alarmGlobal.alarmid \(self.alarmGlobal.alarmid)")
            print("total pending notifications: \(requests.count)")
            for request in requests {
                let alarmid = request.content.userInfo["alarmid"] as! String
                print("request alarmid = \(alarmid)")
                print("request \(request)")
                print("request userInfo \(request.content.userInfo)")
//                print("request trigger \(request.trigger!.)")
                if alarmid == self.alarmGlobal.alarmid {
                    alarm_ids_to_remove.append(request.identifier)
//                    new_alarm_requests.append(request.content.userInfo["dateComponents"] as! DateComponents)
                    
//                    if let trigger = request.trigger as? UNCalendarNotificationTrigger,
//                        let triggerDate = trigger.nextTriggerDate(){
//
//                        let trigger = UNCalendarNotificationTrigger(dateMatching: request.firedate, repeats: true)
//
//                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//                    print("adding alarm for \(dateComponents)")
                    // add our notification request
                    
                }
                
            }
            print("alarm_ids_to_remove \(alarm_ids_to_remove)")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: alarm_ids_to_remove)
//            let tomorrow = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
//            for dc in new_alarm_requests {
//                
//                UNUserNotificationCenter.current().add()
//            }
            
        })
        
        
    }
    
}

struct AlarmPopUp_Previews: PreviewProvider {
    static var previews: some View {
        AlarmPopUp().environmentObject(AlarmGlobal()).environmentObject(RealTime())
    }
}
