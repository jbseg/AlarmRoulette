//
//  AlarmNetwork.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import Firebase
import FirebaseFirestore
import Combine
import SwiftUI

class AlarmNetwork : ObservableObject {
      @Published var alarms: [AlarmInfo] = [AlarmInfo]()
      let db = Firestore.firestore()

      init () {
            print("network init called")
      }

      func listenDocumentLocal(_ user: User) -> Void {
            print("listenDocument is called")
            var alarmsIDs: [String] = []
            db.collection("users").document(user.uid!)
                  .addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                              print("Error fetching document: \(error!)")
                              return
                        }
                        alarmsIDs = document.data()!["active alarm ids"] as! [String]
                        self.addToAlarms(alarmIDs: alarmsIDs)
            }
      }

      func addToAlarms(alarmIDs: [String]) {
            self.alarms = [AlarmInfo]()
            for alarmID in alarmIDs {
                  let alarmRef = db.collection("alarms").document(alarmID)
                  alarmRef.getDocument { (document, error) in
                    if let error = error {
                        print("error loading alarm \(error)")
                    }
                        if let document = document, document.exists {
                              let ts = document.data()!["time"] as! Timestamp
                              let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: ts.dateValue())
                              self.alarms.append(AlarmInfo(ownerid: document.data()!["owner ID"] as! String,
                                                           time: dateComponents,
                                                           days_of_the_week: document.data()!["days of the week"] as! [Bool],
                                                           name: document.data()!["name"] as! String,
                                                           charity: document.data()!["charity"] as! String,
                                                           alarmid: alarmID))
                        } else {
                              print("Document does not exist")
                        }
                  }
            }// for loop
      }

      // This function will remove the alarm from the user's list of
      // active alarms. If the alarm has 0 users, it will still remain
      // in storage.
      func deleteAlarm(alarmid: String, userid: String) {
            // Remove from the user's active alarm list
            let userRef = db.collection("users").document(userid)
            userRef.updateData([
                "active alarm ids": FieldValue.arrayRemove([alarmid])
            ])

            // Remove the user from alarm list of active  users
            db.collection("alarms").document(alarmid).collection("active users").document(userid).delete() { err in
                if let err = err {
                    print("Error removing alarm from active users collection: \(err)")
                }
            }
            print("delete alarmid, \(alarmid) for user \(userid)")
      }
      
      func stopAlarm(alarmid: String, userid: String){
            print("stop alarmid, \(alarmid) for user \(userid)")

            // Adding stopped time to the database
            let alarmActiveUsersRef = db.collection("alarms").document(alarmid).collection("active users").document(userid)

            // Updating the time stopped
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
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests(completionHandler: { requests in
                print("self.alarmGlobal.alarmid \(alarmid)")
                print("total pending notifications: \(requests.count)")
                for request in requests {
                    let alarmid = request.content.userInfo["alarmid"] as! String
                    print("request alarmid = \(alarmid)")
                    print("request \(request)")
                    print("request userInfo \(request.content.userInfo)")
                    if alarmid == alarmid {
                        alarm_ids_to_remove.append(request.identifier)
                    }
                }
                print("alarm_ids_to_remove \(alarm_ids_to_remove)")
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: alarm_ids_to_remove)

            })
      }
}

