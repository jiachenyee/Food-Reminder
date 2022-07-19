//
//  ContentView.swift
//  Food
//
//  Created by Jia Chen Yee on 19/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var foodRecordManager = FoodRecordManager()
    @State var isLogPresented = false
    
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
                        isLogPresented = true
                    } label: {
                        Image(systemName: "list.bullet.rectangle.portrait")
                    }
                }
            }
            .navigationTitle("Food Reminder")
            .sheet(isPresented: $isLogPresented) {
                LogView(foodEntries: foodRecordManager.foodEntries)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
