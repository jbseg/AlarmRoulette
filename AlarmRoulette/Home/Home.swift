//
//  Home.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

class Test: ObservableObject {
    @Published var test_bool: Bool =  false
    @Published var alarmid: String = ""
    @Published var notification_ids: [String] = []
}

struct Home: View {
    @State var showJoin = false
    @State var showAlarmSheet = false
    @EnvironmentObject var RT: RealTime
    @EnvironmentObject var user: User
    @EnvironmentObject var myVar: Test
    
    var body: some View {
        VStack{
            if myVar.test_bool {
                AlarmPopUp().transition(.move(edge: .bottom))
            }
            else {
                if user.uid != nil {
                    AlarmList().transition(.move(edge: .top))
                } else {
                    Text("loading...")
                }
            }
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(RealTime()).environmentObject(User())
    }
}
