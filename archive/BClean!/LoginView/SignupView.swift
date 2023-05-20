//
//  SignupView.swift
//  BClean!
//
//  Created by Julien Le ber on 29/12/2022.
//

import SwiftUI
import Firebase
struct SignupView: View {
    @State var email:String = ""
    @State var password:String = ""
    @State var isLinkActive = false
    @State var name = ""

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
                        .frame(width: 200,height: 200)
                }.padding(.top,20)
                
                VStack {
                    Spacer()
                    TextZone(value: $name, defaultText: "Enter your full name").padding(.bottom,10)
                    TextZone(value: $email, defaultText: "Enter your Email").padding(.bottom,10)
                    TextZone(value: $password, defaultText: "Enter your password").padding(.bottom,40)
                    Button {
                        if email != "" && password != "" && password.count > 4{
                            register()
                        }
                    } label: {
                        Text("Sign Up")
                    }.buttonStyle(CustomButtonStyle())

                    Spacer()
                    
                }.padding()
                Spacer()
                
                
            }
            .background((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
            
        }
    }
    func register(){
        Auth.auth().createUser(withEmail: email, password: password)
        }
    }

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
