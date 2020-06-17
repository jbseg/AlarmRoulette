//
//  joinMenu.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct joinMenu: View {
    @State var code = ""
    @Binding var showJoin: Bool
    var body: some View {
        VStack{
            VStack{
                TextField("Enter Code", text: self.$code)
                    .frame(width: 116.844)
                Button(action: {
                    self.showJoin.toggle()
                    print("joined group")
                }) {
                    Text("join")
                }
            }.padding()
                .background(Color.white)
                .cornerRadius(15)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(
                Color.black.opacity(0.65)
                    .edgesIgnoringSafeArea(.all)
                    
                    .onTapGesture {
                        withAnimation{
                            self.showJoin.toggle()
                        }
                }
        )
    }
}

struct joinMenu_Previews: PreviewProvider {
    static var previews: some View {
        joinMenu(showJoin: .constant(false))
    }
}
