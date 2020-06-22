//
//  resultsPreview.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI

struct resultsPreview: View {
    let images: [String] = ["marilyn", "barack", "silhouette","marilyn", "barack", "silhouette","marilyn", "barack", "silhouette","marilyn", "barack", "silhouette"]
//    @State var showSheet: Bool = false
    @State var showLoserPage: Bool = false
    @State var detailsOpen = false
    var body: some View {
        
        VStack(alignment: .leading){
            ScrollView(.horizontal){
                HStack(spacing: -15){
                    // this should be listening to the db for updates
                    ForEach(images, id: \.self) { image_name in
                        Image(image_name).resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .cornerRadius(100)
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
        }
    }
}

struct resultsPreview_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            resultsPreview(showLoserPage: false)
        }
    }
}
