//
//  customCalendar.swift
//  BClean!
//
//  Created by Julien Le ber on 23/04/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
struct customSheet:View{
    @Binding var isSheetPresented:Bool
    @Binding var selectedEvent: Event?
    @State var selection:cleaner?
    let db = Firestore.firestore()
    var formatter = DateFormatter()
    var body:some View{
        let _ = formatter.dateFormat = "yyyy-MM-dd"
        let _ = print("the date of selection is : \(selectedEvent!.endDate!)")
        if selectedEvent?.endDate! != nil{
            VStack{
                Spacer()
                Text("Assign a reservation")
                    .font(.custom("AirbnbCereal_W_XBd", size: 32))
                    .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                    .padding(.vertical,10)
                Text("Selected date : \(formatter.string(from: selectedEvent!.endDate!))")
                    .font(.custom("AirbnbCereal_W_XBd", size: 20))
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    HousePresentation(houseName: selectedEvent!.property.name, houseAddress: selectedEvent!.property.address, houseDefaultCleaningTime: selectedEvent!.property.clean_time, housePrefferredCleaner: "",image: selectedEvent!.property.picture)
                    Menu {
                        ForEach(userManager.shared.currentUser!.cleaners,id: \.self) { cleaner in
                            Button {
                                selection = cleaner
                            } label: {
                                Text(cleaner.name)
                            }

                        }
                    } label: {
                        if selection == nil {Text("Cleaners options")}
                        else{
                            Text("\(selection!.name)")
                        }
                    }

                    Button {
                        if selection == nil {
                            print("No cleaners selected")                                    }
                        else{
                            selectedEvent!.cleaner = selection
                            print("the cleaner of the event is : \(selectedEvent!.cleaner!.name)")
                            db.collection("users").document(userManager.shared.currentUser!.id).collection("events").document(selectedEvent!.id).setData(["cleaner" : selection!.id],merge: true)
                            isSheetPresented = false
                        }
                    } label: {
                        Text("Confirm")
                    }.buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient"))
                
                
                Spacer()
            }.presentationDetents([.medium, .large])
                .onAppear{
                    selection = selectedEvent?.cleaner
                }
        }
        else{
            Text("Please reclick on a date")
        }
Spacer()
    }
}

struct WeeklyCalendarView: View {
    @State private var selectedDate = Date()
    
    let calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = .current
        cal.firstWeekday = 6 // Set first day of week to Monday
        return cal
    }()
    @State var events: [Event] = (userManager.shared.currentUser?.eventStore ?? [])
    @State var currUser:user?
    @State var selectedEvent:Event?
    @State var selected:Date?
    @State var isSheetPresented:Bool = false
    var body: some View {
        VStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<60) { weekIndex in
                            let weekStartDate = self.calendar.date(byAdding: .weekOfYear, value: weekIndex, to: self.selectedDate)!
                            let weekEndDate = self.calendar.date(byAdding: .day, value: 6, to: weekStartDate)!
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(self.calendar.shortMonthSymbols[self.calendar.component(.month, from: weekStartDate)-1]) \(self.calendar.component(.day, from: weekStartDate)) - \(self.calendar.component(.day, from: weekEndDate))")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                    .padding(.bottom, 8)
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            self.selectedDate = self.calendar.date(byAdding: .weekOfYear, value: -1, to: self.selectedDate)!
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .font(.system(size: 30))
                                                .foregroundColor(.gray)
                                        }

                                        Button(action: {
                                            self.selectedDate = self.calendar.date(byAdding: .weekOfYear, value: 1, to: self.selectedDate)!
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 30))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.trailing,10)

                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom,20)
                                }
                                
                                HStack(spacing: 8) {
                                    ForEach(0..<7) { dayIndex in
                                        let date = self.calendar.date(byAdding: .day, value: dayIndex, to: weekStartDate)!
                                        // Filter events for the current day
                                        let dayEvents = events.filter { event in
                                            return calendar.isDate(event.endDate!, inSameDayAs: date)
                                        }
                                        VStack(spacing: 4) {
                                            Text("\(self.calendar.shortWeekdaySymbols[self.calendar.component(.weekday, from: date)-1])")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.accentColor)
                                            
                                            Text("\(self.calendar.component(.day, from: date))")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(date == Date() ? .accentColor : .primary)
                                                .padding(.bottom,20)
                                            if dayEvents.count >= 1 {
                                                ForEach(dayEvents) { index_event in
                                                    Button {
                                                        selected = index_event.endDate!
                                                        selectedEvent = index_event
                                                        isSheetPresented = true
                                                    } label: {
                                                        ZStack {
                                                            if index_event.property.picture != nil {
                                                                Image(uiImage: index_event.property.picture!)
                                                                    .resizable()
                                                                    .frame(width: 50,height: 50)
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .clipShape(Circle())
                                                            }
                                                            else if index_event.property.abreviation.count > 0{
                                                                ZStack{
                                                                    Circle()
                                                                        .frame(width: 50,height: 50)
                                                                        .foregroundColor(.blue)
                                                                        .opacity(0.6)
                                                                    Text("\(index_event.property.abreviation)")
                                                                        .foregroundColor(.white)
                                                                }
                                                            }
                                                            else{
                                                                Circle()
                                                                    .frame(width: 50,height: 50)
                                                                    .foregroundColor(.green)
                                                                    .opacity(0.6)
                                                            }
                                                            if index_event.cleaner == nil {
                                                                Circle()
                                                                    .frame(width: 50,height: 50)
                                                                    .foregroundColor(.gray)
                                                                    .opacity(0.6)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            Spacer()
                                            
                                        }
                                        .frame(maxWidth: .infinity)
                                        .sheet(isPresented: $isSheetPresented,onDismiss : {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                print("ici")
                                                update_view()
                                            }
                                        }){
                                            customSheet(isSheetPresented: $isSheetPresented,selectedEvent: $selectedEvent)
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 32, height: 300)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.trailing, 16)

                    .padding(.vertical, 0)
                    .onAppear {
                        UIScrollView.appearance().isPagingEnabled = true
                        update_view()
                    }
                }
                .animation(.easeInOut)
                .frame(maxHeight: 300)
            }
                    }
                    Spacer()
                }
    private func update_view(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            events = userManager.shared.currentUser?.eventStore ?? []
        }
}

}


struct customCalendar_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendarView()
    }
}
