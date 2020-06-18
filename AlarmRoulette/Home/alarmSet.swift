//
//  alarmSet.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct alarmSet: View {
      @State var wakeUp: Date = Date()
      @EnvironmentObject var RT: RealTime
//      @Binding var alarmIsSet: Bool
      @Binding var pageOpen: Bool
      var body: some View {
            ScrollView{
                  VStack(alignment: .center, spacing: 20){
                        charitySelection()
                              .padding(.top, 40)
                        Text("Set a time")
                              .font(.title)
                        DatePicker("", selection: $wakeUp,  displayedComponents: .hourAndMinute).labelsHidden()
//                    DatePicker(
                        Button(action: setAlarm) {
                              Text("Set Charity Alarm")
                        }.buttonStyle(alarmBtnStyle(bgColor: Color(red: 244/255, green: 126/255, blue: 9/255)))
                  }
            }
      }

      func setAlarm(){
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
            content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "alarmMain.wav"))
            content.categoryIdentifier = "alarmChoice"


            UNUserNotificationCenter.current().setNotificationCategories([category])

            // clear all previous notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            // create 3 notifications 30 seconds apart from each other
            for i in 0...2 {
                  var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
                  dateComponents.second = i * 30
                  let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                  let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                  // add our notification request
                  UNUserNotificationCenter.current().add(request)
            }

//            self.alarmIsSet = true
            self.pageOpen = false
      }
}

struct alarmSet_Previews: PreviewProvider {
      static var previews: some View {
            alarmSet(pageOpen: .constant(false) ).environmentObject(RealTime())
      }
}
