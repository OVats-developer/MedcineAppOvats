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
    @Published var label_text:String = "Eat Morning Medicine"
    @Published var color:Color = .orange
    
    var cancellable:AnyCancellable!
    
    var day_no:Int!
    var day:Day!
    
    var cdstack:CDStack!
    
    func onappear(stack:CDStack, day_no:Int)
    {
        self.cdstack = stack
        self.day_no = day_no
        self.day = cdstack.day_data[day_no]
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
    }
    
    func toggle()
    {
        if day.morning_eaten == false {
            day.morning_eaten.toggle()
            morning_eaten_state()
        }
        else if (day.morning_eaten == true)
        {
            if (day.evening_eaten == false)
            {
                all_eaten()
                day.evening_eaten.toggle()
            }
            else
            {
                all_eaten()
            }
        }
        cdstack.save()
        cdstack.wc_obj.update_companion(day: day)
    }
    
    func none_eaten_state()
    {
        morning_eaten = false
        color = .orange
        label_text = "Eat Morning Medicine"
    }
    
    func morning_eaten_state()
    {
        morning_eaten = true
        color = .blue
        label_text = "Eat Evening Medicine"
    }
    
    func all_eaten()
    {
        morning_eaten = true
        color = .black
        label_text = "All Medicine Eaten"
    }
}
