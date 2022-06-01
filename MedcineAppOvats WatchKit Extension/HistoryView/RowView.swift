//
//  RowView.swift
//  MedcineAppOvats WatchKit Extension
//
//  Created by Oshin Vats on 01/06/2022.
//

import SwiftUI

struct RowView: View {
    
    var size:CGSize
    
    @State var day_val:String
    @State var morning_val:String
    @State var evening_val:String
    
    var body: some View {
        HStack(spacing:0) {
            let width:CGFloat = size.width
            Text(day_val).frame(width:width * 0.33)
            if (day_val != "") {Divider()}
            Text(morning_val).frame(width:width * 0.33)
            Text(evening_val).frame(width:width * 0.33)
        }
        .frame(width:size.width)
    }
}
