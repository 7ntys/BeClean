import SwiftUI
import UIKit
import Foundation
struct MonthlyCalendarView: View {
    @State private var selectedMonth = Date()

    let calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = .current
        cal.firstWeekday = 6 // Set first day of week to Monday
        return cal
    }()
    @State var events: [Event] = (userManager.shared.currentUser?.eventStore ?? [])
    //Alert
    @State var titleAlert:String = ""
    @State var contentAlert:String = ""
    @State var showAlert:Bool = false
    
    @State var selectedEvent:Event?
    @State var selected:Date?
    @State var isSheetPresented:Bool = false
    @State var refresh_reservation:Bool = true
    var body: some View {
        VStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        ForEach(0..<12) { monthIndex in
                            let monthStartDate = self.calendar.date(byAdding: .month, value: monthIndex, to: self.selectedMonth)!
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(self.calendar.shortMonthSymbols[self.calendar.component(.month, from: monthStartDate)-1])")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.secondary)
                                        .padding(.bottom, 8)
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            self.selectedMonth = self.calendar.date(byAdding: .month, value: -1, to: self.selectedMonth)!
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .font(.system(size: 30))
                                                .foregroundColor(.gray)
                                        }

                                        Button(action: {
                                            self.selectedMonth = self.calendar.date(byAdding: .month, value: 1, to: self.selectedMonth)!
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
                                
                                ScrollView {
                                    VStack {
                                        if let range = self.calendar.range(of: .day, in: .month, for: monthStartDate) {
                                            let numberOfDaysInMonth = range.count
                                            
                                            ForEach(1...numberOfDaysInMonth, id: \.self) { day in
                                                let date = self.calendar.date(bySetting: .day, value: day, of: monthStartDate)!
                                                let weekday = self.calendar.component(.weekday, from: date)
                                                
                                                let dayEvents = events.filter { event in
                                                    return calendar.isDate(event.endDate!, inSameDayAs: date)
                                                }
                                                HStack {
                                                    VStack(spacing: 4) {
                                                        Text("\(self.calendar.shortWeekdaySymbols[weekday-1])")
                                                            .font(.system(size: 14, weight: .semibold))
                                                            .foregroundColor(.accentColor)
                                                        
                                                        Text("\(day)")
                                                            .font(.system(size: 18, weight: .medium))
                                                            .foregroundColor(date == Date() ? .accentColor : .primary)
                                                            .padding(.bottom,20)
                                                        // Add your event handling logic for each day here
                                                    }
                                                    Spacer()
                                                    if dayEvents.count >= 1{
                                                            HStack {
                                                                ForEach(dayEvents) { index_event in
                                                                    Button {
                                                                        if index_event.isConfirmed == 0 {
                                                                            selected = index_event.endDate!
                                                                            selectedEvent = index_event
                                                                            isSheetPresented = true
                                                                        }
                                                                        if index_event.isConfirmed == 1 {
                                                                            titleAlert = "This reservation is already being taken care of"
                                                                            contentAlert = "The cleaner \(index_event.cleaner?.name ?? "") will come clean"
                                                                            showAlert = true
                                                                        }
                                                                        if index_event.isConfirmed == 2 {
                                                                            titleAlert = "This reservation is pending"
                                                                            contentAlert = "The cleaner \(index_event.cleaner?.name ?? "") is still thinking about it"
                                                                            showAlert = true
                                                                        }
                                                                    } label: {
                                                                        ZStack {
                                                                            if index_event.property != nil {
                                                                                if index_event.property.picture != nil {
                                                                                    Image(uiImage: index_event.property.picture!)
                                                                                        .resizable()
                                                                                        .frame(width: 50,height: 50)
                                                                                        .aspectRatio(contentMode: .fit)
                                                                                        .clipShape(Circle())
                                                                                }
                                                                                if (index_event.cleaner == nil || index_event.isConfirmed == 0) && index_event.property.picture == nil{
                                                                                    Circle()
                                                                                        .frame(width: 50,height: 50)
                                                                                        .foregroundColor(.red)
                                                                                        .opacity(0.6)
                                                                                }
                                                                                if index_event.cleaner != nil && index_event.isConfirmed == 1{
                                                                                    Circle()
                                                                                        .frame(width: 50,height: 50)
                                                                                        .foregroundColor(.green)
                                                                                        .opacity(0.6)
                                                                                }
                                                                                if index_event.cleaner != nil && index_event.isConfirmed == 2{
                                                                                    Circle()
                                                                                        .frame(width: 50,height: 50)
                                                                                        .foregroundColor(.gray)
                                                                                        .opacity(0.6)
                                                                                }
                                                                                if index_event.property.abreviation.count > 0 {
                                                                                    ZStack{
                                                                                        Text("\(index_event.property.abreviation)")
                                                                                            .foregroundColor(.white)
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }.sheet(isPresented: $isSheetPresented,onDismiss : {
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                                    print("ici")
                                                                    if !isSheetPresented{
                                                                        update_view()
                                                                        refresh_reservation = false
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                                                            refresh_reservation = true
                                                                        }
                                                                    }
                                                                }
                                                            }){
                                                                customSheet(isSheetPresented: $isSheetPresented,selectedEvent: $selectedEvent)
                                                            }
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 32, height: .infinity)
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                            .alert(isPresented: $showAlert, content:
                                    {Alert(title: Text(titleAlert),message: Text(contentAlert),dismissButton: .cancel())})
                        }
                    }
                    .padding(.trailing, 16)
                    .padding(.vertical, 0)
                }
                .animation(.easeInOut)
                .frame(maxHeight: .infinity)
            }
        }
    }
    private func update_view(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !isSheetPresented {
                events = userManager.shared.currentUser?.eventStore ?? []
            }
        }
}
}

struct MonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyCalendarView()
    }
}
