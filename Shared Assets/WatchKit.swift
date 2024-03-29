//
//  WatchKit.swift
//  MedcineAppOvats
//
//  Created by Oshin Vats on 01/06/2022.
//

import Foundation
import WatchConnectivity
import Combine

class WCConnect:NSObject
{
    var session:WCSession
    var cdstack:CDStack
    
    var stored_dictionary_message:[String:Any]!
    var stored_dictionary_context:[String:Any]!
    
    var message_cancellable:AnyCancellable!
    var context_cancellable:AnyCancellable!
    
    init (stack:CDStack) {
        session = .default
        cdstack = stack
        super.init()
        session.delegate = self
        session.activate()
        print(session.isReachable)
    }
    
    
    func update_companion(day:Day)
    {
        if (session.activationState == .notActivated) {
            session.activate()
        }
        if (session.isReachable)
        {
            sendmessage(day: day)
        }
        else
        {
            update_context()
        }
    }
        
    func sendmessage(day:Day)
    {
        session.sendMessage(create_message_dictionary(day: day), replyHandler: nil)
    }
    
    func update_context()
    {
        do {
            try session.updateApplicationContext(encode_context())
        }
        catch {print(error)}
    }
    
}

extension WCConnect:WCSessionDelegate {
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if (error != nil) {print(error!)}
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if (cdstack.day_data.count != 7)
        {
            self.stored_dictionary_message = message
            message_cancellable = cdstack.$day_data.sink(receiveValue: { vals in
                if (self.cdstack.day_data.count != 7) { return }
                DispatchQueue.main.async {
                    self.message_processing(message: self.stored_dictionary_message)
                    self.message_cancellable.cancel()
                }
            })
        }
        else
        {
            message_processing(message: message)
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if (cdstack.day_data.count != 7)
        {
            self.stored_dictionary_context = applicationContext
            self.context_cancellable = cdstack.$day_data.sink(receiveValue: { vals in
                if (self.cdstack.day_data.count != 7) {return}
                DispatchQueue.main.async {
                    self.decode_context(dictionary: self.stored_dictionary_context)
                    self.context_cancellable.cancel()
                }
            })
        }
        else
        {
            decode_context(dictionary: applicationContext)
        }
    }
    
    func message_processing(message:[String:Any])
    {
        let day_no:Int = Int(message["day_no"] as! Float)
        let day_obj:Day = cdstack.day_data[day_no]
        day_obj.morning_eaten = message["morning_eaten"] as! Bool
        day_obj.evening_eaten = message["evening_eaten"] as! Bool

    }
    
    func create_message_dictionary(day:Day) -> [String:Any]
    {
        var dictionary:[String:Any] = [:]
        dictionary["day_no"] = day.day_no
        dictionary["morning_eaten"] = day.morning_eaten
        dictionary["evening_eaten"] = day.evening_eaten
        return dictionary
    }
    
    func encode_context() -> [String:Any] {
        
        var dictionary:[String:Any] = [:]
        
        for i in 0..<7 {
            let day_obj = cdstack.day_data[i]
            dictionary["\(i)_morn"] = day_obj.morning_eaten
            dictionary["\(i)_even"] = day_obj.evening_eaten
        }
        return dictionary
    }
    
    func decode_context(dictionary:[String:Any])
    {
        for i in 0..<7 {
            let day_obj = cdstack.day_data[i]
            day_obj.morning_eaten = dictionary["\(i)_morn"] as! Bool
            day_obj.evening_eaten = dictionary["\(i)_even"] as! Bool
        }
    }
}

