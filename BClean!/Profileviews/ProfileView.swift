//
//  ProfileView.swift
//  BClean!
//
//  Created by Julien Le ber on 02/02/2023.
//

import SwiftUI
import Firebase
struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color(.white)]), startPoint: .top, endPoint: .bottom)))
                        .ignoresSafeArea()
                        .frame(width: .infinity,height: 100,alignment: .top)
                    Text("Your Profile")
                        .font(.custom("AirbnbCereal_W_XBd", size: 32))
                        .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                        .padding(.top,50)
                }
                Text("Here you can change every information relative to your account")
                    .font(.custom("AirbnbCereal_W_Lt", size: 10))
                    .padding(.horizontal)
                    .padding(.top,5)
                ZStack {
                    Circle()
                        .frame(width: 103,height: 103)
                        .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                    Image("profile-picture-sample")
                        .resizable()
                        .frame(width: 100,height: 100)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                }.padding()
                VStack{
                    NavigationLink {
                        EditProfileView()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 316,height: 38)
                                .foregroundColor(.white)
                                .padding(.bottom, 1.0)
                                .background(Color.black)
                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.black)
                                    .padding(.leading)
                                    .padding(.top)
                                Text("Edit Profile")
                                    .foregroundColor(.black)
                                    .font(.custom("AirbnbCereal_W_Lt", size: 15))
                                    .tracking(2)
                                    .padding()
                                    .padding(.top)
                                Spacer()
                            }.frame(width: 316,height: 38)
                        }
                    }.padding(5)
                    NavigationLink {
                        Text("Coming Later")
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 316,height: 38)
                                .foregroundColor(.white)
                                .padding(.bottom, 1.0)
                                .background(Color.black)
                            HStack {
                                Image(systemName: "hand.raised")
                                    .foregroundColor(.black)
                                    .padding(.leading)
                                    .padding(.top)
                                Text("Help Center")
                                    .foregroundColor(.black)
                                    .font(.custom("AirbnbCereal_W_Lt", size: 15))
                                    .tracking(2)
                                    .padding()
                                    .padding(.top)
                                Spacer()
                            }.frame(width: 316,height: 38)
                        }
                    }.padding(5)
                    NavigationLink {
                        TermsAndServicesView()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 316,height: 38)
                                .foregroundColor(.white)
                                .padding(.bottom, 1.0)
                                .background(Color.black)
                            HStack {
                                Image(systemName: "book.closed")
                                    .foregroundColor(.black)
                                    .padding(.leading)
                                    .padding(.top)
                                Text("Terms and Services")
                                    .foregroundColor(.black)
                                    .font(.custom("AirbnbCereal_W_Lt", size: 15))
                                    .tracking(2)
                                    .padding()
                                    .padding(.top)
                                Spacer()
                            }.frame(width: 316,height: 38)
                        }
                    }.padding(5)
                    Button {
                        self.logout()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 316,height: 38)
                                .foregroundColor(.white)
                                .padding(.bottom, 1.0)
                                .background(Color.black)
                            HStack {
                                Image(systemName: "arrow.clockwise.circle")
                                    .foregroundColor(.black)
                                    .padding(.leading)
                                    .padding(.top)
                                Text("Logout")
                                    .foregroundColor(.black)
                                    .font(.custom("AirbnbCereal_W_Lt", size: 15))
                                    .tracking(2)
                                    .padding()
                                    .padding(.top)
                                Spacer()
                            }.frame(width: 316,height: 38)
                        }
                    }.padding(5)
                    NavigationLink {
                        Button {
                            delete_account()
                        } label: {
                            Text("are you sure ?")
                        }.buttonStyle(CustomButtonStyle())
                            

                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 316,height: 38)
                                .foregroundColor(.white)
                                .padding(.bottom, 1.0)
                                .background(Color.black)
                            HStack {
                                Image(systemName: "hand.raised")
                                    .foregroundColor(.red)
                                    .padding(.leading)
                                    .padding(.top)
                                Text("Delete my account")
                                    .foregroundColor(.red)
                                    .font(.custom("AirbnbCereal_W_Lt", size: 15))
                                    .tracking(2)
                                    .padding()
                                    .padding(.top)
                                Spacer()
                            }.frame(width: 316,height: 38)
                        }
                    }.padding(5)
                }
                Spacer()
            }
        }
    }
    func delete_account(){
        let user = Auth.auth().currentUser
        logout()
        user?.delete { error in
          if let error = error {
            // An error happened.
              print("\(error)")
          } else {
            // Account deleted.
          }
        }
    }
    
    func logout() {
            do {
                try Auth.auth().signOut()
                
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: LoginView())
                    window.makeKeyAndVisible()
                }
                
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
