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
      let db = Firestore.firestore()
      @Published var alarms = [AlarmInfo]()
      //      var user: User {
      //            didSet {
      //                  listenDocumentLocal()
      //                  print ("Did set run")
      //            }
      //      }

      init () {

      }

      func listenDocumentLocal(_ user: User) -> Void {
            // [START listen_document_local]
            var alarmsIDs: [String] = []


            db.collection("users").document(user.uid!)
                  .addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                              print("Error fetching document: \(error!)")
                              return
                        }
                        //print (alarmsIDs)
                        alarmsIDs = document.data()!["active alarm ids"] as! [String]
                        self.addToAlarms(alarmIDs: alarmsIDs)
                        //print("\(source) data: \(document.data() ?? [:])")
            }



      }

      func addToAlarms(alarmIDs: [String]) {
            //var alarmsArray: [AlarmInfo] = []
            alarms = []
            for alarmID in alarmIDs {
                  let alarmRef = db.collection("alarms").document(alarmID)
                  alarmRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                              var ts = document.data()!["time"] as! Timestamp
                              var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: ts.dateValue())
                              self.alarms.append(AlarmInfo(ownerid: document.data()!["owner ID"] as! String,
                                                           time: dateComponents,
                                                           days_of_the_week: document.data()!["days of the week"] as! [Bool],
                                                           name: document.data()!["name"] as! String,
                                                           charity: document.data()!["charity"] as! String,
                                                           alarmid: alarmID))
                              print (self.alarms.count)
                        } else {
                              print("Document does not exist")
                        }
                  }
            } // for loop

      }
}
