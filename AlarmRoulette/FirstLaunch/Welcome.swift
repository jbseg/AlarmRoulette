//
//  Welcome.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI
import Pages

struct Welcome: View {
    @State var index: Int = 0
    @EnvironmentObject var firstLaunch: FirstLaunch
    
    var body: some View {
        Pages(currentPage: $index) {
            WelcomePage(text: "The world's first social alarm clock",
                        btnAction: {self.index += 1}, btnText: "Next")
            WelcomePage(text: "Set an alarm together. Whoever turns it off last donates $1 to charity",
                        btnAction: {
                            self.index += 1
                            
                        }, btnText: "Next")
            WelcomePage(text: "We need you to enable notifications in order for us to set the alarm",
                        btnAction: {self.requestNotificationPermission(index: self.$index)}, btnText: "I Understand")
            WelcomePage(text: "Thanks for being kind",
                        btnAction: {self.firstLaunch.firstLaunchComplete()}, btnText: "Let's do this!")
        }
        .multilineTextAlignment(.center)
        .background(Color.black)
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    func requestNotificationPermission(index: Binding<Int>){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications permissions granted!")
            } else if let error = error {
                print(error.localizedDescription)
            }
            self.index += 1
        }
    }
}

struct WelcomePage: View {
    let text: String
    let btnAction: () -> Void
    let btnText: String
    //    @Binding var page_index: Int
    var body: some View {
        VStack{
            Spacer()
            
            Text(text)
                .font(.system(size: 25))
                .fontWeight(.regular)
                .padding(.horizontal, 40)
            
            Spacer()
            Button(action: btnAction) {
                Text(btnText)
                    .font(.system(size: 20))
                    .padding(.horizontal, 60)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding(.bottom, 50)
        }
        
    }
}
struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
