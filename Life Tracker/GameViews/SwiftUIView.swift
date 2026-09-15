//
//  SwiftUIView.swift
//  Life Tracker
//
//  Created by Deven Mak on 7/31/26.
//

import SwiftUI

struct SwiftUIView: View {
    @State var isOn = false
    var body: some View {
        ZStack {
            //Color.black
            HStack {
                Toggle(isOn: $isOn) {
                    Text("Auto Save")
                        .regular()
                        .foregroundStyle(.accent)
                }
                
                .tint(.accent)
            }
            .frame(maxWidth: 150)
        }
    }
}


#Preview {
    SwiftUIView()
}
