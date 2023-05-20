//
//  fsCalendar.swift
//  BClean!
//
//  Created by Julien Le ber on 14/05/2023.
//

import SwiftUI
import FSCalendar
import UIKit
import FirebaseFirestore
struct fsCalendar: View {
    @State private var refresh = false
    @State private var events: [Event] = userManager.shared.currentUser?.eventStore ?? []
    @State private var selectedDate: Date?
    @State private var isSheetPresented = false
    @State private var selection:cleaner?
    let db = Firestore.firestore()
    let calendar = Calendar.current
    private var formatter = DateFormatter()
    
    var body: some View {
        VStack {
            CalendarViewRepresentable(refresh: $refresh,eventStore: $events,selectedDate: $selectedDate,isSheetShowing: $isSheetPresented)
                }.sheet(isPresented: $isSheetPresented) {
                    let _ = print("the date of selection is : \(selectedDate)")
                    if selectedDate != nil{
                        VStack{
                            Spacer()
                            Text("Assign a reservation")
                                .font(.custom("AirbnbCereal_W_XBd", size: 32))
                                .foregroundStyle((LinearGradient(gradient: Gradient(colors: [Color("orange-gradient"), Color("red-gradient")]), startPoint: .top, endPoint: .bottom)))
                                .padding(.vertical,10)
                            Text("Selected date : \(formatter.string(from: selectedDate!))")
                                .font(.custom("AirbnbCereal_W_XBd", size: 20))
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                            if let event = userManager.shared.currentUser?.find_event(date: selectedDate!){
                                HousePresentation(houseName: event.property.name, houseAddress: event.property.address, houseDefaultCleaningTime: event.property.clean_time, housePrefferredCleaner: "",image: event.property.picture)
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
                                        event.cleaner = selection
                                        print("the cleaner of the event is : \(event.cleaner?.name)")
                                        db.collection("users").document(userManager.shared.currentUser!.id).collection("events").document(event.id).setData(["cleaner" : selection!.id],merge: true)
                                        isSheetPresented = false
                                        refresh.toggle()
                                    }
                                } label: {
                                    Text("Confirm")
                                }.buttonStyle(GradientBackgroundButton(color1: "light-green-gradient", color2: "dark-green-gradient"))
                            }
                            
                            Spacer()
                        }.presentationDetents([.medium, .large])
                    }
                    else{
                        Text("Bug error")
                    }
            Spacer()
        }.onAppear {
            self.formatter.dateFormat = "yyyy-MM-dd"
            self.refresh = false
            self.refresh = true
            self.update_view()
        }    }
    private func update_view(){
        events = userManager.shared.currentUser?.eventStore ?? []
    }
}

struct fsCalendar_Previews: PreviewProvider {
    static var previews: some View {
        fsCalendar()
    }
}

struct CalendarViewRepresentable: UIViewRepresentable {
    @Binding var refresh: Bool
    @Binding var eventStore: [Event]
    @Binding var selectedDate: Date?
    @Binding var isSheetShowing: Bool
    var formatter = DateFormatter()
    typealias UIViewType = FSCalendar

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        
        // Set appearance properties
            calendar.appearance.eventDefaultColor = .clear // Clear color for default dot
            calendar.appearance.eventSelectionColor = .clear // Clear color for selected dot
            calendar.appearance.eventOffset = CGPoint(x: 0, y: 8) // Adjust the vertical position of the dot
            
        calendar.appearance.todayColor = .black
        calendar.appearance.headerTitleFont = .systemFont(
                                                        ofSize: 30,
                                                        weight: .black)
                calendar.appearance.headerTitleColor = .darkGray
                calendar.appearance.headerDateFormat = "MMMM"
                calendar.scrollDirection = .horizontal
                calendar.scope = .month
        calendar.clipsToBounds = true
        calendar.firstWeekday = 2
        calendar.allowsSelection = true
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
            if refresh {
                uiView.reloadData()
                eventStore = userManager.shared.currentUser?.eventStore ?? []
                refresh.toggle()
            }
        }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject,
          FSCalendarDelegate, FSCalendarDataSource {
            var parent: CalendarViewRepresentable
            init(_ parent: CalendarViewRepresentable) {
                self.parent = parent
            }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
                var eventCount = 0
                let calendar = Calendar.current
            if self.parent.eventStore.count == 0 {return 0}
                self.parent.eventStore.forEach { event in
                        if event.endDate == nil {eventCount = 0}
                        else if calendar.isDate(event.endDate!, inSameDayAs: date) {
                            eventCount += 1
                        }
                    }
                    return eventCount
                }

        func calendar(_ calendar: FSCalendar,
                      imageFor date: Date) -> UIImage? {
            let eventcount = self.calendar(calendar, numberOfEventsFor: date)
            if eventcount > 0 {
                let cal = Calendar.current
                let event = self.parent.eventStore.first(where: { cal.isDate($0.endDate ?? Date(), inSameDayAs: date) })
                if event?.cleaner != nil {return UIImage(named: "greenDot")?.resize(to: CGSize(width: 6, height: 6)) }
                if eventcount > 1 {
                    return UIImage(systemName: "sparkles")
                }
                else{return UIImage(named: "redDot")?.resize(to: CGSize(width: 6, height: 6)) }
            }
            return nil
        }
        // FSCalendarDelegate
                func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
                    self.parent.selectedDate = date
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let selected = formatter.string(from: date)
                    print("Selected Date: \(selected)")
                    DispatchQueue.main.async {
                        self.parent.isSheetShowing = true
                        }
                }

        }
}
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
