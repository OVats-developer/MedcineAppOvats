//
//  ContentView.swift
//  MedcineAppOvats WatchKit Extension
//
//  Created by Oshin Vats on 01/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    
    @StateObject var mainvm:contentvm = .init()
    
    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                HStack(spacing: 0) {
                    Text(mainvm.day_label)
                    Spacer()
                    NavigationLink {
                        HistoryView()
                    } label: {
                        Text("History")
                    }
                }
                MainView(day_no: mainvm.day_no)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class contentvm:ObservableObject {
    
    @Published var day_label:String
    @Published var day_no:Int
    
    
    init()
    {
        var day_label_comp:Int = Calendar.current.component(.weekday, from: .init())
        self.day_no = day_label_comp - 1
        if (Calendar.current.component(.hour, from: .init()) < 3) {
            self.day_no = day_label_comp - 2
            day_label_comp = day_label_comp - 1
        }
        day_label = Calendar.current.weekdaySymbols[day_label_comp - 1]
    }
}
