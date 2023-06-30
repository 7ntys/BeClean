//
//  CleanerPresentationView.swift
//  BClean!
//
//  Created by Julien Le ber on 23/06/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
struct CleanerPresentation:View{
    @State var worker:cleaner
    @State var isAlertPresented:Bool = false
    var body: some View{
        ZStack {
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: .infinity, height:79)
                    .border(.black)
                    .padding(.vertical,0)
            }
            HStack{
                ZStack {
                    Circle()
                        .frame(width: 62,height: 103)
                        .foregroundColor(.black)
                    if worker.picture != nil {
                        Image(uiImage: worker.picture!)
                            .resizable()
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)
                    }
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
                        Text(worker.name)
                            .font(.custom("AirbnbCereal_W_Bd", size: 13))
                            .padding(.bottom,0)
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(worker.email)
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
                        Text(worker.language)
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
                        Text("Phone")
                            .font(.custom("AirbnbCereal_W_Bd", size: 10))
                            
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Text(worker.phone)
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
                        Text("Delete Cleaner")
                            .font(.custom("AirbnbCereal_W_Bd", size: 6))
                            
                    }
                    Button {
                        isAlertPresented = true
                    } label: {
                        Image(systemName: "trash")
                }.buttonStyle(GradientBackgroundButton(color1: "red-gradient", color2: "red-gradient"))
                    Spacer()
                }.alert("Are you sure you want to delete this cleaner", isPresented: $isAlertPresented) {
                    Button("OK", role: .destructive) {delete_cleaner()}
                    Button("Cancel",role:.cancel){isAlertPresented = false}
                }
                    

                Spacer()
            }.frame(width: .infinity,height: 79)
        }
    }
    private func delete_cleaner(){
        //Delete cleaner assignation to events :
        userManager.shared.currentUser?.eventStore.forEach({ reservation in
            if reservation.cleaner?.id == worker.id{reservation.cleaner = nil}
        })
        
        //Delete cleaner assignation to events in DB :
        let db = Firestore.firestore()
        let collectionPath = "users/\(userManager.shared.currentUser!.id)/events" // Replace with the actual path to your collection

        db.collection(collectionPath).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No documents found.")
                return
            }
            
            for document in snapshot.documents {
                let documentRef = document.reference
                
                var data = document.data()
                if let cleaner = data["cleaner"] as? String, cleaner == "\(worker.id)" {
                    data.removeValue(forKey: "cleaner") // Remove the "cleaner" attribute from the document data
                    
                    documentRef.setData(data) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Attribute 'cleaner' removed from document: \(documentRef.documentID)")
                        }
                    }
                }
            }
        }
        
        //Remove cleaner :
        userManager.shared.currentUser?.cleaners = userManager.shared.currentUser!.cleaners.filter(){$0.id != worker.id}
        
        //Remove cleaner from db :
        let documentPath = "users/\(userManager.shared.currentUser!.id)/cleaners/\(worker.id)" // Chemin complet du document que vous souhaitez supprimer

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








