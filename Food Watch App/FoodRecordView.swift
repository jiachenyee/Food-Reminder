//
//  FoodRecordView.swift
//  Food Watch App
//
//  Created by Jia Chen Yee on 20/7/22.
//

import SwiftUI

struct FoodRecordView: View {
    
    @ObservedObject var foodRecordManager: FoodRecordManager
    @State var date = Date.now
    
    var body: some View {
        VStack {
            VStack {
                Text(date, style: .date)
                Text(date, style: .time)
            }
                .font(.headline)
            
            Button {
                foodRecordManager.foodEntries.append(.init(dateTime: date))
                foodRecordManager.save(send: true)
            } label: {
                Text("Add Record")
            }
            .padding(.top)
        }
    }
}

struct FoodRecordView_Previews: PreviewProvider {
    static var previews: some View {
        FoodRecordView(foodRecordManager: .init())
    }
}
