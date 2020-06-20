//
//  AlarmNetwork.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import Firebase
import Combine


class AlarmNetwork : ObservableObject {
    @Published var alarms = [AlarmInfo]()
    
    init() {
        
        let db = Firestore.firestore()
        
        // listen on user's alarm list
        // get the new alarm id
        // query the alarm collection for the alarmid and get all the info
        // fill the AlarmInfo structure
        // apend to list
//        db.collection("chat2").addSnapshotListener { (snap, err) in
//            if err != nil {
//                print((err?.localizedDescription)!)
//                return
//            }
//            for i in snap!.documentChanges {
//                if i.type == .added {
//
//                    guard let name = i.document.get("name") as? String else { return }
//                    guard let msg = i.document.get("msg") as? String else { return }
//                    guard let image = i.document.get("image") as? Data else { return }
//                     let id = i.document.documentID
//
//                    self.chat.append(iDData(id: id,name: name, msg: msg, image: image))
//                    self.chat.sort { (d1, d2) -> Bool in
//                        return d1.msg < d2.msg
//                    }
//                }
//            }
//        }
    }
    
    func addAlarm(userid: String) {
        let db = Firestore.firestore()
        
//        db.collection("chat2").addDocument(data: ["msg": msg, "name": user, "time": FieldValue.serverTimestamp(), "image": image]) { (err) in
//
//            if err != nil {
//                print((err?.localizedDescription)!)
//                return
//            }
//            print("Success")
//        }
    }
}

