//
//  RowCell.swift
//  MedcineAppOvats
//
//  Created by Oshin Vats on 30/05/2022.
//

import SwiftUI
import Combine
import WatchConnectivity

struct RowCell: View {
    
    @StateObject var day:Day
    @Environment(\.colorScheme) var colorscheme:ColorScheme
    @EnvironmentObject var cdstack:CDStack
    
    var body: some View {
        GeometryReader {reader in
            HStack(spacing:5) {
                Text(day.day_string)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .frame(width: reader.size.width * 0.33)
                Divider()
                morning_toggle()
                    .frame(width: reader.size.width * 0.33)
                evening_toggle()
                    .frame(width: reader.size.width * 0.33)
            }
        }
        .frame(height: 60)
        .ignoresSafeArea()
        .onChange(of: day.morning_eaten) { newValue in
            cdstack.wc_obj.update_companion(day: day)
        }
        .onChange(of: day.evening_eaten) { newValue in
            cdstack.wc_obj.update_companion(day: day)
        }
    }
    
    @ViewBuilder
    func morning_toggle() -> some View {
        Toggle(isOn: $day.morning_eaten) {
            Text("Morning Eaten?")
                .foregroundColor(colorscheme == .dark ? .white:.black)
        }
#if os(iOS)
        .toggleStyle(.button)
#endif
        .tint(.yellow)
    }
    
    @ViewBuilder func evening_toggle() -> some View {
        Toggle(isOn: $day.evening_eaten) {
            Text("Evening Eaten?")
                .foregroundColor(colorscheme == .dark ? .white:.black)
        }
#if os(iOS)
        .toggleStyle(.button)
#endif
        .tint(.blue)
    }
}
