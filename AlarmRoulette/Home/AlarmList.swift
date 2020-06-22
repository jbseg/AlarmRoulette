//
//  AlarmList.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/19/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct AlarmList: View {
    //    @State var sharedHomeView = HomeView.sharedHomeView.test_string
    @State var showJoin = false
    @State var showAlarmSheet = false
    @EnvironmentObject var RT: RealTime
    @EnvironmentObject var user: User
    //      @ObservedObject var alarmNetwork = AlarmNetwork()
    @EnvironmentObject var alarmNetwork: AlarmNetwork
    var body: some View {
        ZStack{
            NavigationView{
                //alarmNetwork.setUser(user)
//                ScrollView{
                    VStack(spacing: 15){
                        ForEach(alarmNetwork.alarms) { alarmInfo in
                                                                      AlarmCard(alarmInfo: alarmInfo, alarmOn: true)
                            
                        }          
                    }
                    
//                    Spacer()
//                }
                    
                .navigationBarTitle("Alarm Roulette",displayMode: .large)
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
                joinMenu(showJoin: self.$showJoin)
            }
        }
        .sheet(isPresented: self.$showAlarmSheet) {
            alarmSet(pageOpen: self.$showAlarmSheet, alarmNetwork: self.alarmNetwork).environmentObject(self.user).environmentObject(self.RT)
            
        }.onAppear(perform: {self.alarmNetwork.listenDocumentLocal(self.user)})
    }
}


struct AlarmList_Preview: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(RealTime()).environmentObject(User())
    }
}

