//
//  ContentView.swift
//  ContestSwiftUI
//
//  Created by Yevgeniy Zakharov on 09.10.2022.
//

import SwiftUI

struct ContentView: View {
    struct AccessLabelText {
        static let `default` = "Access Your Photos and Videos"
        static let restricted = "Oops. Access is Restricted"
        static let denied = "On ho, Access is Denied"
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image("accessIcon")
                    .padding()
                Text(AccessLabelText.default)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                /*Button {
                    <#code#>
                } label: {
                    <#code#>
                }*/

                Spacer()
            }
            Spacer()
        }
        .padding()
        .background(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
