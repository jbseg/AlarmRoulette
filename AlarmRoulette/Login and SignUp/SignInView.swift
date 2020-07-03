//
//  SignInView.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct SignInView : View {
      
      @State var email: String = ""
      @State var password: String = ""
      @State var loading = false
      @State var error = false
      
      @EnvironmentObject var user: User
      
      func signIn () {
            loading = true
            error = false
            user.signIn(email: email, password: password) { (result, error) in
                  self.loading = false
                  if error != nil {
                        print("failed login")
                        self.error = true
                  } else {
                        print("logged in!")
                  }
            }
      }
      
      var body: some View {
            VStack {
                  Spacer()
                  Spacer()
                  Image(systemName: "alarm")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                  
                  Spacer()
                  
                  VStack(alignment: .leading){
                        VStack(alignment: .leading){
                              Text("Email")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.init(.label)
                                          .opacity(0.75))
                              TextField("Enter Your Email", text: $email)
                              //                .padding()
                              Divider()
                        }.padding(.bottom, 15)
                        
                        VStack(alignment: .leading){
                              Text("Password")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.init(.label)
                                          .opacity(0.75))
                              SecureField("Enter Your Password", text: $password)
                              Divider()
                        }
                        if (error) {
                              Text("username or password is wrong").foregroundColor(.red)
                        }
                        
                  }
                  .padding(.horizontal, 6)
                  
                  Button(action: signIn) {
                        Text("Sign in")
                              .font(.system(size: 20))
                              .foregroundColor(.white)
                              .padding(.horizontal, 60)
                              .padding(.vertical, 15)
                              .background(Color.blue)
                              .cornerRadius(25)
                        
                  }
                  .padding(.top, 20)
                  Spacer()
                  Spacer()
            }
            .padding()
      }
}

struct SignInView_Previews: PreviewProvider {
      static var previews: some View {
            SignInView().environmentObject(User())
      }
}
