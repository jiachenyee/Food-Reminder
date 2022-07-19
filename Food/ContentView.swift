//
//  ContentView.swift
//  Food
//
//  Created by Jia Chen Yee on 19/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var foodRecordManager = FoodRecordManager()
    
    var body: some View {
        NavigationView {
            Form {
                Section(foodRecordManager.lastMealMessage) {
                    ScrollView(.horizontal) {
                        FoodLogView(dateEntries: foodRecordManager.dateEntries)
                    }
                }
                
                NewEntrySection(foodRecordManager: foodRecordManager)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Food Reminder")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
