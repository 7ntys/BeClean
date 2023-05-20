//
//  CustomViews.swift
//  BClean!
//
//  Created by Julien Le ber on 29/12/2022.
//

import SwiftUI

struct CustomViews: View {
    var body: some View {
        WeeklyCalendarView()
    }
}

struct CustomViews_Previews: PreviewProvider {
    static var previews: some View {
        CustomViews()
    }
}

struct TextZone: View{
    @Binding var value:String
    @State var defaultText:String
    var body: some View{
        TextField("", text: $value)
            .placeholder(when: value.isEmpty, placeholder: {
                Text(defaultText)
                    .font(.custom("AirbnbCereal_W_Bk",fixedSize: 16))
                    .frame(maxWidth: .infinity,alignment: .center)
                    
            })
            .foregroundColor(.white)
            .padding(.vertical,20)
            .padding(.horizontal,20)
            .overlay(RoundedRectangle(cornerRadius: 40.0).strokeBorder(Color.white, style: StrokeStyle(lineWidth: 1.0)))
                        
            .background(Color.gray.opacity(0.3).cornerRadius(40))
            .font(.headline)
        
    }
}

struct customButton: View{
    @State var text:String
    var body: some View{
        Button {
            print("hello world")
        } label: {
            Text(text)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom))
                .font(.custom("AirbnbCereal_W_Bd", size: 20))
                .frame(maxWidth: .infinity)
                .padding(.vertical,20)
                .padding(.horizontal,20)
                .background(.white)
                .cornerRadius(40)
                .shadow(radius: 10)
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom))
            .font(.custom("AirbnbCereal_W_Bd", size: 20))
            .frame(maxWidth: .infinity)
            .padding(.vertical,20)
            .padding(.horizontal,20)
            .background(.white)
            .cornerRadius(40)
            .shadow(radius: 10)
    }
}
struct GradientBackgroundButton: ButtonStyle {
    @State var color1:String
    @State var color2:String
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.custom("AirbnbCereal_W_Lt", size: 10))
            .padding(.horizontal)
            .padding(.vertical,10)
            .background((LinearGradient(gradient: Gradient(colors: [Color(color1), Color(color2)]), startPoint: .top, endPoint: .bottom)))
            .cornerRadius(20)
            .shadow(radius: 10)
    }
}
struct GradientStrokeButton: View{
    @State var text:String
    var body: some View{
        Button {
            print("hello world")
        } label: {
            Text(text)
                .foregroundColor(.black)
                .font(.custom("AirbnbCereal_W_Lt", size: 10))
                .padding(.horizontal)
                .padding(.vertical,10)
                .overlay(RoundedRectangle(cornerRadius: 40.0).strokeBorder((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)), style: StrokeStyle(lineWidth: 1.0)))
        }
    }
}
struct minimalistTextField:View{
    @Binding var link:String
    @State var placeholderText:String
    var body: some View{
        ZStack{
            Rectangle()
                .frame(width: 316,height: 38)
                .foregroundColor(.white)
                .padding(.bottom, 1.0)
                .background(Color.black)
            TextField(placeholderText, text: $link)
                    .frame(maxWidth: 316,alignment: .center)
                .font(.custom("AirbnbCereal_W_Bk", size: 15))
                .foregroundColor(.black)
        }.padding(.vertical,5)
            
    }
}
struct CleanerPresentation:View{
    @State var cleanerName:String
    @State var cleanerEmail:String
    @State var cleanerLanguage:String
    @State var cleanerPay:String
    @State var image:UIImage?
    var body: some View{
        ZStack {
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: .infinity, height:79)
                    .border(.black)
                    .padding(.vertical,0)
            }
            HStack{
                ZStack {
                    Circle()
                        .frame(width: 62,height: 103)
                        .foregroundColor(.black)
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)
                    }
                    else{
                        Text("abreviation")
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)
                    }
                }
                Rectangle()
                    .frame(width: 1)
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(cleanerName)
                            .font(.custom("AirbnbCereal_W_Bd", size: 13))
                            .padding(.bottom,0)
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(cleanerEmail)
                            .font(.custom("AirbnbCereal_W_Bk", size: 10))
                            .padding(.bottom,0)
                        
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.bottom,5)
                        Text(cleanerLanguage)
                            .font(.custom("AirbnbCereal_W_Bk", size: 13))
                            .padding(.bottom,2)
                            .fontWeight(.bold)
                    }
                }
                Rectangle()
                    .frame(width: 1)
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 90,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.top,1)
                        Text("To pay")
                            .font(.custom("AirbnbCereal_W_Bd", size: 10))
                            
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Text(cleanerPay)
                    }.buttonStyle(GradientBackgroundButton(color1: "orange-gradient", color2: "red-gradient"))
                        .frame(width: 100,height: 10)
                        

                    Spacer()
                    
                }
                Rectangle()
                    .frame(width: 1)
                VStack {
                    ZStack{
                        Rectangle()
                            .frame(width: .infinity,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.top,1)
                        Text("Settings")
                            .font(.custom("AirbnbCereal_W_Bd", size: 10))
                            
                    }
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "pencil")
                }.buttonStyle(GradientBackgroundButton(color1: "gray", color2: "gray"))
                        .frame(width: 10,height: 10)
                        
                    
                    Spacer()
                }
                    

                Spacer()
            }.frame(width: .infinity,height: 79)
        }
    }
}

struct HousePresentation:View{
    @State var houseName:String
    @State var houseAddress:String
    @State var houseDefaultCleaningTime:String
    @State var housePrefferredCleaner:String
    @State var image:UIImage?
    var body: some View{
        ZStack {
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: .infinity, height:79)
                .border(.black)}
            HStack{
                ZStack {
                    Circle()
                        .frame(width: 62,height: 103)
                        .foregroundColor(.black)
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)}
                    else{
                        Text("abreviation")
                            .frame(width:60,height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .padding(5)
                    }
                }
                Rectangle()
                    .frame(width: 1)
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(houseName)
                            .font(.custom("AirbnbCereal_W_Bk", size: 13))
                            .padding(.bottom,0)
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                        Text(houseAddress)
                            .font(.custom("AirbnbCereal_W_Bk", size: 10))
                            .padding(.bottom,0)
                        
                    }
                    ZStack{
                        Rectangle()
                            .frame(width: 111,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.bottom,5)
                        Text(houseDefaultCleaningTime)
                            .font(.custom("AirbnbCereal_W_Bk", size: 13))
                            .padding(.bottom,2)
                            .fontWeight(.bold)
                    }
                }
                Rectangle()
                    .frame(width: 1)
                VStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 90,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.top,1)
                        Text("Preferred Cleaner")
                            .font(.custom("AirbnbCereal_W_Bd", size: 10))
                            
                    }
                    Button {
                        
                    } label: {
                        Text(housePrefferredCleaner)
                    }.buttonStyle(GradientBackgroundButton(color1: "orange-gradient", color2: "red-gradient"))
                        .frame(width: 100,height: 10)

                    Spacer()
                    
                }
                Rectangle()
                    .frame(width: 1)
                VStack {
                    ZStack{
                        Rectangle()
                            .frame(width: .infinity,height: 15)
                            .foregroundColor(.white)
                            .padding(.bottom, 1.0)
                            .background(Color.black)
                            .padding(.top,1)
                        Text("Settings")
                            .font(.custom("AirbnbCereal_W_Bd", size: 10))
                            
                    }
                    Button {
                        
                    } label: {
                        Image(systemName: "pencil")
                }.buttonStyle(GradientBackgroundButton(color1: "gray", color2: "gray"))
                    Spacer()
                }
                    

                Spacer()
            }.frame(width: .infinity,height: 79)
        }
    }
}










struct calendarView: UIViewRepresentable{
    let interval: DateInterval
    func makeUIView(context: Context) ->  UICalendarView {
        let view = UICalendarView()
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

