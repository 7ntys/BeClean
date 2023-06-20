//
//  AddHouseView.swift
//  BClean!
//
//  Created by Julien Le ber on 04/02/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
struct AddHouseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isSheetshowing:Bool=false
    let db = Firestore.firestore()
    @State var selectedImage:UIImage?
    @State var houseName:String = ""
    @State var houseAbbreviation:String = ""
    @State var houseAddress:String = ""
    @State var houseDefaultCleanTime:String = ""
    @State var icalLink:String = ""
    
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color(.white)]), startPoint: .top, endPoint: .bottom)))
                    .ignoresSafeArea()
                    .frame(width: .infinity,height: 100,alignment: .top)
                Text("Add a House")
                    .font(.custom("AirbnbCereal_W_XBd", size: 32))
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                    .padding(.top,50)
                
            }
            Text("Complete the information about your new property in order to poursue your activities")
                .font(.custom("AirbnbCereal_W_Lt", size: 10))
                .padding(.horizontal)
                .padding(.top,5)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    VStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12,height: 20)
                            .foregroundColor(.gray)
                        .padding()
                    }
                }.padding(.leading,20)
                Spacer()
            }
            VStack {
                Button {
                    isSheetshowing.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 103,height: 103)
                            .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                        if selectedImage == nil{
                            Image(systemName: "pencil")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50,height: 50)
                                .foregroundColor(.white)
                                .frame(width: 100,height: 100)
                                .background(Color(.gray))
                            .clipShape(Circle())
                        }
                        else {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100,height: 100)
                                .foregroundColor(.white)
                                .frame(width: 100,height: 100)
                                .background(Color(.gray))
                            .clipShape(Circle())
                        }
                    }.padding(.top,0)
                }

                
                minimalistTextField(link: $houseName, placeholderText: "Name of the property")
                minimalistTextField(link: $houseAbbreviation, placeholderText: "Abbreviation of the property")
                minimalistTextField(link: $houseAddress, placeholderText: "Address of the property")
                minimalistTextField(link: $houseDefaultCleanTime, placeholderText: "Default clean time of the property")
                minimalistTextField(link: $icalLink, placeholderText: "Ical url of the house")
                    .padding(.bottom,20)
                Button {
                    if (validForm()){
                        create_house(selectedImage: selectedImage, houseName: houseName, houseAbbreviation: houseAbbreviation, houseAddress: houseAddress, houseDefaultCleanTime: houseDefaultCleanTime,icalLink: icalLink)
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Confirm")
                        .frame(width: 175,height: 63)
                        .font(.custom("AirbnbCereal_W_Bd", size: 25))
                }.buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient"))
                Spacer()
                
                    
                    
            }
            Spacer()
        }.navigationBarTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $isSheetshowing, content: {ImagePicker(selectedImage: $selectedImage, isSheetShowing: $isSheetshowing)})
        
    }
    func validForm() -> Bool{
        return (!icalLink.isEmpty && houseName.count > 3 && houseAddress.count > 8 && !houseDefaultCleanTime.isEmpty && houseAbbreviation.count < 4)
    }
    
    func create_house(selectedImage:UIImage?,houseName:String,houseAbbreviation:String,houseAddress:String, houseDefaultCleanTime:String ,icalLink:String){
        var ref: DocumentReference? = nil
        let property = house(name: houseName,abreviation: houseAbbreviation,picture: selectedImage,clean_time: houseDefaultCleanTime,address: houseAddress,id:"",icalLink: icalLink)
        let users_db = db.collection("users/\(userManager.shared.currentUser!.id)/house")
        // Convert UIImage to Data
        var add:[String:Any]
        if let imageData = selectedImage?.jpegData(compressionQuality: 0.1){
            add = ["name":property.name,
                   "abreviation":property.abreviation,
                   "clean_time":property.clean_time,
                   "address":property.address,
                    "image":imageData,
                   "icalLink":property.icalLink
            ]
        }
        else{
            add = ["name":property.name,
                    "abreviation":property.abreviation,
                    "clean_time":property.clean_time,
                    "address":property.address,
                   "icalLink":property.icalLink]
        }
        ref = users_db.addDocument(data: add){ error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                // Retrieve the ID of the newly created document
                let documentId = ref?.documentID
                property.id = documentId!
                userManager.shared.currentUser?.add_house(property: property)
                
                userManager.shared.currentUser?.add_events(events: get_infos(url: icalLink, property: property))
            }
        }
        print("This was successfull")
    }
}

struct AddHouseView_Previews: PreviewProvider {
    static var previews: some View {
        AddHouseView()
    }
}
