//
//  cleaner_class.swift
//  BClean!
//
//  Created by Julien Le ber on 08/05/2023.
//

import Foundation
import UIKit
class cleaner:Hashable,Identifiable{
    static func == (lhs: cleaner, rhs: cleaner) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String
    var name: String
    var phone:String
    var email:String
    var language:String
    var picture: UIImage?
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    init(name: String,phone:String,email:String,language:String,image:UIImage?,id:String) {
        self.name = name
        if (image != nil) {self.picture=image}
        self.email=email
        self.phone = phone
        self.language = language
        self.id = id
    }
}
