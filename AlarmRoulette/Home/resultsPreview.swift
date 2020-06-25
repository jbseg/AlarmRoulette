//
//  resultsPreview.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct resultsPreview: View {
    var alarmid: String
    @State var user_images: [String] = []
    //    @State var showSheet: Bool = false
    
    @State var showLoserPage: Bool = false
    @State var detailsOpen = false
    var body: some View {
        
        VStack(alignment: .leading){
            if !user_images.isEmpty{
                ScrollView(.horizontal){
                    HStack(spacing: -15){
                        // this should be listening to the db for updates
                        ForEach(user_images, id: \.self) { image_name in
                            Image(image_name).resizable().aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .cornerRadius(100)
                        }
                    }
                }
            }
            NavigationLink(destination: Text("results are here"), isActive: self.$detailsOpen) {
                Text("Result Details")
            }
            Button(action: {
                self.showLoserPage = true
                //                self.showSheet = true
            }) {
                Text("you lost")
            }
        }.onAppear(perform: PreviewNetwork)
    }
    
    func PreviewNetwork(){
        print("querying the db for alarm \(alarmid) and updating the images")
        // @Shane replace with db code to get the images
        user_images = ["marilyn", "barack", "silhouette","marilyn", "barack", "silhouette","marilyn", "barack", "silhouette","marilyn", "barack", "silhouette"]
    }
}

struct resultsPreview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            resultsPreview(alarmid: "asdfasfd", showLoserPage: false).padding(.leading, 20)
        }
    }
}
