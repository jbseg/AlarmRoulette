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
//    @State var notification_identifiers: [String] = []
    @EnvironmentObject var alarmNetwork: AlarmNetwork
    @EnvironmentObject var user: User
    
    var body: some View {
        NavigationLink(destination: AlarmHistory(), label: {
            HStack(alignment: .top){
                VStack(alignment: .leading, spacing: 5){
                    Text(alarmInfo.name)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.title)
                    Text("Alarm set for \(alarmInfo.time.hour!):\(alarmInfo.time.minute!)")
                        .font(.body)
                    WeekDays(days_of_the_week: alarmInfo.days_of_the_week)
                }
                Button(action: deleteAlarm, label: {
                    Image(systemName: "xmark").resizable()
                        .frame(width: 10.0, height: 10.0)
                })
            }
                
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
            //            .padding()
        })
        
        //        )
        //    })
    }
    
    //    func toggleAction(){
    //        if !self.alarmOn {
    //            print("turning on alarm")
    //            self.turnOnAlarm()
    //            //                    self.notification_identifiers = []
    //        }
    //        else {
    //            print("turning off alarm")
    //            self.turnOffAlarm()
    //        }
    //        //        return ""
    //    }
    
    //    func turnOnAlarm(){
    //        //Specifying the notification action
    //        let category = UNNotificationCategory(identifier: "alarmChoice", actions: [
    //            UNNotificationAction(identifier: "Stop", title: "Stop", options: [.destructive]),
    //            UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
    //        ], intentIdentifiers: [], options: [])
    //
    //        // create the notification
    //
    //        //        content.categoryIdentifier = "alarmChoice"
    //
    //
    //        UNUserNotificationCenter.current().setNotificationCategories([category])
    //
    //        // clear all previous notifications
    //        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    //        // create 3 notifications 30 seconds apart from each other
    //        for (index, day) in alarmInfo.days_of_the_week.enumerated() {
    //            if day {
    //                let content = UNMutableNotificationContent()
    //                content.title = "Quick! Alarm Roulette time!"
    //                content.subtitle = "Be the first to wake up"
    //                var notification_ids: [String] = []
    //                for _ in 0...2 {
    //                    let notification_id = UUID().uuidString
    //                    notification_ids.append(notification_id)
    //                }
    //                content.userInfo["notification_ids"] = notification_ids
    //                content.userInfo["alarmid"] = self.alarmInfo.alarmid
    //                content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "alarmMain.wav"))
    //                for i in 0...2 {
    //                    var dc = alarmInfo.time
    //                    dc.second = i * 30
    //                    dc.weekday = index + 1
    //                    let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
    //
    //                    let request = UNNotificationRequest(identifier: notification_ids[i], content: content, trigger: trigger)
    //
    //                    // add our notification request
    //                    UNUserNotificationCenter.current().add(request)
    //                    print("added notification for \(dc)")
    //                    //                    print(Date())
    //                }
    //            }
    //        }
    //        print("notification ids \(notification_identifiers)")
    //    }
    //
    func deleteAlarm(){
        alarmNetwork.deleteAlarm(alarmid: alarmInfo.alarmid, userid: user.uid!)
        
        var alarm_ids_to_remove = [String]()
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                let alarmid = request.content.userInfo["alarmid"] as! String
                if alarmid == self.alarmInfo.alarmid{
                    alarm_ids_to_remove.append(request.identifier)
                }
                    
            }
        })
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: alarm_ids_to_remove)
    }
}


struct AlarmCard_Previews: PreviewProvider {
    //    var alarmInfo: AlarmInfo = AlarmInfo(time: DateComponents(hour: 9, minute: 0, second: 0), days_of_the_week: ["Saturday"], charity: "BLM", donation: 1.0)
    static var previews: some View {
        AlarmCard(alarmInfo: AlarmInfo(ownerid: "asdafsd", time: DateComponents(hour: 9, minute: 30, second: 0), days_of_the_week: [true, false, false, false, false, false, true], name: "Saturday Run", charity: "BLM", alarmid: "asdfoiw1234"), alarmOn: true)
    }
}
