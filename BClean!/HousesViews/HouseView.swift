//
//  HouseView.swift
//  BClean!
//
//  Created by Julien Le ber on 02/02/2023.
//

import SwiftUI
import RevenueCat
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
    @State var refresh:Bool = false
    @State var currUser: user?
    @State var properties:[house] = (userManager.shared.currentUser?.properties ?? [])
    
    //Alert
    @State var showAlert:Bool = false
    @State var conctentAlert:String = ""
    @State var titleAlert:String = ""
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
                            conditon_abonnement()
                        } label: {
                            Text("Add house")
                        }.buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient")).padding(.trailing,5)
                    }

                }
                ScrollView {
                    VStack {
                        if !addHouse && refresh{
                            let _ = print("La condition est respectée")
                            if (userManager.shared.currentUser != nil){
                                if (userManager.shared.currentUser!.properties.count > 0 ){
                                    ForEach(userManager.shared.currentUser!.properties, id: \.self) { maison in
                                        HousePresentation(property: maison)
                                    }
                                }
                                else{Text("Nothing Here")}
                            }
                        }
                        else{Text("Please wait")}
                    }
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text(titleAlert),message: Text(conctentAlert),dismissButton: .cancel())
                }
                Spacer()
            }
        }.onAppear{
            refresh = false
            update_view()
            refresh = true
        }
    }
    private func update_view(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            properties = userManager.shared.currentUser?.properties ?? []
        }
    }
    private func conditon_abonnement(){
        if  userManager.shared.currentUser?.properties.count == 0 {addHouse = true}
        else if userManager.shared.currentUser?.Subscribe == nil {
            titleAlert = "You need to subscribe in order to have more than one property"
            conctentAlert = "Go to Profile -> Subscribe"
            showAlert = true
        }
        else if userManager.shared.currentUser?.Subscribe == "3.properties" && userManager.shared.currentUser!.properties.count < 3{addHouse = true}
        else if userManager.shared.currentUser?.Subscribe == "3.properties" && userManager.shared.currentUser!.properties.count == 3{
            titleAlert = "You need to upgrade your subscription"
            conctentAlert = "you already have 3 properties"
            showAlert = true
        }
        else if userManager.shared.currentUser!.properties.count < 5 && userManager.shared.currentUser!.Subscribe == "5.properties"{addHouse = true}
        else if userManager.shared.currentUser!.properties.count == 5 && userManager.shared.currentUser!.Subscribe == "5.properties"{
            titleAlert = "You need to upgrade your subscription"
            conctentAlert = "you already have 5 properties"
            showAlert = true
        }
        else if userManager.shared.currentUser!.Subscribe == "infinite.properties"{addHouse = true}
        else{
            titleAlert = "There is an error"
            conctentAlert = "Please contact the owner"
            showAlert = true
        }
    }
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView()
    }
}

class RevenueCatHelp{
    func get_user_info(){
        Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
            if let info = purchaserInfo {
                // Handle the purchaserInfo to determine the user's subscription status
                if info.entitlements["3.properties"]?.isActive == true {
                    print("✅le user est abonné")
                    userManager.shared.currentUser?.Subscribe = "3.properties"
                }
                else if info.entitlements["5.properties"]?.isActive == true {
                    print("✅le user est abonné")
                    userManager.shared.currentUser?.Subscribe = "5.properties"
                }
                else if info.entitlements["infinite.properties"]?.isActive == true {
                    print("✅le user est abonné")
                    userManager.shared.currentUser?.Subscribe = "infinite.properties"
                }
                else{userManager.shared.currentUser?.Subscribe = nil}
                // ...
            } else if let error = error {
                // Handle the error
                print("Error fetching purchaserInfo: \(error.localizedDescription)")
            }
        }
    }
}
