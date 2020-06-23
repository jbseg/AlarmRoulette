//
//  alarmSet.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct alarmSet: View {
    @EnvironmentObject var RT: RealTime
    @EnvironmentObject var user: User
    @EnvironmentObject var alarmNetwork: AlarmNetwork
    let db = Firestore.firestore()
    
    @Binding var pageOpen: Bool
    
    @State var wakeUp: Date = Date()
    @State var Name: String = ""
    let charities = ["BLM", "Unicef", "SPCA", "St. Judes"]
    @State private var charity_index = 0
    @State var Donation: Float = 0
    @State var days_of_the_week = [false, false, false, false, false, false, false]
    var body: some View {
        ScrollView{
            VStack(alignment: .center, spacing: 20){
                VStack{
                    TextField("Alarm Group Name", text: $Name)
                    Divider()
                }
                VStack{
                    Text("Set a time")
                        .font(.title)
                    
                    DatePicker("", selection: $wakeUp,  displayedComponents: .hourAndMinute).labelsHidden()
                }
                VStack{
                    Text("Chose the days")
                    WeekDayButtons(days_of_the_week: $days_of_the_week)
                }
                VStack{
                    Text("Charities")
                        .font(.title)
                    Picker("", selection: $charity_index) {
                        ForEach(0 ..< charities.count) { i in
                            Text(self.charities[i])
                        }
                    }.labelsHidden()
                        .padding(.top, -80)
                }
                VStack{
                    Text("Donation Amount: $\(String(format: "%.2f", Donation))")
                        .font(.title)
                    Slider(value: $Donation, in: 0...2, step: 0.1)
                }
                Button(action: setAlarm) {
                    Text("Set Charity Alarm")
                }.buttonStyle(alarmBtnStyle(bgColor: Color(red: 244/255, green: 126/255, blue: 9/255)))
            }.padding()
        }
    }
    
    func setAlarm(){
        // call alarmNetwork.addAlarm(userid: user.uid)
        print (user.uid!)
        // clear the seconds from the wakeup
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: wakeUp)
        self.wakeUp = Calendar.current.date(from: components)!
        
        // if the wakeUp time is before current time, push it a day after today
        if wakeUp < RT.date {
            self.wakeUp = wakeUp.addingTimeInterval(86400)
        }
        print("wakeUp \(wakeUp) RT \(RT.date)")
        
        //Specifying the notification action
        let category = UNNotificationCategory(identifier: "alarmChoice", actions: [
            UNNotificationAction(identifier: "Stop", title: "Stop", options: [.destructive]),
            UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        ], intentIdentifiers: [], options: [])
        
        // create the notification
        let content = UNMutableNotificationContent()
        content.title = "Quick! Alarm Roulette time!"
        content.subtitle = "Be the first to wake up"
        var notification_ids: [String] = []
        for _ in 0...2 {
            let notification_id = UUID().uuidString
            notification_ids.append(notification_id)
        }
        //            content.userInfo["notification_ids"] = notification_ids
        content.userInfo["alarmid"] = "asdfasdfasdfasdf"
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "alarmMain.wav"))
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // clear all previous notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // create 3 notifications 30 seconds apart from each other
        for i in 0...2 {
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            dateComponents.second = i * 30
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            print("datecomponents \(dateComponents)")
            // add our notification request
            UNUserNotificationCenter.current().add(request)
        }
        
        addAlarm()
        //            self.alarmIsSet = true
        self.pageOpen = false
    }
    
    func addAlarm() {
        //adds alarm to overall collection
        let alarmRef = db.collection("alarms").addDocument(data: [
            "name": self.Name,
            "owner ID": user.uid!,
            "days of the week": self.days_of_the_week,
            "charity": self.charities[self.charity_index],
            "time": wakeUp
        ]) { err in
            if let err = err {
                print("Error adding alarm in Alarmset: \(err)")
            } else {
                //print("Alarm added with ID: \(alarmRef!.documentID)")
                //alarmID = alarmRef!.documentID
            }
        }
        
        user.addAlarm(alarmID: alarmRef.documentID)
        
        alarmRef.collection("active users").document(user.uid!).setData([
            "name": user.firstName!,
            "time stopped": nil
        ])
        
        //Might be better to directly add it to the alarm network
        //alarmNetwork.listenDocumentLocal()
        
        //print ("network size: ", alarmNetwork.alarms.count)
    }
}

struct WeekDayButtons: View {
    @Binding var days_of_the_week: Array<Bool>
    var days_initials = ["S", "M", "T", "W", "Th", "F", "S"]
    var body: some View {
        HStack{
            ForEach(0 ..< days_initials.count) { i in
                
                Button(action: {self.days_of_the_week[i].toggle()}, label: {
                    if self.days_of_the_week[i] {
                        Text(self.days_initials[i])
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Color(.blue))
                            .cornerRadius(100)
                    } else {
                        Text(self.days_initials[i])
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Color(.gray))
                            .cornerRadius(100)
                    }
                })
                
                
            }
        }
    }
}

struct alarmSet_Previews: PreviewProvider {
    static var previews: some View {
        alarmSet(pageOpen: .constant(true)).environmentObject(RealTime()).environmentObject(AlarmNetwork())
            .environmentObject(User())
    }
}
