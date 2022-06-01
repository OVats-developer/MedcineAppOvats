//
//  ContentView.swift
//  MedcineAppOvats
//
//  Created by Oshin Vats on 30/05/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var cdstack:CDStack
    
    var body: some View {
        NavigationView {
            List {
                ForEach (cdstack.day_data) {day in
                    RowCell(day: day)
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CDStack())
            .preferredColorScheme(.dark)
    }
}
