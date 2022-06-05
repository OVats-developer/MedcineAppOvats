//
//  MainView.swift
//  MedcineAppOvats WatchKit Extension
//
//  Created by Oshin Vats on 01/06/2022.
//

import SwiftUI
import Combine

struct MainView: View {
    
    @EnvironmentObject var cdstack:CDStack
    @StateObject var mainvm:mainvm = .init()
    
    var day_no:Int
    
    var body: some View {
        
        Button(action: {
            mainvm.toggle()
        }, label: {
            Circle()
                .overlay(content: {
                    Text(mainvm.label_text)
                        .foregroundColor(.white)
                        .bold()
                        .padding([.leading, .trailing])
                })
                .ignoresSafeArea()
                .foregroundColor(
                    mainvm.color
                )
        })
        .buttonStyle(.borderless)
        .onAppear {
            mainvm.onappear(stack: self.cdstack, day_no: day_no)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(day_no: 2).environmentObject(CDStack())
    }
}


class mainvm:ObservableObject {
    
    
    @Published var morning_eaten:Bool = false
    @Published var label_text:String = "Eat Morning?"
    @Published var color:Color = .orange.opacity(0.8)
    
    var day_cancellable:AnyCancellable!
    var evening_cancellable:AnyCancellable!
    
    var day_no:Int!
    var day:Day!
    
    var cdstack:CDStack!
    
    func onappear(stack:CDStack, day_no:Int)
    {
        self.cdstack = stack
        self.day_no = day_no
        if (self.day_no < 0) {self.day_no = 6}
        self.day = cdstack.day_data[self.day_no]
        if (day.morning_eaten == false)
        {
            none_eaten_state()
        }
        else if (day.morning_eaten == true)
        {
            if(day.evening_eaten == false)
            {
                morning_eaten_state()
            }
            else
            {
                all_eaten()
            }
        }
        
        day_cancellable = day.publisher(for: \.morning_eaten).sink(receiveValue: { val in
            if (val == true) {
                if (self.day.evening_eaten == true) {
                    DispatchQueue.main.async {self.all_eaten()}
                }
                else {
                    DispatchQueue.main.async {self.morning_eaten_state()}
                }
            }
            else
            {
                DispatchQueue.main.async {self.none_eaten_state()}
            }
        })
        
        evening_cancellable = day.publisher(for: \.evening_eaten).sink(receiveValue: { val in
            if (val == true) {
                if (self.day.morning_eaten == true) {
                    DispatchQueue.main.async {self.all_eaten()}
                }
                else {
                    DispatchQueue.main.async {self.none_eaten_state()}
                }
            }
            else
            {
                if (self.day.morning_eaten == false) {
                    DispatchQueue.main.async {self.none_eaten_state()}
                }
                else
                {
                    DispatchQueue.main.async {self.morning_eaten_state()}
                }
            }
        })
    }
    
    func toggle()
    {
        if day.morning_eaten == false {
            day.morning_eaten.toggle()
        }
        else if (day.morning_eaten == true)
        {
            if (day.evening_eaten == false)
            {
                day.evening_eaten.toggle()
            }
        }
        cdstack.wc_obj.update_companion(day: day)
    }
    
    func none_eaten_state()
    {
        morning_eaten = false
        color = .orange.opacity(0.8)
        label_text = "Eat Morning?"
    }
    
    func morning_eaten_state()
    {
        morning_eaten = true
        color = .blue.opacity(0.8)
        label_text = "Eat Evening?"
    }
    
    func all_eaten()
    {
        morning_eaten = true
        color = .black
        label_text = "All Eaten"
    }
}
