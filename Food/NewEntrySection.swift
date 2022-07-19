//
//  NewEntrySection.swift
//  Food
//
//  Created by Jia Chen Yee on 19/7/22.
//

import SwiftUI

struct NewEntrySection: View {
    
    @ObservedObject var foodRecordManager: FoodRecordManager
    
    @State var date: Date = .now
    @State var isErrorAlertPresented = false
    
    var body: some View {
        Section("New Entry") {
            DatePicker("Date", selection: $date)
            
            Button("Add Entry") {
                withAnimation {
                    if date.timeIntervalSinceNow > 10 {
                        isErrorAlertPresented = true
                    } else {
                        foodRecordManager.foodEntries.append(FoodEntry(dateTime: date))
                        foodRecordManager.save(send: true)
                    }
                }
            }
            .alert("No time travelling!", isPresented: $isErrorAlertPresented) {
                Button("OK") {}
            } message: {
                Text("You can't create an entry in the future")
            }

        }
    }
}

struct NewEntrySection_Previews: PreviewProvider {
    static var previews: some View {
        NewEntrySection(foodRecordManager: .init())
    }
}
