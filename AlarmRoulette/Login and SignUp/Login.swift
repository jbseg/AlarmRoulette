//
//  Login.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct Login: View {
      var body: some View {
            NavigationView{
                  VStack{
                        SignUpView()
                  }
            }
      }
}

struct Login_Previews: PreviewProvider {
      static var previews: some View {
            Login()
      }
}
