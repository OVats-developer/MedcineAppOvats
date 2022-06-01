//
//  WatchSession.swift
//  MedcineAppOvats
//
//  Created by Oshin Vats on 30/05/2022.
//

import Foundation
import WatchConnectivity
import Combine
import CoreData

enum error:Error {
    case cannot_reach
    case error_in_data
    case cannot_send_data
}

class CDStack:NSObject,ObservableObject {
    
    var fetchrequest:NSFetchRequest<Day>
    var frc:NSFetchedResultsController<Day>
    var context:NSManagedObjectContext
    var wc_obj:WCConnect!
    
    var lastresetdate:Date?
    var nextresetdate:Date?
    
    @Published var day_data:[Day] = []
    
    var container:NSPersistentContainer = {
        var container = NSPersistentContainer(name: "DataModel")
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { description, error in
            if (error != nil) {
                print(error!)
                fatalError()
            }
        }
        return container
    }()
    
    func check_reset()
    {
        lastresetdate = UserDefaults.standard.object(forKey: "lastresetdate") as? Date
        if (lastresetdate == nil) {
            lastresetdate = Calendar.startofweek(date: .init())
            UserDefaults.standard.set(lastresetdate, forKey: "lastresetdate")
        }
        nextresetdate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: lastresetdate!)
        if (Date.init() > nextresetdate!) {
            for day in day_data {
                day.morning_eaten = false
                day.evening_eaten = false
            }
            lastresetdate = Calendar.startofweek(date: .init())
            UserDefaults.standard.set(lastresetdate, forKey: "lastresetdate")
        }
    }
    
    
    override init()
    {
        context = container.viewContext
        fetchrequest = Day.fetchRequest()
        fetchrequest.sortDescriptors = [.init(key: "day_no", ascending: true)]
        
        frc = .init(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        wc_obj = .init(stack: self)

        do {
            try frc.performFetch()
            DispatchQueue.main.async {self.settingup_data()}
            frc.delegate = self
        }
        catch {print(error)}
        check_reset()
    }
    
    
    
    func settingup_data()
    {
        var local_array:[Day] = []
        
        if ((frc.fetchedObjects == nil) || (frc.fetchedObjects!.count == 0))
        {
            for i in 0..<7
            {
                let day:Day = .init(context: context)
                day.day_no = Float(i)
                day.morning_eaten = false
                day.evening_eaten = false
                local_array.append(day)
            }
            save()
        }
        else
        {
            local_array = frc.fetchedObjects!
        }
        self.day_data = local_array
    }
    
    func save()
    {
        do {
            try context.save()
        }
        catch {
            print(error)
            fatalError()
        }
    }
}

extension CDStack:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (indexPath == nil) {return}
        DispatchQueue.main.async {self.save()}
    }
}


extension Calendar {
    static func startofweek(date:Date) -> Date {
        
        let cal = self.init(identifier: .gregorian)
        let components = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        var startofweek_pp = cal.date(from: components)!
        startofweek_pp = cal.date(bySettingHour: 3, minute: 0, second: 0, of: startofweek_pp)!
        
        var startofweek = startofweek_pp
        
        if (cal.firstWeekday == 1) {
            startofweek = cal.date(byAdding: .day, value: 1, to: startofweek)!
        }
        return startofweek
    }
}

