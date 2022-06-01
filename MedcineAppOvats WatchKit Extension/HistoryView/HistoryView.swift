//
//  HistoryView.swift
//  MedcineAppOvats WatchKit Extension
//
//  Created by Oshin Vats on 01/06/2022.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var cdstack:CDStack
    
    var body: some View {
        GeometryReader {reader in
            let size:CGSize = reader.size
            List {
                RowView(size: size, day_val: "", morning_val: "Morn", evening_val: "Even")
                
                ForEach(cdstack.day_data) { day in
                    
                    let morning_val:String = day.morning_eaten ? "Eaten":"Not"
                    let evening_val:String = day.evening_eaten ? "Eaten":"Not"
                    
                    let day_val:String = day.day_short
                    
                    RowView(size: size, day_val: day_val, morning_val: morning_val, evening_val: evening_val)
                        .listRowBackground(Color.black)
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(CDStack())
    }
}
