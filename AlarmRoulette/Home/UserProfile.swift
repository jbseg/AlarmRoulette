//
//  UserProfile.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    //    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var user: User
    var body: some View {
        VStack {
            if user.image != nil {
                Image(uiImage: UIImage(data: user.image!)!)
                    .resizable()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 1))
            }
            if user.uid != nil {
                Text("uid: \(user.uid!)")
            }
            if user.firstName != nil{
                Text("first name: \(user.firstName!)")
            }
            if user.lastName != nil{
                Text("last name: \(user.lastName!)")
                Text("email: \(user.email!)")
            }
            Button(action: signOut, label: {
                Text("Log out")
            })
        }
    }
    
    func signOut () {
        if user.signOut() {
            print("successfully signed out")
        } else {
            print("failed to sign out")
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile().environmentObject(User())
    }
}
