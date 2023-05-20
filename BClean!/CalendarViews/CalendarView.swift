//
//  CalendarView.swift
//  BClean!
//
//  Created by Julien Le ber on 29/12/2022.
//

import SwiftUI

struct tabView: View{
    var body: some View{
        TabView{
            CalendarViews()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            HouseView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Properties")
                }
            CleanersView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Cleaners")
                }
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }.navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct CalendarViews: View {
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color(.white)]), startPoint: .top, endPoint: .bottom)))
                    .ignoresSafeArea()
                    .frame(width: .infinity,height: 100,alignment: .top)
                Text("Your Calendar")
                    .font(.custom("AirbnbCereal_W_XBd", size: 32))
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                    .padding(.top,0)
                
            }
            Text("Simply drag and drop the new reservations onto a cleaner. To have more information about a reservation, simply tap on it. ")
                .font(.custom("AirbnbCereal_W_Lt", size: 10))
                .padding(.horizontal)
                .padding(.top,0)
            HStack {
                GradientStrokeButton(text: "By Weeks")
                    .padding(.leading,5)
                Button {
                    
                } label: {
                    Text("By month")
                }.buttonStyle(GradientBackgroundButton(color1: "orange-gradient", color2: "red-gradient"))

                Spacer()
                Button(action: {
                    userManager.shared.currentUser?.print_properties()
                    print("--|--")
                    userManager.shared.currentUser?.print_events()
                }, label: {
                    Text("Notify")
                }).buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient"))
                    .padding(.trailing,5)
            }.padding(.vertical,10)
            fsCalendar()
            Spacer()
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        tabView()
    }
}
