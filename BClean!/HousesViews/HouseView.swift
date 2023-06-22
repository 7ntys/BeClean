//
//  HouseView.swift
//  BClean!
//
//  Created by Julien Le ber on 02/02/2023.
//

import SwiftUI

struct HouseModel{
    let id:String = UUID().uuidString
    let name:String
    let address:String
    let SpecialComment:String
    let preferredCleaner:String
    let cost:Int
    let Image:Image
}

class HouseViewModel: ObservableObject{
    @Published var houseArray:[HouseModel] = []
    
}


struct HouseView: View {
    @State var addHouse:Bool = false
    @ObservedObject var UserManager = userManager.shared
    @State var currUser: user?
    @State var properties:[house] = (userManager.shared.currentUser?.properties ?? [])
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color(.white)]), startPoint: .top, endPoint: .bottom)))
                        .ignoresSafeArea()
                        .frame(width: .infinity,height: 100,alignment: .top)
                    Text("Your Properties")
                        .font(.custom("AirbnbCereal_W_XBd", size: 32))
                        .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                        .padding(.top,50)
                    
                }
                Text("Here you can change every information relative to your properties and add some automated comment and preferred cleaner.")
                    .font(.custom("AirbnbCereal_W_Lt", size: 10))
                    .padding(.horizontal)
                    .padding(.top,5)
                HStack{
                    Spacer()
                    NavigationLink(destination: AddHouseView(), isActive: $addHouse) {
                        Button {
                            addHouse = true
                        } label: {
                            Text("Add house")
                        }.buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient")).padding(.trailing,5)
                    }

                }
                ScrollView {
                    VStack {
                        if !addHouse && update_view(){
                            if (userManager.shared.currentUser != nil){
                                if (userManager.shared.currentUser!.properties.count > 0 ){
                                    ForEach(userManager.shared.currentUser!.properties, id: \.self) { maison in
                                        HousePresentation(houseName: maison.name, houseAddress: maison.address, houseDefaultCleaningTime: maison.clean_time, housePrefferredCleaner: "to come later",image: maison.picture)
                                    }
                                }
                                else{Text("Nothing Here")}
                            }
                        }
                    }
                }
                Spacer()
            }
        }.onAppear{
            update_view()
            
        }
    }
    private func update_view() -> Bool{
        properties = userManager.shared.currentUser?.properties ?? []
        return true
    }
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView()
    }
}
