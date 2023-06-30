//
//  HousePresentationView.swift
//  BClean!
//
//  Created by Julien Le ber on 23/06/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
struct HousePresentation:View{
    @State var isAlertPresented:Bool = false
    @State var property:house
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }
    var body: some View{
        ZStack {
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: .infinity, height:79)
                .border(.black)}
            HStack{
                ZStack {
                    Circle()
                        .frame(width: 62,height: 103)
                        .foregroundColor(.black)
                    if property.picture != nil {
                        Image(uiImage: property.picture!)
                            .resizable()
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)}
                    else{
                        Text("abreviation")
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)
                    }
                }
                Rectangle()
                    .frame(width: 1)
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(property.name)
                            .font(.custom("AirbnbCereal_W_Bk", size: 13))
                            .padding(.bottom,0)
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(property.address)
                            .font(.custom("AirbnbCereal_W_Bk", size: 10))
                            .padding(.bottom,0)
                        
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.bottom,5)
                        Text(dateFormatter.string(from: property.clean_time))
                            .font(.custom("AirbnbCereal_W_Bk", size: 13))
                            .padding(.bottom,2)
                            .fontWeight(.bold)
                    }
                }
                Rectangle()
                    .frame(width: 1)
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 90,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.top,1)
                        Text("Preferred Cleaner")
                            .font(.custom("AirbnbCereal_W_Bd", size: 10))
                            
                    }
                    Button {
                        
                    } label: {
                        Text("To come later")
                    }.buttonStyle(GradientBackgroundButton(color1: "orange-gradient", color2: "red-gradient"))
                        .frame(width: 100,height: 10)

                    Spacer()
                    
                }
                Rectangle()
                    .frame(width: 1)
                VStack {
                    ZStack{
                        Rectangle()
                            .frame(width: .infinity,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.top,1)
                        Text("Delete House")
                            .font(.custom("AirbnbCereal_W_Bd", size: 6))
                            
                    }
                    Button {
                        isAlertPresented = true
                    } label: {
                        Image(systemName: "trash")
                }.buttonStyle(GradientBackgroundButton(color1: "red-gradient", color2: "red-gradient"))
                    Spacer()
                }.alert("Are you sure you want to delete this house", isPresented: $isAlertPresented) {
                    Button("OK", role: .destructive) {delete_house()}
                    Button("Cancel",role:.cancel){isAlertPresented = false}
                }
                    

                Spacer()
            }.frame(width: .infinity,height: 79)
        }
    }
    private func delete_house(){
        //Suppression events :
        userManager.shared.currentUser?.eventStore = userManager.shared.currentUser!.eventStore.filter(){$0.property != property}
        
        //Suppression Events dans la Database :
        let db = Firestore.firestore()

        // Supprime tous les documents qui ont la valeur "property.id" pour la clé "house"
        db.collection("users").document(userManager.shared.currentUser!.id).collection("events").whereField("house", isEqualTo: property.id).getDocuments { (snapshot, error) in
            if let error = error {
                print("Erreur lors de la récupération des documents : \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("Aucun document correspondant trouvé.")
                return
            }
            
            // Parcours des documents correspondants et suppression
            for document in snapshot.documents {
                let documentID = document.documentID
                
                // Supprime le document correspondant
                db.collection("users").document(userManager.shared.currentUser!.id).collection("events").document(documentID).delete { error in
                    if let error = error {
                        print("Erreur lors de la suppression du document \(documentID) : \(error.localizedDescription)")
                    } else {
                        print("Document \(documentID) supprimé avec succès.")
                    }
                }
            }
        }
        
        //Suppression de la property :
        userManager.shared.currentUser?.properties = userManager.shared.currentUser!.properties.filter(){$0.id != self.property.id}
        
        let documentPath = "users/\(userManager.shared.currentUser!.id)/house/\(property.id)" // Chemin complet du document que vous souhaitez supprimer

        let documentRef = db.document(documentPath)

        documentRef.delete { error in
            if let error = error {
                print("Erreur lors de la suppression du document : \(error.localizedDescription)")
            } else {
                print("Document supprimé avec succès.")
            }
        }
    }
}
struct HousePresentationCalendar:View{
    @State var isAlertPresented:Bool = false
    @State var property:house
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }
    var body: some View{
        ZStack {
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: .infinity, height:79)
                .border(.black)}
            HStack{
                ZStack {
                    Circle()
                        .frame(width: 62,height: 103)
                        .foregroundColor(.black)
                    if property.picture != nil {
                        Image(uiImage: property.picture!)
                            .resizable()
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)}
                    else{
                        Text("abreviation")
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)
                    }
                }
                Rectangle()
                    .frame(width: 1)
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(property.name)
                            .font(.custom("AirbnbCereal_W_Bk", size: 13))
                            .padding(.bottom,0)
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(property.address)
                            .font(.custom("AirbnbCereal_W_Bk", size: 10))
                            .padding(.bottom,0)
                        
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.bottom,5)
                        Text(dateFormatter.string(from: property.clean_time))
                            .font(.custom("AirbnbCereal_W_Bk", size: 13))
                            .padding(.bottom,2)
                            .fontWeight(.bold)
                    }
                }
                Rectangle()
                    .frame(width: 1)
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 90,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.top,1)
                        Text("Preferred Cleaner")
                            .font(.custom("AirbnbCereal_W_Bd", size: 10))
                            
                    }
                    Button {
                        
                    } label: {
                        Text("To come later")
                    }.buttonStyle(GradientBackgroundButton(color1: "orange-gradient", color2: "red-gradient"))
                        .frame(width: 100,height: 10)

                    Spacer()
                    
                }
                Rectangle()
                    .frame(width: 1)
                VStack {
                    ZStack{
                        Rectangle()
                            .frame(width: .infinity,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.top,1)
                        Text("Abreviation")
                            .font(.custom("AirbnbCereal_W_Bd", size: 6))
                            
                    }
                    Button {
                    } label: {
                        Text(property.abreviation)
                            .font(.custom("AirbnbCereal_W_Bd", size: 8))
                }.buttonStyle(GradientBackgroundButton(color1: "red-gradient", color2: "red-gradient"))
                    Spacer()
                }
                    

                Spacer()
            }.frame(width: .infinity,height: 79)
        }
    }
}
