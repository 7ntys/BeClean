//
//  Reset Password.swift
//  BClean!
//
//  Created by Julien Le ber on 23/06/2023.
//

import SwiftUI
import FirebaseAuth
struct Reset_Password: View {
    @State var email:String = ""
    @State var isPresented = false
    @State var alertContent:String = ""
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 150,height: 150)
                        .foregroundColor(.white)
                        .opacity(0.3)
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150,height: 150)
                }.padding(.top,20)
                    .padding(.bottom,100)
                
                VStack {
                    TextZone(value: $email, defaultText: "Enter your Email").padding(.bottom,30)
                    Button {
                        reset_pass()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isPresented = true
                        }
                    } label: {
                        Text("Reset password")
                    }.buttonStyle(CustomButtonStyle())
                        .alert(alertContent,isPresented: $isPresented){
                            Button("OK", role: .cancel) {alertContent = "" }
                        }

                    Spacer()
                    
                }.padding()
                Spacer()
                
                
            }
            .background((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
            
        }
    }
    private func reset_pass(){
        let auth = Auth.auth()
                auth.sendPasswordReset(withEmail:email.lowercased()){ error in
                    if let error = error{
                        alertContent =  "\(error.localizedDescription)"
                        return
                    }
                    else{
                        alertContent =  "The email has been sent"
                        return
                    }
                }
    }
}

struct Reset_Password_Previews: PreviewProvider {
    static var previews: some View {
        Reset_Password()
    }
}
