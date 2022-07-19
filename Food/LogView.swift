//
//  LogView.swift
//  Food
//
//  Created by Jia Chen Yee on 20/7/22.
//

import SwiftUI

struct LogView: View {
    
    var foodEntries: [FoodEntry]
    
    var body: some View {
        let entries = foodEntries.chunked {
            Calendar.current.isDate($0.dateTime, inSameDayAs: $1.dateTime)
        }
        
        NavigationView {
            List {
                ForEach(entries, id: \.first!.dateTime) { entryChunk in
                    Section(entryChunk.first!.dateTime.formatted(date: .long, time: .omitted)) {
                        ForEach(entryChunk, id: \.dateTime) { entry in
                            Text(entry.dateTime, style: .time)
                        }
                    }
                }
            }
            .navigationTitle("Log")
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(foodEntries: [])
    }
}
