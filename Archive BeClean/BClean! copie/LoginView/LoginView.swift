//
//  LoginView.swift
//  BClean!
//
//  Created by Julien Le ber on 29/12/2022.
//

import SwiftUI
import Firebase
struct LoginView: View {
    @State var email:String = ""
    @State var password:String = ""
    @State var isLinkActive = false
    @State var isLoginActive = false
    @State var isLoggedIn = false
    var body: some View {
        if isLoggedIn{
            tabView()
        }
        else{
            loginView
        }
    }
    var loginView: some View{
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
                    TextZone(value: $email, defaultText: "Enter your Email").padding(.bottom,10)
                    TextZone(value: $password, defaultText: "Enter your password").padding(.bottom,40)
                    NavigationLink(isActive: $isLoginActive) {
                        tabView()
                    } label: {
                        Button {
                            //TO DO : Logic behind sign in
                            login()
                        } label: {
                            Text("Sign In")
                        }.buttonStyle(CustomButtonStyle())
                    }



                    HStack {
                        Text("You don't have an account ?")
                            .foregroundColor(.white)
                            .font(.custom("AirbnbCereal_W_Bk", size: 16))
                            .padding(0)
                        NavigationLink {
                            SignupView()
                        } label: {
                            Text("Signup Now !")
                                .foregroundColor(.white)
                                .font(.custom("AirbnbCereal_W_Bd", size: 16))
                                .padding(0)
                                .background(.opacity(0))
                        }
                    }
                    Spacer()
                    
                }.padding()
                Spacer()
                
                
            }
            .background((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
            .onAppear{
                Auth.auth().addStateDidChangeListener {auth, user in
                    if user != nil{
                        isLoggedIn.toggle()
                    }
                }
            }
            
        }
    }
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
            else {
                isLoginActive = true
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
