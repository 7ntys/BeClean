//
//  CustomViews.swift
//  BClean!
//
//  Created by Julien Le ber on 29/12/2022.
//

import SwiftUI




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
    @State var char:Int?
    @State var placeholderText:String
    var body: some View{
        ZStack{
            Rectangle()
                .frame(width: 316,height: 38)
                .foregroundColor(.white)
                .padding(.bottom, 1.0)
                .background(Color.black)
            TextField(placeholderText, text: $link.max(char ?? 200))
                    .frame(maxWidth: 316,alignment: .center)
                .font(.custom("AirbnbCereal_W_Bk", size: 15))
                .foregroundColor(.black)
        }.padding(.vertical,5)
            
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
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

