//
//  ContentView.swift
//  Food Watch App
//
//  Created by Jia Chen Yee on 19/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var foodRecordManager = FoodRecordManager()
    
    var body: some View {
        TabView {
            FoodRecordView(foodRecordManager: foodRecordManager)
            
            ScrollView(.horizontal) {
                FoodLogView(dateEntries: foodRecordManager.dateEntries)
                    .padding(.top)
            }
        }
        .tabViewStyle(.page)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
