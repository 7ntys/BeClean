//
//  AddCleanerView.swift
//  BClean!
//
//  Created by Julien Le ber on 04/02/2023.
//

import SwiftUI
import iPhoneNumberField
struct AddCleanerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isSheetshowing:Bool=false
    @State var selectedImage:UIImage?
    @State var cleanerName:String = ""
    @State var cleanerAbbreviation:String = ""
    @State var cleanerPhone:String = ""
    @State var cleanerLanguage:String = ""
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color(.white)]), startPoint: .top, endPoint: .bottom)))
                    .ignoresSafeArea()
                    .frame(width: .infinity,height: 100,alignment: .top)
                Text("Add a Cleaner")
                    .font(.custom("AirbnbCereal_W_XBd", size: 32))
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                    .padding(.top,50)
                
            }
            Text("Here you can add a cleaner by providing it this link. Then, the cleaner will provide informations that are necessary for the good of the app.")
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
                    //TO DO : logic behind picking a photo
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

                
                minimalistTextField(link: $cleanerName, placeholderText: "Name of the cleaner")
                minimalistTextField(link: $cleanerAbbreviation, placeholderText: "Abbreviation of the cleaner")
                ZStack {
                    Rectangle()
                        .frame(width: 316,height: 38)
                        .foregroundColor(.white)
                        .padding(.bottom, 1.0)
                        .background(Color.black)
                    iPhoneNumberField("Phone number of the cleaner",text: $cleanerPhone)
                        .flagHidden(false)
                        .flagSelectable(true)
                        .frame(maxWidth: 316,alignment: .center)
                        .font(.custom("AirbnbCereal_W_Bk", size: 15))
                        
                }
                minimalistTextField(link: $cleanerLanguage, placeholderText: "Native language of the cleaner")
                    .padding(.bottom,20)
                Button {
                    
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
}

struct AddCleanerView_Previews: PreviewProvider {
    static var previews: some View {
        AddCleanerView()
    }
}
