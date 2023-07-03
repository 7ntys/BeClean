//
//  ical.swift
//  BClean!
//
//  Created by Julien Le ber on 11/05/2023.
//
import SwiftUI
import Foundation
import FirebaseFirestore
// Définir une structure pour stocker les données d'un événement
class Event:Hashable,Identifiable{
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    var summary: String?
    var location: String?
    var startDate: Date?
    var endDate: Date?
    var id:String
    let property:house
    var cleaner:cleaner?
    var options:String?
    var isConfirmed:Int
    init(summary:String?,location:String?,startDate:Date?,endDate:Date?,id:String,property:house,cleaner:cleaner?,isConfirmed:Int,options:String?){
        self.summary = summary
        self.location = location
        self.isConfirmed = isConfirmed
        self.startDate = startDate
        self.endDate = endDate
        self.id = id
        self.property = property
        self.options = options
        if cleaner != nil {self.cleaner = cleaner}
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    
    
}
func get_infos(url:String,property:house) -> [Event]?{
    //A check : async
    // Charger le fichier iCal à partir d'un URL
    if url.isEmpty {return nil}
    let calendar = Calendar.current
    if let url:URL = URL(string: url){
        do {
            let data = try Data(contentsOf: url)
            // Traitement des données
            // Convertir le fichier iCal en chaîne de caractères
            let iCalString = String(data: data, encoding: .utf8)
            
            // Séparer la chaîne de caractères en lignes
            let lines = iCalString?.components(separatedBy: .newlines)
            
            // Parcourir chaque ligne pour extraire les données d'événement
            var events = [Event]()
            var currentEvent = Event(summary: nil, location: nil, startDate: nil, endDate: nil,id:"",property: property,cleaner: nil,isConfirmed: 0,options: nil)
            for line in lines ?? [] {
                if line.hasPrefix("SUMMARY:") {
                    currentEvent.summary = line.replacingOccurrences(of: "SUMMARY:", with: "")
                } else if line.hasPrefix("LOCATION:") {
                    currentEvent.location = line.replacingOccurrences(of: "LOCATION:", with: "")
                } else if line.hasPrefix("DTSTART;") {
                    let dateString = line.replacingOccurrences(of: "DTSTART;VALUE=DATE:", with: "")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    currentEvent.startDate = dateFormatter.date(from: dateString)
                } else if line.hasPrefix("DTEND;") {
                    let dateString = line.replacingOccurrences(of: "DTEND;VALUE=DATE:", with: "")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    currentEvent.endDate = dateFormatter.date(from: dateString)
                    
                    var dateComponents = DateComponents()
                    dateComponents.day = -1

                    // Subtract the components from the date
                    if let modifiedDate = calendar.date(byAdding: dateComponents, to: currentEvent.endDate!) {
                        currentEvent.endDate = modifiedDate
                        print(currentEvent.endDate)
                        let components = calendar.dateComponents([.hour, .minute], from: property.clean_time)
                        print(components)
                        if let final_date = calendar.date(byAdding: components, to: currentEvent.endDate!){
                            currentEvent.endDate = final_date
                            print("final ical :\(currentEvent.endDate)")
                        }
                    } else {
                        print("Failed to modify the date.")
                    }
                } else if line == "END:VEVENT" {
                    events.append(currentEvent)
                    currentEvent = Event(summary: nil, location: nil, startDate: nil, endDate: nil,id:"",property: property,cleaner: nil,isConfirmed: 0,options: nil)
                }
            }
            return events
        } catch let error {
            // Traitement de l'erreur
            print("Erreur : \(error.localizedDescription)")
            return []
        }
    }
    else{
        print("error somewhere")
        return nil
    }
    // Utiliser le tableau d'événements pour effectuer des opérations supplémentaires
    // ...
}


func add_event_db(event:Event){
    var does = true
    userManager.shared.currentUser?.print_events()
    userManager.shared.currentUser?.eventStore.forEach({ menage in
        if Calendar.current.isDate(menage.endDate!, equalTo: event.endDate!, toGranularity: .day) && event.property == menage.property{
            print("This event already exist in database")
            does = false
        }
    })
    
    if does {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        let users_db = db.collection("users/\(userManager.shared.currentUser!.id)/events")
        var add:[String:Any]
        if event != nil {
            if event.cleaner != nil {
                add = ["cleaner" : event.cleaner!.id,
                       "endDate" : event.endDate ?? "",
                       "summary" : event.summary ?? "",
                       "house" : event.property.id,
                       "isConfirmed" : false
                ]
            }
            else{
                add = ["endDate" : event.endDate ?? "",
                       "summary" : event.summary ?? "",
                       "house" : event.property.id,
                       "isConfirmed":false
                ]
            }
            ref = users_db.addDocument(data: add){ error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added successfully")
                    // Retrieve the ID of the newly created document
                    let documentId = ref?.documentID
                    event.id = documentId!
                    userManager.shared.currentUser?.add_events(events: [event])
                }
            }
            
        }
    }
}
