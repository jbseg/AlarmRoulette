//
//  AlarmPopUp.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/20/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct AlarmPopUp: View {
      @EnvironmentObject var alarmGlobal: AlarmGlobal
      @EnvironmentObject var user : User
      @EnvironmentObject var alarmNetwork: AlarmNetwork
      
      let db = Firestore.firestore()
      
      var body: some View {
            NavigationView {
                  VStack(alignment: .leading){
                        DigitalClock()
                        VStack(alignment: .leading){
                              WakeUpClock(date: Date())
                              Button(action: stopAlarm) {
                                    Text("Stop")
                                          .frame(width: 200, height: 20, alignment: .center)
                                          .foregroundColor(Color.white)
                                          .padding()
                                          .background(Color.gray)
                                          .cornerRadius(40)
                              }
                        }
                        .padding(.leading, 10)
                        resultsPreview(alarmid: alarmGlobal.alarmid)
                  }
                  .padding(.leading, 10)
                  .navigationBarItems(
                        trailing:
                        HStack{
                              Button(action:{
                                    withAnimation(.easeOut(duration: 0.2)) {
                                          self.alarmGlobal.HomeView = "home"
                                    }
                              }
                                    , label: {
                                          Image(systemName: "xmark.circle").resizable().aspectRatio(contentMode: .fit)
                                                .frame(width: 30.0, height: 30.0)
                              })
                  })
            }
      }
      
      func stopAlarm() {
            alarmNetwork.stopAlarm(alarmid: alarmGlobal.alarmid, userid: user.uid!)
      }
      
}

struct AlarmPopUp_Previews: PreviewProvider {
      static var previews: some View {
            AlarmPopUp().environmentObject(AlarmGlobal()).environmentObject(RealTime())
      }
}
