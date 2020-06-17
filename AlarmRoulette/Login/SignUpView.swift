//
//  SignUpView.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/17/20.
//  Copyright © 2020 Buena. All rights reserved.
//

import SwiftUI
import Firebase

struct SignUpView : View {
    
    @State var email: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    @State var error_msg = ""
    @State var showImagePicker = false
    @State var image : Data = .init(count: 0)
    
    @EnvironmentObject var user: User
    
    func signUp () {
        loading = true
        error = false
        // check if the image is too large for google images
//        if self.image.count > 1000000 {
//            error = true
//            self.error_msg = "image is too large"
//            return
//        }
        user.signUp(email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                print("failed login \(error?.localizedDescription)")
                self.error = true
                self.error_msg = "something went wrong"
            } else {
                // create the user in the db
                let imageid = UUID.init().uuidString
                print("image bytes: \(self.image)")
                Firestore.firestore().collection("users").document(result!.user.uid).setData(["firstName": self.firstName, "lastName": self.lastName, "imageid": imageid]) { (err) in
                    if err != nil {
                        print("error uploading the image: \((err?.localizedDescription)!)")
                        return
                    }
                }
                let storage = Storage.storage()
                let uploadMetaData = StorageMetadata.init()
                uploadMetaData.contentType = "image/jpeg"
                storage.reference(withPath: "profile_img/\(imageid).jpg").putData(self.image, metadata: uploadMetaData) {
                    (downloadMetaData, error) in
                    if error != nil {
                        print("error uploading profile image")
                        return
                    }
                    print("successfully upload profile image \(String(describing: downloadMetaData))")
                }
                print("sign up successful!")
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .center){
                HStack{
                    if self.image.count != 0 {
                        Button(action: {
                            self.showImagePicker.toggle()
                        }) {
                            Image(uiImage: UIImage(data: self.image)!)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                    } else {
                        Button(action: {
                            self.showImagePicker.toggle()
                        }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        }
                    }
                    Text("Profile Picture")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(Color.init(.label)
                        .opacity(0.75))
                }.padding()
                HStack(spacing: 40){
                    VStack(alignment: .leading){
                        Text("First Name")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.init(.label)
                                .opacity(0.75))
                        TextField("First Name", text: $firstName)
                        Divider()
                    }.padding(.bottom, 15)
                    VStack(alignment: .leading){
                        Text("Last Name")
                            .font(.headline)
                            .fontWeight(.light)
                            .foregroundColor(Color.init(.label)
                                .opacity(0.75))
                        TextField("Last Name", text: $lastName)
                        Divider()
                    }.padding(.bottom, 15)
                }
                VStack(alignment: .leading){
                    Text("Email")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(Color.init(.label)
                            .opacity(0.75))
                    TextField("Enter Your Email", text: $email)
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
                    Text(self.error_msg).foregroundColor(.red)
                }
                
                
            }
            .padding(.horizontal, 6)
            
            Button(action: signUp) {
                Text("Sign Up")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(.horizontal, 60)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(25)
                
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            NavigationLink(destination: SignInView()) {
                Text("already have an account? Sign in")
            }
            .foregroundColor(.blue)
        }
        .sheet(isPresented: self.$showImagePicker, content: {
            ImagePicker(show: self.$showImagePicker, image: self.$image)
        })
            .padding()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(User())
    }
}

