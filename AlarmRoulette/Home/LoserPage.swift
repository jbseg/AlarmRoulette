//
//  LoserPage.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct LoserPage: View {
    @Binding var showSheet: Bool
    @Binding var showLoserPage: Bool
    var body: some View {
        NavigationView {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1), Color(.sRGB, red: 27/255, green: 161/255, blue: 61/255, opacity: 1)]), startPoint: .top, endPoint: .bottom)
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30){
                    Text("Congrats! You've just donated 1$")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        self.showSheet = false
                        self.showLoserPage = false
                    }){
                        Text("Yay!")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.horizontal, 60)
                            .padding(.vertical, 15)
                            .background(Color.green)
                            .cornerRadius(25)
                    }
                }
            }
            
        }
    }
}

struct LoserPage_Previews: PreviewProvider {
    static var previews: some View {
        LoserPage(showSheet: .constant(false), showLoserPage: .constant(false))
    }
}
