//
//  AlarmHistory.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/22/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

class HistoryInfo: Identifiable {
    var user_images: [Data]
    var loser_image: Data
    var donation: Float
    init (user_images: [Data], loser_image: Data, donation: Float) {
        self.user_images = user_images
        self.loser_image = loser_image
        self.donation = donation
    }
}

struct HistoryRow: View {
    var historyInfo: HistoryInfo
    var body: some View {
        HStack{
            ScrollView(.horizontal){
                HStack(spacing: -15){
                    ForEach(self.historyInfo.user_images, id: \.self) { user_image in
                        Image(uiImage: UIImage(data: user_image)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .cornerRadius(100)
                    }
                }
            }
            Spacer()
            ZStack{
                Image(uiImage: UIImage(data: self.historyInfo.loser_image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
                .cornerRadius(100)
                Text(String(historyInfo.donation))
            }
        }
    }
}


struct AlarmHistory: View {
    @State var HistoryInfoList = [HistoryInfo]()
    @EnvironmentObject var user: User
    var body: some View {
        VStack{
            if !HistoryInfoList.isEmpty{
                ScrollView{
                    List(HistoryInfoList) { historyInfo in
                        HistoryRow(historyInfo: historyInfo)
                    }
                }
            }else {
                Text("No alarm history yet :)")
            }
        }.onAppear(perform: InitHistory)
    }
    
    func InitHistory(){
        // get all the alarms for user and all the other info
        // to populate the HistoryInfo
    }
}

struct AlarmHistory_Previews: PreviewProvider {
    static var previews: some View {
        AlarmHistory()
    }
}
