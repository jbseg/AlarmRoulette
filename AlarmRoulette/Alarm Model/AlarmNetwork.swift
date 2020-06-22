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
//    @Published var messages = ["hi","bye"]
//    @Published var bl: Bool = false
//    var user: User
    //      var user: User {
    //            didSet {
    //                  listenDocumentLocal()
    //                  print ("Did set run")
    //            }
    //      }
    
    init () {
        print("network init called")
    }
//
    func listenDocumentLocal(_ user: User) -> Void {
//         [START listen_document_local]
        print("listenDocument is called")
        var alarmsIDs: [String] = []
//        self.bl = true
        let db = Firestore.firestore()
        db.collection("users").document(user.uid!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                //print (alarmsIDs)
                alarmsIDs = document.data()!["active alarm ids"] as! [String]
                print("alarmIDS \(alarmsIDs)")
                self.addToAlarms(alarmIDs: alarmsIDs)
                print(self.alarms)
//                self.bl = true
                //print("\(source) data: \(document.data() ?? [:])")
        }
        
        
        
    }
//    func change_bool(){
//        self.bl.toggle()
//    }
    func addToAlarms(alarmIDs: [String]) {
        //var alarmsArray: [AlarmInfo] = []
        self.alarms = []
//        var msgs = [String]()
        let db = Firestore.firestore()
        for alarmID in alarmIDs {
            let alarmRef = db.collection("alarms").document(alarmID)
            alarmRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    var ts = document.data()!["time"] as! Timestamp
                    var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: ts.dateValue())
                    print(document.data())
                    self.alarms.append(AlarmInfo(ownerid: document.data()!["owner ID"] as! String,
                                                 time: dateComponents,
                                                 days_of_the_week: document.data()!["days of the week"] as! [Bool],
                                                 name: document.data()!["name"] as! String,
                                                 charity: document.data()!["charity"] as! String,
                                                 alarmid: alarmID))
                    print (self.alarms.count)
                    print(self.alarms[0].name)
//                    msgs.append(self.alarms[self.alarms.count-1].name)
//                    self.bl = true
                } else {
                    print("Document does not exist")
                }
            }
//            print(self.alarms)
        } // for loop
//        print(self.alarms)
        
    }
//    func addToMessages(){
//        messages.append("hi")
//        print("messages \(messages)")
//    }
}

