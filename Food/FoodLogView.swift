//
//  FoodLogView.swift
//  Food
//
//  Created by Jia Chen Yee on 19/7/22.
//

import SwiftUI

struct FoodLogView: View {
    
    var dateEntries: [DateEntry]
    
    var body: some View {
        ScrollViewReader { value in
            LazyHGrid(rows: [.init(.adaptive(minimum: 20), spacing: 8)]) {
                ForEach(dateEntries) { entry in
                    Rectangle()
                        .fill(entry.mealCount == 0 ? Color(uiColor: .systemGray5) : Color.accentColor.opacity(Double(entry.mealCount) / 3))
                        .cornerRadius(4)
                        .frame(width: 20, height: 20)
                }
            }
            .onAppear {
                guard let lastID = dateEntries.last?.id else { return }
                value.scrollTo(lastID)
            }
        }
        .frame(height: 7 * 28)
    }
}

struct FoodLogView_Previews: PreviewProvider {
    static var previews: some View {
        FoodLogView(dateEntries: [])
    }
}
