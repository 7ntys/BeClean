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
            Button {
                set_value()
            } label: {
                Text("click me")
            }.foregroundColor(.black)
                .background(.green)
        }
    }
    
    func set_value(){
        let users_db = db.collection("test")
        users_db.document("test/users/1").setData([
            "country" : "France"], merge:true
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
