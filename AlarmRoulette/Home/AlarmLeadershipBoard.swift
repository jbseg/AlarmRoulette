//
//  AlarmHistory.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/22/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI


class LeadershipBoardUserInfo: Identifiable {
    var first_name: String
    var user_image: Data
    var donation: Float
    init (first_name: String, user_image: Data, donation: Float) {
        self.first_name = first_name
        self.user_image = user_image
        self.donation = donation
    }
}


struct AlarmLeadershipBoard: View {
    var LB_Infos = [LeadershipBoardUserInfo]()
//    @EnvironmentObject var user: User
    var body: some View {
        VStack{
            if !LB_Infos.isEmpty{
                ScrollView{
                    List(self.LB_Infos) { userInfo in
                        HStack {
                            Image(uiImage: UIImage(data: userInfo.user_image)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .cornerRadius(100)
                            Text(userInfo.first_name)
                            Spacer()
                            Text("$\(String(format: "%.2f", userInfo.donation))")
                        }
                    }
                }
            } else {
                Text("loading...")
            }
        }.onAppear(perform: InitBoard)
    }
    
    func InitBoard(){
        // initialize the LB_Infos with LeaderShipBoardUserInfos
        // sort them based on their donation amount
    }
}

struct AlarmHistory_Previews: PreviewProvider {
    static var previews: some View {
        AlarmLeadershipBoard()
    }
}
