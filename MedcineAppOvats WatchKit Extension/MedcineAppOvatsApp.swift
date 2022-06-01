//
//  MedcineAppOvatsApp.swift
//  MedcineAppOvats WatchKit Extension
//
//  Created by Oshin Vats on 30/05/2022.
//

import SwiftUI
import WatchConnectivity

@main
struct MedcineAppOvatsApp: App {
    
    @StateObject var cdstack:CDStack = .init()

    var body: some Scene {
        WindowGroup {
                ContentView().environmentObject(cdstack)
        }
    }
}
