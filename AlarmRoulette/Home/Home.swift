//
//  Home.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI


struct Home: View {
    @State var alarmIsSet = true
    @State var showJoin = false
    @State var showResults = false
    @State var showLoserPage = false
    @State private var wakeUp = Date()
    @State var showAlarmSheet = true
    @State var showSheet = false
    @EnvironmentObject var RT: RealTime
    @EnvironmentObject var user: User
    var body: some View {
        ZStack{
            NavigationView{
                ScrollView{
                    VStack(alignment: .leading, spacing: 15){
                        //                        DigitalClock()
                        //                        if alarmIsSet{
                        AlarmCard(alarmInfo: AlarmInfo(time: DateComponents(hour: 12, minute: 13, second: 0), days_of_the_week: [true, false, false, false, false, false, true], name: "Saturday Run", charity: "BLM", donation: 1.0), alarmOn: true)
                        AlarmCard(alarmInfo: AlarmInfo(time: DateComponents(hour: 9, minute: 21, second: 0), days_of_the_week: [false, true, true, true, true, true, false], name: "Weekend Grind", charity: "BLM", donation: 1.0), alarmOn: true)
                        AlarmCard(alarmInfo: AlarmInfo(time: DateComponents(hour: 8, minute: 30, second: 0), days_of_the_week: [true, true, true, true, true, true, true], name: "take pup out", charity: "SPCA", donation: 1.0), alarmOn: false)
                        //                            if wakeUp <= RT.date && !showResults{
                        //                                Button(action: stopFunc) {
                        //                                    Text("Stop")
                        //                                }.buttonStyle(alarmBtnStyle(bgColor: Color(red: 156/255, green: 157/255, blue: 161/255)))
                        //                            }
                        //                        }
                        
                    }.padding()
                    //                    if showResults {
                    //                        resultsPreview(showSheet: self.$showSheet, showLoserPage: $showLoserPage)
                    //                            .padding(.leading, 30)
                    //                    }
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
                                self.showSheet.toggle()
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
                                    //                                    .border(Color.black, width: 4)
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
        .sheet(isPresented: self.$showSheet) {
            if self.showLoserPage {
                LoserPage( showSheet: self.$showSheet, showLoserPage: self.$showLoserPage)
            }
            else if self.showAlarmSheet{
                alarmSet(wakeUp: self.$wakeUp, alarmIsSet: self.$alarmIsSet, pageOpen: self.$showSheet).environmentObject(self.RT)
            }
        }
    }
    
    func stopFunc(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.alarmIsSet = false
        self.showResults = true
    }
    
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(RealTime()).environmentObject(User())
    }
}
