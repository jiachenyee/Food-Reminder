//
//  FoodRecordManager.swift
//  Food
//
//  Created by Jia Chen Yee on 19/7/22.
//

import Foundation
import Algorithms
import SwiftUI
import UserNotifications
enum Time {
    static var day = 86400.0
}

class FoodRecordManager: ObservableObject {
    
    var startDate: Date = Calendar.current.startOfDay(for: Date.now)
    
    let communicationManager = CommunicationManager()
    
    var dateEntries: [DateEntry] {
        get {
            var dict: [Date: Int] = [:]
            
            let daysSinceStart = Int(ceil(abs(Date.now.timeIntervalSince(startDate)) / Time.day))
            
            for i in 0..<daysSinceStart {
                let date = startDate.addingTimeInterval(TimeInterval(i) * Time.day)
                
                dict[date] = 0
            }
            
            let entries = foodEntries.chunked {
                Calendar.current.isDate($0.dateTime, inSameDayAs: $1.dateTime)
            }
            
            for entry in entries {
                dict[Calendar.current.startOfDay(for: entry.first!.dateTime)] = entry.count
            }
            
            return dict.map { key, value in
                DateEntry(date: key, mealCount: value)
            }.sorted(by: {
                $0.date < $1.date
            })
            
        }
    }
    
    var lastMealDate: Date? {
        get {
            foodEntries.max {
                $0.dateTime > $1.dateTime
            }?.dateTime
        }
    }
    
    var lastMealMessage: String {
        get {
            if let lastMealTime = lastMealDate?.timeIntervalSinceNow {
                let daysSinceLastMeal = round(lastMealTime / Time.day)
                
                if daysSinceLastMeal < 1 {
                    return "You ate something today!"
                } else if daysSinceLastMeal == 1 {
                    return "Your last meal was yesterday."
                } else {
                    return "Your last meal was \(daysSinceLastMeal). Please eat."
                }
                
            } else {
                return "No records of last meal"
            }
        }
    }
    
    @Published var foodEntries: [FoodEntry] = [FoodEntry(dateTime: .now.addingTimeInterval(10)), FoodEntry(dateTime: .now.addingTimeInterval(20)), FoodEntry(dateTime: .now.addingTimeInterval(86400))] {
        didSet {
            if let lastElement = foodEntries.last,
               startDate > lastElement.dateTime {
                
                let referenceDate = Calendar.current.startOfDay(for: lastElement.dateTime)
                
                let startDay = Calendar.current.component(.weekday, from: referenceDate)
                
                self.startDate = referenceDate.addingTimeInterval(-Double(startDay - 1) * Time.day)
                print(startDay, startDate)
            }
        }
    }
    
    init() {
        load()
        communicationManager.onReceiveMessage = { data in
            self.get(from: data)
        }
        communicationManager.createWCSession()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            print(error?.localizedDescription)
        }
    }
    
    func updateNotifications(for date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Eat something!"
        content.body = "Reminder to eat something, it's been 8 hours since the last meal"
        content.interruptionLevel = .timeSensitive
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: abs(date.addingTimeInterval(60*60*8).timeIntervalSinceNow), repeats: false)

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
        
    }
    
    func getArchiveURL() -> URL {
        let plistName = "foodEntries.plist"
        let documentsDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.sg.tk.food")!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save(send: Bool) {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        if let encodedFoodEntries = try? propertyListEncoder.encode(foodEntries) {
            if send {
                communicationManager.sendData(data: encodedFoodEntries)
                
                if let last = foodEntries.last {
                    updateNotifications(for: last.dateTime)
                }
            }
            try? encodedFoodEntries.write(to: archiveURL, options: .noFileProtection)
        }
    }
    
    func load() {
        #if os(iOS)
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        
        var finalFoodEntries: [FoodEntry]?
        
        if let retrievedFoodEntryData = try? Data(contentsOf: archiveURL),
           let decodedFoodEntries = try? propertyListDecoder.decode([FoodEntry].self, from: retrievedFoodEntryData) {
            finalFoodEntries = decodedFoodEntries
        }
        
        let startDate = Calendar.current.startOfDay(for: finalFoodEntries?.sorted(by: {
            $0.dateTime < $1.dateTime
        }).first?.dateTime ?? .now)
        
        let startDay = Calendar.current.component(.weekday, from: startDate)
        
        self.startDate = startDate.addingTimeInterval(-Double(startDay - 1) * Time.day)
        
        foodEntries = finalFoodEntries ?? []
        
        save(send: true)
        #endif
    }
    
    func get(from data: Data) {
        let decoder = PropertyListDecoder()
        if let decodedFoodEntries = try? decoder.decode([FoodEntry].self, from: data) {
            DispatchQueue.main.async {
                withAnimation {
                    self.foodEntries = decodedFoodEntries
                }
            }
        }
        
        save(send: false)
    }
}
