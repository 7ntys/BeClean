//
//  users_class.swift
//  BClean!
//
//  Created by Julien Le ber on 08/05/2023.
//

import Foundation
import Combine
class user{
    var name: String
    var email:String
    private var surname : String
    var id: String
    var properties : [house]
    var cleaners : [cleaner]
    var eventStore: [Event]
    var Subscribe:String?
    init(name:String, surname:String,id:String,email:String){
        self.name = name
        self.email = email
        self.id = id
        self.surname = surname
        self.properties = []
        self.cleaners = []
        self.eventStore = []
        self.Subscribe = nil
    }
    
    func add_house(property:house){
        self.properties.append(property)
    }
    func add_cleaner(cleaner:cleaner){
        self.cleaners.append(cleaner)
        self.print_cleaner()
    }
    func print_user(){
        print("ca rentre")
        print("This user : \(self.name) | \(self.surname)")
    }
    func get_properties() -> [house]{return self.properties}
    func get_cleaners() -> cleaner{return self.cleaners[0]}
    func print_cleaner(){
        for cleaner in cleaners {
            print("In user : \(cleaner.name)")
        }
    }
    func add_events(events: [Event]){
        events.forEach { event in
            self.eventStore.append(event)
        }
    }
    func find_event(date:Date) -> Event? {
        var found:Event?
        self.eventStore.forEach { event in
            if event.endDate == date{
                found = event
            }
        }
        return found
    }
    func print_events(){
        print("Currently printing events : ")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        eventStore.forEach { Event in
            if Event.cleaner != nil {
                print("\(Event.cleaner!.name)")
            }
        }
    }
    func print_properties(){
        properties.forEach { house in
            print("\(house.name)")
        }
    }
}

class userManager: ObservableObject {
    static let shared = userManager()
    @Published var currentUser: user?
}
