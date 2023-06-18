//
//  TermsAndServicesView.swift
//  BClean!
//
//  Created by Julien Le ber on 14/02/2023.
//

import SwiftUI

struct TermsAndServicesView: View {
    var body: some View {
        ScrollView{
            VStack{
                Text("Terms and Services")
                    .font(.custom("AirbnbCereal_W_Bk", size: 20))
                    .padding()
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text("Coming later")
                    
            }
        }
    }
}

struct TermsAndServicesView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndServicesView()
    }
}
