//
//  ContentView.swift
//  DatingApp
//
//  Created by Radley Hoang on 31/10/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .foregroundColor(Color(Asset.Colors.Global.black100.color))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background(Color.red)
    }
}
