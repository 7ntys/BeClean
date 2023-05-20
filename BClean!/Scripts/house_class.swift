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
    var clean_time: String
    var icalLink:String

    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

    init(name: String,abreviation:String,picture:UIImage?,clean_time:String,address:String,id:String,icalLink:String) {
        self.name = name
        self.address = address
        self.abreviation = abreviation
        if (picture != nil){self.picture = picture}
        self.clean_time = clean_time
        self.id = id
        self.icalLink = icalLink
    }
    
    
}
