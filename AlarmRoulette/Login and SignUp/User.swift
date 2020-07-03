//
//  User.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI
import Firebase
import Combine
import FirebaseFirestore

class User : ObservableObject {
      //    var didChange = PassthroughSubject<SessionStore, Never>()
      let db = Firestore.firestore()
      
      @Published var uid: String?
      @Published var email: String?
      @Published var firstName: String?
      @Published var lastName: String?
      @Published var activeAlarmIds: [String] = []
      @Published var image : Data?
      var handle: AuthStateDidChangeListenerHandle?
      
      
      init () {
            // monitor authentication changes using firebase
            handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                  if let user = user {
                        // find the user in the db and load the info
                        let docRef = Firestore.firestore().collection("users").document(user.uid)
                        docRef.getDocument { (document, error) in
                              if let document = document, document.exists {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                          // set the "user" environment variable
                                          self.uid = user.uid
                                          self.email = user.email!
                                          self.firstName = document.get("firstName") as? String
                                          self.lastName = document.get("lastName") as? String
                                          self.activeAlarmIds = []
                                          guard let imageid = document.get("imageid") as? String else {
                                                print("no image id")
                                                return
                                          }
                                          print("image id \(imageid)")
                                          //                                           download the image from google storage
                                          let downloadRef = Storage.storage().reference(withPath: "profile_img/\(imageid).jpg")
                                          downloadRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                                                if error != nil {
                                                      
                                                      print("error downloading image")
                                                } else {
                                                      self.image = data
                                                }
                                          }
                                          
                                    }
                              } else {
                                    print("Can't find user in db")
                              }
                        }
                  }  else {
                        self.clearUserSession()
                  }
            }
      }
      func signUp(
            email: String,
            password: String,
            handler: @escaping AuthDataResultCallback
      ) {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: handler)
      }
      
      func signIn(
            email: String,
            password: String,
            handler: @escaping AuthDataResultCallback
      ) {
            Auth.auth().signIn(withEmail: email, password: password, completion: handler)
      }
      
      func signOut () -> Bool {
            do {
                  try Auth.auth().signOut()
                  print("signing out")
                  withAnimation(.easeInOut(duration: 0.5)) {
                        clearUserSession()
                  }
                  return true
            } catch {
                  return false
            }
      }
      
      func unbind () {
            if let handle = handle {
                  Auth.auth().removeStateDidChangeListener(handle)
            }
      }
      
      func clearUserSession () {
            self.uid = nil
            self.email = nil
            self.firstName = nil
            self.lastName = nil
            self.image = nil
      }
      
      func addAlarm(alarmID: String) {
            activeAlarmIds.append(alarmID)
            let userRef = db.collection("users").document(uid!)
            
            // Atomically add a new region to the "regions" array field.
            userRef.updateData([
                  "active alarm ids": FieldValue.arrayUnion([alarmID])
            ])
      }
}
