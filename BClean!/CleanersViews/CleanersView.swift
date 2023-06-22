//
//  CleanersView.swift
//  BClean!
//
//  Created by Julien Le ber on 02/02/2023.
//

import SwiftUI

struct CleanersView: View {
    @State var isLinkActive:Bool = false
    @ObservedObject var UserManager = userManager.shared
    @State var currUser: user?
    @State private var cleaners: [cleaner] = (userManager.shared.currentUser?.cleaners ?? [])
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color(.white)]), startPoint: .top, endPoint: .bottom)))
                        .ignoresSafeArea()
                        .frame(width: .infinity,height: 100,alignment: .top)
                    Text("Your Cleaners")
                        .font(.custom("AirbnbCereal_W_XBd", size: 32))
                        .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                        .padding(.top,50)
                    
                }
                Text("Here you can change every information relative to your Cleaners and invite them to join your them for them to enter their informations")
                    .font(.custom("AirbnbCereal_W_Lt", size: 10))
                    .padding(.horizontal)
                    .padding(.top,5)
                HStack{
                    Spacer()
                    NavigationLink(destination : AddCleanerView(),isActive: $isLinkActive) {
                        Button {
                            print("dans cleaner----")
                            isLinkActive = true
                        } label: {
                            Text("Add cleaner")
                        }.buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient")).padding(.trailing,5)
                    }
                    
                }
                ScrollView {
                    if !isLinkActive && update_view(){
                        VStack {
                            if (userManager.shared.currentUser != nil){
                                if (userManager.shared.currentUser!.cleaners.count > 0 ){
                                    ForEach(userManager.shared.currentUser!.cleaners, id: \.self) { clean in
                                        CleanerPresentation(cleanerName: clean.name, cleanerEmail: clean.email, cleanerLanguage: clean.language, cleanerPay: "To come later",image: clean.picture).padding(.vertical,0)
                                    }
                                }
                                else{Text("Nothing Here")}
                            }
                        }
                    }
                }
                Spacer()
            }
        }.onAppear{update_view()}
    }
    private func update_view() -> Bool{
        cleaners = userManager.shared.currentUser?.cleaners ?? []
        return true
    }
}

struct CleanersView_Previews: PreviewProvider {
    static var previews: some View {
        CleanersView()
    }
}
