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
    @ObservedObject var alarmNetwork = AlarmNetwork()
    var body: some View {
        ZStack{
            NavigationView{
                ScrollView{
                    VStack(alignment: .leading, spacing: 15){
//                        if sharedHomeView.test_string {
//                            Text("notification tapped")
//                        }
//                        else {
//                            Text("notification not tapped")
//                        }
                        //                    forEach(alarmNetwork.alarms) { alarm in
                        //  Alarmcard(alarmInfo: alarm, alarmOn:true)
                        //                    }
                        AlarmCard(alarmInfo: AlarmInfo(time: DateComponents(hour: 18, minute: 22, second: 0), days_of_the_week: [true, false, false, false, false, false, true], name: "Saturday Run", charity: "BLM", donation: 1.0, alarmid: "asdfad123adfasdf123"), alarmOn: true)
                        AlarmCard(alarmInfo: AlarmInfo(time: DateComponents(hour: 13, minute: 10, second: 0), days_of_the_week: [false, true, true, true, true, true, false], name: "Weekend Grind", charity: "BLM", donation: 1.0, alarmid: "asdfad123adfasdf123"), alarmOn: true)
                        AlarmCard(alarmInfo: AlarmInfo(time: DateComponents(hour: 8, minute: 30, second: 0), days_of_the_week: [true, true, true, true, true, true, true], name: "take pup out", charity: "SPCA", donation: 1.0,alarmid: "asdfad123adfasdf123"), alarmOn: false)
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
            alarmSet(pageOpen: self.$showAlarmSheet, alarmNetwork: self.alarmNetwork).environmentObject(self.RT)
            
        }
    }
}


struct AlarmList_Preview: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(RealTime()).environmentObject(User())
    }
}

