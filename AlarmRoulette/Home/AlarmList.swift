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
                ScrollView{
                    VStack(alignment: .leading, spacing: 15){
                        //Printing out the active alarms
//                        Button(action: {self.alarmNetwork.change_bool()
//                            self.alarmNetwork.addToMessages()
//                        }) {
//                            Text("change bl")
//                        }
//                        if alarmNetwork.bl {
//                            Text("bl is true")
//                        } else
//                        {
//                            Text("bl is false")
//                        }
                        ForEach(alarmNetwork.alarms) { alarmInfo in
                            //                                        Text(alarmInfo.alarmid)
//                            AlarmCard(alarmInfo: AlarmInfo(ownerid: "asdafsd",time: DateComponents(hour: 18, minute: 22, second: 0), days_of_the_week: [true, false, false, false, false, false, true], name: "Saturday Run", charity: "BLM", alarmid: "asdfad123adfasdf123"), alarmOn: true)
                                                                      AlarmCard(alarmInfo: alarmInfo, alarmOn: true)
                        }
//                        List(alarmNetwork.messages, id: \.self) { msg in
//                            Text(msg)
//                        }
//                        ForEach(alarmNetwork.messages, id: \.self) { string in
//                            Text(string)
//                        }
//                        Text(alarmNetwork.messages[0])
//                        AlarmCard(alarmInfo: AlarmInfo(ownerid: "asdafsd",time: DateComponents(hour: 18, minute: 22, second: 0), days_of_the_week: [true, false, false, false, false, false, true], name: "Saturday Run", charity: "BLM", alarmid: "asdfad123adfasdf123"), alarmOn: true)
//                        AlarmCard(alarmInfo: AlarmInfo(ownerid: "asdafsd",time: DateComponents(hour: 13, minute: 10, second: 0), days_of_the_week: [false, true, true, true, true, true, false], name: "Weekend Grind", charity: "BLM", alarmid: "asdfad123adfasdf123"), alarmOn: true)
//                        AlarmCard(alarmInfo: AlarmInfo(ownerid: "asdafsd",time: DateComponents(hour: 8, minute: 30, second: 0), days_of_the_week: [true, true, true, true, true, true, true], name: "take pup out", charity: "SPCA", alarmid: "asdfad123adfasdf123"), alarmOn: false)
                        
                    }.padding()
                    
                    Spacer()
                }
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

