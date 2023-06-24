//
//  LoginView.swift
//  BClean!
//
//  Created by Julien Le ber on 29/12/2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct LoginView: View {
    let db = Firestore.firestore()
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
                        .frame(width: 150,height: 150)
                }.padding(.top,20)
                
                VStack {
                    Spacer()
                    TextZone(value: $email, defaultText: "Enter your Email").padding(.bottom,10)
                    TextZone(value: $password, defaultText: "Enter your password").padding(.bottom,0)
                    HStack {
                        Text("Can't remember your password ?")
                            .foregroundColor(.white)
                            .font(.custom("AirbnbCereal_W_Bk", size: 13))
                            .padding(0)
                        NavigationLink {
                            Reset_Password()
                        } label: {
                            Text("Reset password")
                                .foregroundColor(.white)
                                .font(.custom("AirbnbCereal_W_Bd", size: 13))
                                .padding(0)
                                .background(.opacity(0))
                        }
                    }.padding(.bottom,30)
                    
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
            
        }
    }
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil{
                print(error!.localizedDescription)
            }
            else {
                print("email : \(email)")
                db.collection("users").whereField("email", isEqualTo: email)
                            .getDocuments() { (querySnapshot, err) in
                                if err != nil {
                                    print("Error getting documents: (err)")
                                } else {
                                    //Create user using singleton
                                    for document in querySnapshot!.documents {
                                        let name = document.get("name") as? String ?? ""
                                        let surname = document.get("surname") as? String ?? ""
                                        let documentId = document.documentID
                                        print("créer user : \(name) , \(surname)")
                                        @State var user = user(name: name, surname: surname,id: documentId,email: email.lowercased())
                                        userManager.shared.currentUser = user
                                        //Verif
                                        //Recuperation des cleaners :
                                        update_cleaner(documentId: documentId)
                                        //Recuperation des houses :
                                        update_house(documentId: documentId)
                                        //Loading the events
                                        //A changer !!! 
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                              // Code to be executed after 3 seconds
                                              // Put your desired code here
                                            update_events(documentId: documentId)
                                          }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            test()
                                        }
                                    }
                                }
                        }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    isLoginActive = true
                }
            }
        }
    }
    
    func update_house(documentId:String){
        db.collection("users").document(documentId).collection("house").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Erreur lors de la récupération des documents : \(error.localizedDescription)")
            } else {
                // `querySnapshot` contient tous les documents de la sous-collection
                for document in querySnapshot!.documents {
                    let name = document.get("name") as? String ?? ""
                    let adress = document.get("address") as? String ?? ""
                    let abreviation = document.get("abreviation") as? String ?? ""
                    let clean_time = document.get("clean_time") as? String ?? ""
                    let icalLink = document.get("icalLink") as? String ?? ""
                    let docuId = document.documentID
                    print("Nom complet : \(name) \(adress)")
                    let property = house(name: name, abreviation: abreviation, picture: nil, clean_time: clean_time, address: adress,id:docuId, icalLink: icalLink)
                    
                    // Check if image data exists in the document
                    if let imageData = document.get("image") as? Data {
                        // Convert image data to UIImage
                        if let image = UIImage(data: imageData) {
                            // Update the property's picture property with the retrieved image
                            property.picture = image
                        }
                    }
                    userManager.shared.currentUser?.properties.append(property)
                }
            }
        }
        test()
    }

    func test(){
        userManager.shared.currentUser!.properties.forEach({ house in
            var events = get_infos(url: house.icalLink, property: house)
            events.forEach { thing in
                add_event_db(event: thing)
            }
        })
    }
    func update_cleaner(documentId:String){
        db.collection("users").document(documentId).collection("cleaners").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Erreur lors de la récupération des documents : \(error.localizedDescription)")
            } else {
                // `querySnapshot` contient tous les documents de la sous-collection
                for document in querySnapshot!.documents {
                    let name = document.get("name") as? String ?? ""
                    let email = document.get("email") as? String ?? ""
                    let phone = document.get("phone") as? String ?? ""
                    let language = document.get("language") as? String ?? ""
                    let docuId = document.documentID
                    print("Nom complet : \(name) \(email) \(docuId)")
                    let finalPhone = phone.replacingOccurrences(of: " ", with:"")
                    print("the final phone is \(finalPhone)")
                    let cleaner = cleaner(name: name, phone: finalPhone, email: email, language: language,image: nil,id: docuId)
                    // Check if image data exists in the document
                    if let imageData = document.get("image") as? Data {
                        // Convert image data to UIImage
                        if let image = UIImage(data: imageData) {
                            // Update the property's picture property with the retrieved image
                            cleaner.picture = image
                        }
                    }
                    userManager.shared.currentUser?.add_cleaner(cleaner: cleaner)
                }
            }
        }

    }
    func update_events(documentId:String){
        db.collection("users").document(documentId).collection("events").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Erreur lors de la récupération des documents : \(error.localizedDescription)")
            } else {
                // `querySnapshot` contient tous les documents de la sous-collection
                for document in querySnapshot!.documents {
                    let summary = document.get("summary") as? String ?? ""
                    let endDate = document.get("endDate") as? Timestamp ?? nil
                    let startDate = document.get("startDate") as? Timestamp ?? nil
                    let cleaner = document.get("cleaner") as? String ?? nil
                    let house_id = document.get("house") as? String ?? nil
                    let isConfirmed = document.get("isConfirmed") as? Bool ?? false
                    let docuId = document.documentID
                    var thing:house? = nil
                    var found_cleaner: cleaner? = nil
                    userManager.shared.currentUser?.properties.forEach({ house in
                        if house.id == house_id {
                            thing = house
                        }
                    })
                    userManager.shared.currentUser?.cleaners.forEach({ staff in
                        if staff.id == cleaner{found_cleaner=staff}
                    })
                    
                    let event = Event(summary: summary, location: "", startDate: startDate?.dateValue(), endDate: endDate?.dateValue(), id: docuId, property: thing!,cleaner : found_cleaner, isConfirmed: isConfirmed)
                    userManager.shared.currentUser?.eventStore.append(event)
                }
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
