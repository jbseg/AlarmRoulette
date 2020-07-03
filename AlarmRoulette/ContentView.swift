//
//  ContentView.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/6/20.
//  Copyright © 2020 Joshua Segal. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView : View {
      
      @EnvironmentObject var firstLaunch: FirstLaunch
      @EnvironmentObject var user: User
      @ObservedObject var alarmNetwork = AlarmNetwork()
      var body: some View {
            VStack {
                  if !firstLaunch.wasLaunchedBefore {
                        Welcome()
                  }
                  else if Auth.auth().currentUser != nil {
                        Home().environmentObject(alarmNetwork)
                              
                              .transition(.slide)
                        
                  } else {
                        Login()
                              
                              .transition(.slide)
                  }
            }
      }
}


struct ContentView_Previews: PreviewProvider {
      static var previews: some View {
            ContentView()
                  .environmentObject(FirstLaunch())
      }
}
