//
//  FoodWidget.swift
//  FoodWidget
//
//  Created by Jia Chen Yee on 20/7/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct FoodWidgetEntryView : View {
    var entry: Provider.Entry

    @StateObject var foodRecordManager = FoodRecordManager()
    
    var body: some View {
        HStack {
            Spacer()
            LazyHGrid(rows: [.init(.adaptive(minimum: 16), spacing: 1)]) {
                ForEach(foodRecordManager.dateEntries) { entry in
                    Rectangle()
                        .fill(entry.mealCount == 0 ? Color(uiColor: .systemGray5) : Color.accentColor.opacity(Double(entry.mealCount) / 3))
                        .cornerRadius(4)
                        .frame(width: 16, height: 16)
                }
            }
        }
        .padding()
    }
}

@main
struct FoodWidget: Widget {
    let kind: String = "FoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FoodWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Food Log")
        .description("When did you last eat")
    }
}

struct FoodWidget_Previews: PreviewProvider {
    static var previews: some View {
        FoodWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
