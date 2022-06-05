//
//  ContentView.swift
//  MedcineAppOvats WatchKit Extension
//
//  Created by Oshin Vats on 01/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    
    @StateObject var mainvm:contentvm = .init()
    @Environment(\.scenePhase) private var scenePhase

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
            .onAppear {
                mainvm.onappear()
            }
            .onChange(of: scenePhase) { newValue in
                mainvm.onappear()
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
    
    @Published var day_label:String!
    @Published var day_no:Int
    
    
    init()
    {
        day_no = Calendar.current.component(.weekday, from: .init())
        if (day_no == 1) {day_no = 6}
        else {day_no = day_no - 2}
        
        if (Calendar.current.component(.hour, from: .init()) <= 3) {
            if (day_no == 0) {day_no = 6}
            else {day_no -= 1}
        }
        
        switch day_no {
        case 0:
            day_label = "Monday"
        case 1:
            day_label = "Tuesday"
        case 2:
            day_label = "Wednesday"
        case 3:
            day_label = "Thursday"
        case 4:
            day_label = "Friday"
        case 5:
            day_label = "Saturday"
        case 6:
            day_label = "Sunday"
        default:
            day_label = "Monday"
        }
        
    }
    
    func onappear()
    {
        var temp_day_no = Calendar.current.component(.weekday, from: .init())
        if (temp_day_no == 1) {temp_day_no = 6}
        else {temp_day_no = temp_day_no - 2}
        
        if (Calendar.current.component(.hour, from: .init()) <= 3) {
            if (temp_day_no == 0) {temp_day_no = 6}
            else {temp_day_no -= 1}
        }
        
        self.day_no = temp_day_no
        
        switch day_no {
        case 0:
            day_label = "Monday"
        case 1:
            day_label = "Tuesday"
        case 2:
            day_label = "Wednesday"
        case 3:
            day_label = "Thursday"
        case 4:
            day_label = "Friday"
        case 5:
            day_label = "Saturday"
        case 6:
            day_label = "Sunday"
        default:
            day_label = "Monday"
        }
        
        print(day_no)
    }
}
