//
//  CalendarView.swift
//  BClean!
//
//  Created by Julien Le ber on 29/12/2022.
//


import SwiftUI
import Alamofire
import Foundation
import OpenAISwift
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
    @State var sheetShowed:Bool = false
    private var formatter = DateFormatter()
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
                    sheetShowed = true
                }, label: {
                    Text("Notify")
                }).buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient"))
                    .padding(.trailing,5)
            }.padding(.vertical,10)
                .sheet(isPresented: $sheetShowed) {
                    VStack {
                        Spacer()
                        Text("Sending a message to the cleaners")
                            .font(.custom("AirbnbCereal_W_XBd", size: 22))
                            .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                            .padding(.top,0)
                        Spacer()
                        Text("Default Text message :")
                            .font(.custom("AirbnbCereal_W_XBd", size: 16))
                            .foregroundColor(.gray)
                            .padding(.bottom,15)
                        Text("This is a message from {user_name}, you have a cleaning to do on {menage_endDate} at {house_name}. Please contact your employer if you are available.")
                            .font(.custom("AirbnbCereal_W_Lt", size: 11))
                            .foregroundColor(.gray)
                        Spacer()
                        if let events = userManager.shared.currentUser?.eventStore{
                            ForEach(events, id: \.self) { menage in
                                if menage.cleaner != nil {
                                    Text("Cleaning on : \(formatter.string(from: menage.endDate!)) with \(menage.cleaner!.name) at \(menage.property.name)")
                                        .foregroundColor(.gray)
                                        .font(.custom("AirbnbCereal_W_Lt", size: 11))
                                }
                            }
                        }
                        Spacer()
                        Button {
                            sendMessage()
                            sheetShowed = false
                        } label: {
                            Text("Confirm")
                        }.buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient"))

                        
                        Spacer()
                    }.presentationDetents([.medium, .large])
                }
            fsCalendar()
            Spacer()
        }.onAppear{
            self.formatter.dateFormat = "yyyy-MM-dd"
        }
    }
    
    
    func sendMessage(){
        formatter.dateFormat = "yyyy-MM-dd"
        let accountSID="ACeea13e8605d11cb4b544957e63507a4e"
        let authToken="17eba0d7a645121336d24df0d7be73c7"
        let fromPhoneNumber = "+12708106567"
        let gpt3Endpoint = "https://api.openai.com/v1/engines/davinci-codex/completions"
        if let events = userManager.shared.currentUser?.eventStore{
            events.forEach { menage in
                if menage.cleaner != nil {
                    var toPhoneNumber = "\(menage.cleaner!.phone)"
                    let message = "This is an automatic message from \(userManager.shared.currentUser!.name), you have a cleaning to do on \(formatter.string(from: menage.endDate!)) at \(menage.property.name). Please contact your employer if you are available."
                    
                    toPhoneNumber = "\(menage.cleaner?.phone)"
                    let parameters: [String: Any] = [
                        "From": fromPhoneNumber,
                        "To": toPhoneNumber,
                        "Body": message
                    ]
                    let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
                    // Define the HTTP basic authentication header
                    let credential = Data("\(accountSID):\(authToken)".utf8).base64EncodedString()
                    let headers: HTTPHeaders = [
                        "Authorization": "Basic \(credential)"
                    ]
                    AF.request(url, method: .post, parameters: parameters)
                        .authenticate(username: accountSID, password: authToken)
                        .responseJSON { response in
                          debugPrint(response)
                      }
                }
            }
        }

    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        tabView()
    }
}
