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
                ForEach(0..<30){ index in
                    Text("Blabla")
                        .foregroundColor(.black)
                        .frame(width: 100, height: 100)
                }
                    
            }
        }
    }
}

struct TermsAndServicesView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndServicesView()
    }
}
