//
//  SubscribeView.swift
//  BClean!
//
//  Created by Julien Le ber on 24/06/2023.
//

import SwiftUI
import RevenueCat
struct SubscribeView: View {
    @State private var showAlert = false
    @State private var titleAlert = ""
    @State private var contentAlert = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ScrollView {
            ZStack {
                VStack{
                    Spacer()
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
                    }.padding(.top,40)
                    Button {
                        if userManager.shared.currentUser?.Subscribe != nil{
                            titleAlert = "You already subscribed"
                            contentAlert = "you can't subscribe twice"
                            showAlert = true
                        }
                        else{subscribe_infinite_properties()}
                    } label: {
                        card_large_business()
                    }
                    Button {
                        if userManager.shared.currentUser?.Subscribe != nil{
                            titleAlert = "You already subscribed"
                            contentAlert = "you can't subscribe twice"
                            showAlert = true
                        }
                        else{subscribe_5_properties()}
                    } label: {
                        card_medium_business()
                            .padding(.top,10)
                    }
                    Button {
                        if userManager.shared.currentUser?.Subscribe != nil{
                            titleAlert = "You already subscribed"
                            contentAlert = "you can't subscribe twice"
                            showAlert = true
                        }
                        else{subscribe_3_properties()}
                    } label: {
                        card_small_business()
                            .padding(.top,10)
                    }.padding(.bottom,100)
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text(titleAlert),message: Text(contentAlert),dismissButton: .cancel())
                }.background(Color("dark-green-gradient")).ignoresSafeArea(.all)
            }
        }.ignoresSafeArea(.all)
        .navigationBarTitle("")
        .navigationBarHidden(true)

    }
    func subscribe_3_properties(){
        Purchases.shared.getOfferings { offerings, error in
            if let packages = offerings?.current?.availablePackages{
                Purchases.shared.purchase(package: packages.first!) { transac, purchaserInfo, error, userCancelled in
                    if error != nil {
                        //Handle error
                        titleAlert = "PURCHASE FAILED"
                        contentAlert = "Error : \(error!.localizedDescription)"
                        showAlert.toggle()
                    }
                    if purchaserInfo?.entitlements["3.properties"]?.isActive == true{
                        //purchase complete
                        titleAlert = "PURCHASE SUCCEDED"
                        contentAlert = "Thank you for joining us"
                        userManager.shared.currentUser?.Subscribe = "3.properties"
                        showAlert.toggle()
                    }
                }
            }
        }
    }
    func subscribe_5_properties(){
        Purchases.shared.getOfferings { offerings, error in
            if let packages = offerings?.current?.availablePackages{
                Purchases.shared.purchase(package: packages[1]) { transac, purchaserInfo, error, userCancelled in
                    if error != nil {
                        //Handle error
                        titleAlert = "PURCHASE FAILED"
                        contentAlert = "Error : \(error!.localizedDescription)"
                        showAlert.toggle()
                    }
                    if purchaserInfo?.entitlements["5.properties"]?.isActive == true{
                        //purchase complete
                        titleAlert = "PURCHASE SUCCEDED"
                        contentAlert = "Thank you for joining us"
                        userManager.shared.currentUser?.Subscribe = "5.properties"
                        showAlert.toggle()
                    }
                }
            }
        }
    }
    func subscribe_infinite_properties(){
        Purchases.shared.getOfferings { offerings, error in
            if let packages = offerings?.current?.availablePackages{
                Purchases.shared.purchase(package: packages[2]) { transac, purchaserInfo, error, userCancelled in
                    if error != nil {
                        //Handle error
                        titleAlert = "PURCHASE FAILED"
                        contentAlert = "Error : \(error!.localizedDescription)"
                        showAlert.toggle()
                    }
                    if purchaserInfo?.entitlements["infinite.properties"]?.isActive == true{
                        //purchase complete
                        titleAlert = "PURCHASE SUCCEDED"
                        contentAlert = "Thank you for joining us"
                        userManager.shared.currentUser?.Subscribe = "infinite.properties"
                        showAlert.toggle()
                    }
                }
            }
        }
    }
}

struct SubscribeView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribeView()
    }
}

struct card_small_business:View{
    //@Binding var icon:String
    var body: some View{
        VStack{
            ZStack {
                Rectangle()
                    .fill(Color("red-gradient"))
                    .frame(width: .infinity,height: 200)
                    .cornerRadius(50)
                HStack{
                    Image(systemName: "star")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.leading,20)
                    Spacer()
                    VStack{
                        Text("Small business")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.custom("AirbnbCereal_W_Bd", size: 25))
                            .padding(.bottom,2)
                        Text("Three properties usable in app")
                            .foregroundColor(.white)
                        Divider()
                        Text("9.99€ / month")
                            .font(.custom("AirbnbCereal_W_Bd", size: 25))
                            .foregroundStyle(.white)
                        Spacer()
                    }.padding(.top,50)
                    Spacer()
                }
            }.padding(.horizontal,30)
        }
    }
}
struct card_medium_business:View{
    //@Binding var icon:String
    var body: some View{
        VStack{
            ZStack {
                Rectangle()
                    .fill(Color("orange-gradient"))
                    .frame(width: .infinity,height: 200)
                    .cornerRadius(50)
                HStack{
                    Image(systemName: "star.leadinghalf.filled")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.leading,20)
                    Spacer()
                    VStack{
                        Text("Medium business")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.custom("AirbnbCereal_W_Bd", size: 25))
                            .padding(.bottom,2)
                        Text("Five properties usable in app")
                            .foregroundColor(.white)
                        Divider()
                        Text("14.99€ / month")
                            .font(.custom("AirbnbCereal_W_Bd", size: 25)).foregroundStyle(.white)
                        Spacer()
                    }.padding(.top,50)
                    Spacer()
                }
            }.padding(.horizontal,30)
        }
    }
}
struct card_large_business:View{
    //@Binding var icon:String
    var body: some View{
        VStack{
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom))
                
                    .frame(width: .infinity,height: 200)
                    .cornerRadius(50)
                HStack{
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.leading,20)
                    Spacer()
                    VStack{
                        Text("Large business")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.custom("AirbnbCereal_W_Bd", size: 25))
                            .padding(.bottom,2)
                        Text("Ten properties usable in app")
                            .foregroundColor(.white)
                        Divider()
                        Text("19.99€ / month")
                            .font(.custom("AirbnbCereal_W_Bd", size: 25))
                            .foregroundStyle(.white)
                        Spacer()
                    }.padding(.top,50)
                    Spacer()
                }
            }.padding(.horizontal,30)
            
        }
    }
}


