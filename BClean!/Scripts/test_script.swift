//
//  test_script.swift
//  BClean!
//
//  Created by Julien Le ber on 07/04/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
struct test_script: View {
    let db = Firestore.firestore()
    var body: some View {
        VStack {
            Text("Bonjour")
        }
    }
    func set_value(){
        let users_db = db.collection("test")
        users_db.document("test/users/1/maison").setData([
            "country" : "France"], merge:true
            )
        print("This was successfull")
    }
    
    func set_house(property:house){
        let users_db = db.collection("test")
        users_db.document("test/users/1/maison").setData(["name":property.name,"abreviaton":property.abreviation,"clean_time":property.clean_time], merge:true
            )
        print("This was successfull")
    }
    
    
    func get_value(){
        db.collection("test/test/users").whereField("last_name", isEqualTo: "Pouli")
                    .getDocuments() { (querySnapshot, err) in
                        if err != nil {
                            print("Error getting documents: (err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let name = document.get("name")
                                print("Name is : \(name!)")
                            }
                        }
                }
    }
}

struct test_script_Previews: PreviewProvider {
    static var previews: some View {
        test_script()
    }
}
