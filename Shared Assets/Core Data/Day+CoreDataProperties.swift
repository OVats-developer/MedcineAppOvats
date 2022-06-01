//
//  Day+CoreDataProperties.swift
//  MedcineAppOvats
//
//  Created by Oshin Vats on 01/06/2022.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var day_no: Float
    @NSManaged public var evening_eaten: Bool
    @NSManaged public var morning_eaten: Bool

}

extension Day : Identifiable {
    var day_string:String {
        switch day_no {
        case Float(0):
            return "Monday"
        case Float(1):
            return "Tuesday"
        case Float(2):
            return "Wednesday"
        case Float(3):
            return "Thursday"
        case Float(4):
            return "Friday"
        case Float(5):
            return "Saturday"
        case Float(6):
            return "Sunday"
        default:
            return "Monday"
        }
    }
    
    
    var day_short:String {
        switch day_no {
        case Float(0):
            return "Mon"
        case Float(1):
            return "Tue"
        case Float(2):
            return "Wed"
        case Float(3):
            return "Thu"
        case Float(4):
            return "Fri"
        case Float(5):
            return "Sat"
        case Float(6):
            return "Sun"
        default:
            return "Mon"
        }
    }
}
