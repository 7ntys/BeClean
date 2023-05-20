//
//  CleanersView.swift
//  BClean!
//
//  Created by Julien Le ber on 02/02/2023.
//

import SwiftUI

struct CleanersView: View {
    @State var isLinkActive:Bool = false
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
                            isLinkActive = true
                        } label: {
                            Text("Add cleaner")
                    }.buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient")).padding(.trailing,5)
                    }

                }
                CleanerPresentation(cleanerName: "Anyssa", cleanerEmail: "anyssa@gmail.com", cleanerLanguage: "French", cleanerPay: "1200€")
                Spacer()
            }
        }
    }
}

struct CleanersView_Previews: PreviewProvider {
    static var previews: some View {
        CleanersView()
    }
}
