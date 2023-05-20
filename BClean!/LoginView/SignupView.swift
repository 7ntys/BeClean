//
//  SignupView.swift
//  BClean!
//
//  Created by Julien Le ber on 29/12/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
struct SignupView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var email:String = ""
    @State var password:String = ""
    @State var isLinkActive = false
    @State var name = ""
    @State var firstname = ""

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
                    TextZone(value: $name, defaultText: "Enter your surname").padding(.bottom,10)
                    TextZone(value: $firstname, defaultText: "Enter your firstname").padding(.bottom,10)
                    TextZone(value: $email, defaultText: "Enter your Email").padding(.bottom,10)
                    TextZone(value: $password, defaultText: "Enter your password").padding(.bottom,40)
                    Button {
                        if email != "" && password != "" && password.count > 4{
                            register()
                            presentationMode.wrappedValue.dismiss()
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
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "name": firstname,
            "surname": name,
            "email": email,
            "country" : "france"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        }
    }

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
