//
//  AlarmCard.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI



struct WeekDays: View {
    var days_of_the_week: Array<Bool>
    var days_initials = ["S", "M", "T", "W", "Th", "F", "S"]
    var body: some View {
        HStack{
            ForEach(0 ..< days_initials.count) {
                if self.days_of_the_week[$0] {
                    Text(self.days_initials[$0])
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(Color(.blue))
                        .cornerRadius(100)
                    
                }
                else {
                    Text(self.days_initials[$0])
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(Color(.gray))
                        .cornerRadius(100)
                }
            }
        }
    }
}

struct AlarmCard: View {
    @State var alarmInfo: AlarmInfo
    @State var alarmOn: Bool
    @State var notification_identifiers: [String] = []
    var body: some View {
        
        //        HStack {
        
        VStack(alignment: .leading) {
            Button(action: toggleAction, label: {
                
                Toggle(isOn: $alarmOn) {
                    VStack(alignment: .leading, spacing: 5){
                        Text(alarmInfo.name)
                            .font(.title)
                        
                        //                Text(alarmInfo.charity)
                        Text("Alarm set for \(alarmInfo.time.hour!):\(alarmInfo.time.minute!)")
                            .font(.body)
                        
                        
                        //            Text("Every \()")
                        //                    Text("\(self.toggleAction())")
                    }
                    
                }
                
            })
            //            .onReceive([self.alarmOn].publisher.first()) { _ in
            
            //            }
            WeekDays(days_of_the_week: alarmInfo.days_of_the_week)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: .gray, radius: 2, x: 0, y: 2)
        //            .padding()
        
        //        )
    }
    
    func toggleAction(){
        if !self.alarmOn {
            print("turning on alarm")
            self.turnOnAlarm()
            //                    self.notification_identifiers = []
        }
        else {
            print("turning off alarm")
            self.turnOffAlarm()
        }
//        return ""
    }
    
    func turnOnAlarm(){
        //Specifying the notification action
        let category = UNNotificationCategory(identifier: "alarmChoice", actions: [
            UNNotificationAction(identifier: "Stop", title: "Stop", options: [.destructive]),
            UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        ], intentIdentifiers: [], options: [])
        
        // create the notification
        let content = UNMutableNotificationContent()
        content.title = "Quick! Alarm Roulette time!"
        content.subtitle = "Be the first to wake up"
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "alarmMain.wav"))
        content.categoryIdentifier = "alarmChoice"
        
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // clear all previous notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // create 3 notifications 30 seconds apart from each other
        for (index, day) in alarmInfo.days_of_the_week.enumerated() {
            if day {
                for i in 0...2 {
                    var dc = alarmInfo.time
                    dc.second = i * 30
                    dc.weekday = index + 1
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
                    let notification_id = UUID().uuidString
                    self.notification_identifiers.append(notification_id)
                    let request = UNNotificationRequest(identifier: notification_id, content: content, trigger: trigger)
                    
                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                    print("added notification for \(dc)")
                }
            }
        }
        print("notification ids \(notification_identifiers)")
    }
    
    func turnOffAlarm(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notification_identifiers)
        notification_identifiers = []
    }
}


struct AlarmCard_Previews: PreviewProvider {
    //    var alarmInfo: AlarmInfo = AlarmInfo(time: DateComponents(hour: 9, minute: 0, second: 0), days_of_the_week: ["Saturday"], charity: "BLM", donation: 1.0)
    static var previews: some View {
        AlarmCard(alarmInfo: AlarmInfo(time: DateComponents(hour: 9, minute: 30, second: 0), days_of_the_week: [true, false, false, false, false, false, true], name: "Saturday Run", charity: "BLM", donation: 1.0), alarmOn: true)
    }
}
