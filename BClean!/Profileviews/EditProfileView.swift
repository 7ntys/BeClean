//
//  EditProfileView.swift
//  BClean!
//
//  Created by Julien Le ber on 02/02/2023.
//

import SwiftUI
import iPhoneNumberField
import FirebaseAuth
struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var name:String = ""
    @State var email:String = ""
    @State var password:String = ""
    @State var phonenumber:String = ""
    @State var isPresentedConfirm:Bool = false
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color(.white)]), startPoint: .top, endPoint: .bottom)))
                    .ignoresSafeArea()
                    .frame(width: .infinity,height: 100,alignment: .top)
                Text("Your Profile")
                    .font(.custom("AirbnbCereal_W_XBd", size: 32))
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                    .padding(.top,50)
            }
            Text("Here you can change every information relative to your account")
                .font(.custom("AirbnbCereal_W_Lt", size: 10))
                .padding(.horizontal)
                .padding(.top,5)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 12,height: 20)
                        .foregroundColor(.gray)
                Spacer()
                }.padding(.leading,40)
                    .padding(.top)
            }
            ZStack {
                Circle()
                    .frame(width: 103,height: 103)
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                Image("profile-picture-sample")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 50,height: 50)
                    .foregroundColor(.white)
            }.padding(.bottom)
            
            minimalistTextField(link: $name, placeholderText: "Your name")
            ZStack {
                Rectangle()
                    .frame(width: 316,height: 38)
                    .foregroundColor(.white)
                    .padding(.bottom, 1.0)
                    .background(Color.black)
                iPhoneNumberField("Your phone number",text: $phonenumber)
                    .flagHidden(false)
                    .flagSelectable(true)
                    .frame(maxWidth: 316,alignment: .center)
                .font(.custom("AirbnbCereal_W_Bk", size: 15))
            }
            Button {
                isPresentedConfirm = true
            } label: {
                ZStack {
                    Rectangle()
                        .frame(width: 316,height: 38)
                        .foregroundColor(.white)
                        .padding(.bottom, 1.0)
                        .background(Color.black)
                    Text("Reset Password")
                        .font(.custom("AirbnbCereal_W_Bk", size: 15))
                        .foregroundColor(.red)
                        .frame(maxWidth: 316,alignment: .leading)
                }
            }
            .confirmationDialog("Are you sure?",
              isPresented: $isPresentedConfirm) {
              Button("Reset Password ?", role: .destructive) {resetPassword()}
            } message: {
              Text("You will recieve an email with a new password")
            }
            Spacer()
        }.navigationBarTitle("")
        .navigationBarHidden(true)
    }
    func resetPassword(){
        @State var isPresented = true
        let auth = Auth.auth()
        if userManager.shared.currentUser != nil {
            if !userManager.shared.currentUser!.email.isEmpty{
                auth.sendPasswordReset(withEmail: userManager.shared.currentUser!.email){ error in
                    if let error = error{
                        alert("There is an error : \(error.localizedDescription)", isPresented: $isPresented) {
                            Button {
                                isPresented = false
                            } label: {
                                Text("Ok")
                            }

                        }
                        return
                    }
                    else{
                        alert("An email has been sent", isPresented: $isPresented) {
                            Button {
                                isPresented = false
                            } label: {
                                Text("Ok")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
