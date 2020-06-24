//
//  joinMenu.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct joinMenu: View {
      @State var code = ""
      @Binding var showJoin: Bool
      @EnvironmentObject var user: User
      @EnvironmentObject var RT: RealTime

      let db = Firestore.firestore()

      var body: some View {
            VStack{
                  VStack{
                        TextField("Enter Code", text: self.$code)
                              .frame(width: 116.844)
                        Button(action: {
                              self.showJoin.toggle()
                              self.setAlarm(self.code)
                              print("joined group")
                        }) {
                              Text("join")
                        }
                  }.padding()
                        .background(Color.white)
                        .cornerRadius(15)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                  .background(
                        Color.black.opacity(0.65)
                              .edgesIgnoringSafeArea(.all)

                              .onTapGesture {
                                    withAnimation{
                                          self.showJoin.toggle()
                                    }
                        }
            )
      }

      func setAlarm(_ alarmID: String){
            // retreive data from the database, and check
            // if alarm is already in active list
            let userRef = db.collection("users").document(user.uid!)

            userRef.getDocument { (document, error) in
                  if let document = document, document.exists {
                        let activeAlarmIds = document.data()!["active alarm ids"] as! [String]

                        for a in activeAlarmIds {
                              if a == alarmID {
                                    self.sendAlarmAlreadyPresentNotification()
                                    return
                              }
                        }
                  } else {
                        print("Document does not exist")
                        // maybe do something here
                        return
                  }
            }

            // Adding the alarm
            var wakeUp = addAlarmToUser(alarmID)

            // Setting up the notifications
            setUpNotifications(wakeUp)
            //addAlarm()
      }

      func addAlarmToUser(_ alarmID: String) -> Date {
            //add to user's active alarm ids
            user.addAlarm(alarmID: alarmID)
            //add to alarms active user collection within alarm id
            let alarmRef = db.collection("alarms").document(alarmID)
            alarmRef.collection("active users").document(user.uid!).setData([
                "name": user.firstName!,
                "time stopped": nil
            ])

            //set wake up time so notifications can use it
            var wakeup: Date = Date()
            alarmRef.getDocument { (document, error) in
                  if let document = document, document.exists {
                        let ts = document.data()!["time"] as! Timestamp
                        wakeup = ts.dateValue()
                  } else {
                        print("Document does not exist")
                  }
            }
            return wakeup
      }

      func sendAlarmAlreadyPresentNotification() {
            print ("Already present")
      }

      //function based on alarm set
      func setUpNotifications(_ wakeup: Date) {
            // if the wakeUp time is before current time, push it a day after today
            var wakeUp: Date = Date()

            if wakeup < RT.date {
                  wakeUp = wakeUp.addingTimeInterval(86400)
            } else {
                  wakeUp = wakeup
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
      }
}

struct joinMenu_Previews: PreviewProvider {
      static var previews: some View {
            joinMenu(showJoin: .constant(false))
      }
}
