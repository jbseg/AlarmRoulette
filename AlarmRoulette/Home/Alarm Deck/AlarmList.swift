//
//  AlarmList.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/19/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct AlarmList: View {
      @State var showJoin = false
      @State var showAlarmSheet = false
      @EnvironmentObject var RT: RealTime
      @EnvironmentObject var user: User
      @EnvironmentObject var alarmNetwork: AlarmNetwork
      var body: some View {
            ZStack{
                  NavigationView{
                        //alarmNetwork.setUser(user)
                        VStack{
                              if !self.alarmNetwork.alarms.isEmpty{
                                    ScrollView(.vertical){
                                          VStack{
                                                ForEach(alarmNetwork.alarms) { alarmInfo in
                                                      AlarmCard(alarmInfo: alarmInfo, alarmOn: true)
                                                      
                                                }.padding(.horizontal, 15)
                                          }
                                          .background(Color("AlarmList"))
                                          Spacer()
                                    }
                              } else {
                                    Text("So much emptiness\nAdd some alarms!")
                                          .multilineTextAlignment(.center)
                                          .lineLimit(2)
                              }
                        }
                              
                        .navigationBarTitle("Alarm Deck",displayMode: .large)
                        .navigationBarItems(
                              trailing:
                              HStack{
                                    Button(action: {
                                          withAnimation{
                                                self.showJoin.toggle()
                                          }
                                    }, label: {
                                          Image(systemName: "person.2").resizable().aspectRatio(contentMode: .fit)
                                                .frame(width: 30.0, height: 30.0)
                                    })
                                    Button(action: {
                                          withAnimation{
                                                self.showAlarmSheet = true
                                          }
                                    }, label: {
                                          Image(systemName: "plus").resizable()
                                                .frame(width: 20.0, height: 20.0)
                                    })
                                    NavigationLink(destination: UserProfile().environmentObject(user)){
                                          if user.image != nil {
                                                Image(uiImage: UIImage(data: user.image!)!)
                                                      .renderingMode(.original)
                                                      .resizable()
                                                      .frame(width: 30, height: 30)
                                                      .clipShape(Circle())
                                                      .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                                                
                                          } else {
                                                Image(systemName: "person.circle").resizable()
                                                      .frame(width: 25.0, height: 25.0)
                                          }
                                    }
                              }
                        )
                  }
                  if self.showJoin {
                        joinMenu(showJoin: self.$showJoin).environmentObject(self.user).environmentObject(self.RT)
                  }
            }
            .sheet(isPresented: self.$showAlarmSheet) {
                  alarmSet(pageOpen: self.$showAlarmSheet).environmentObject(self.user).environmentObject(self.RT)
                  
            }.onAppear(perform: {self.alarmNetwork.listenDocumentLocal(self.user)})
            
      }
}


struct AlarmList_Preview: PreviewProvider {
      static var previews: some View {
            Home().environmentObject(RealTime()).environmentObject(User())
      }
}

