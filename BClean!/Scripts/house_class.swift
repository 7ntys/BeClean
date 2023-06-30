//
//  house_class.swift
//  BClean!
//
//  Created by Julien Le ber on 08/05/2023.
//

import Foundation
import UIKit
import SwiftUI
class house:Hashable{
    static func == (lhs: house, rhs: house) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var name: String
    var abreviation:String
    var address:String
    var picture : UIImage?
    var clean_time: Date
    var icalLink:String

    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

    init(name: String,abreviation:String,picture:UIImage?,clean_time:Date?,address:String,id:String,icalLink:String) {
        self.name = name
        self.address = address
        self.abreviation = abreviation
        if (picture != nil){self.picture = picture}
        if clean_time != nil {self.clean_time = clean_time!}
        else{self.clean_time = Date()}
        self.id = id
        self.icalLink = icalLink
    }
    
    
}
