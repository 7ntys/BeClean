import SwiftUI

struct testCalendar:UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    let interval: DateInterval
    @State private var properties: [house] = (userManager.shared.currentUser?.properties ?? [])
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        
    }
    @MainActor
    class Coordinator:NSObject,UICalendarViewDelegate{
        var parent:testCalendar
        var currUser = userManager.shared.currentUser
        init(parent: testCalendar) {
            self.parent = parent
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            @State var currUser = userManager.shared.currentUser
            
            
            return nil
        }
    }
    
}

extension Date{
    
    var StartOfDay:Date{
        Calendar.current.startOfDay(for: self)
    }
}

struct MyView:View{
    var body:some View{
        ScrollView{
            NavigationStack{
                testCalendar(interval: DateInterval(start: .distantPast, end:.distantFuture))
            }
        }
    }
}
