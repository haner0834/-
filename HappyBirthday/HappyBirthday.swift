//
//  HappyBirthday.swift
//  HappyBirthday
//
//  Created by Andy Lin on 2024/2/4.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    let herBirthday = DateComponents(year: 2024, month: 2, day: 25, hour: 0,minute: 0, second: 0)
    let calendar = Calendar.current
    
    func placeholder(in context: Context) -> DateEntry {
        DateEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> DateEntry {
        DateEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent = ConfigurationAppIntent(), in context: Context) async -> Timeline<DateEntry> {
        var entries: [DateEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for secondOffset in 0 ..< 60 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            
            let bd = calendar.date(from: herBirthday)!
            let gapToHerBD = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate, to: bd)
            let date = calendar.date(from: gapToHerBD)!
            
            let entry = DateEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct DateEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct HappyBirthdayEntryView : View {
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var entry: DateEntry

    var body: some View {
        VStack {
            let gapToBD: DateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: entry.date)
            
            Text("あと")
            LazyVGrid(columns: columns) {
                Text(String(format: "%02d", gapToBD.day!))
//                    .id("\(gapToBD.day)day")
//                    .clockTextAnimation()
                
                Text(String(format: "%02d", gapToBD.hour!))
//                    .id("\(gapToBD.hour)hour")
//                    .clockTextAnimation()
                
                Text(String(format: "%02d", gapToBD.minute!))
//                    .id("\(gapToBD.minute)min")
//                    .clockTextAnimation()
                
                Text("DAY")
                
                Text("MIN")
                
                Text("SEC")
            }
            .bold()
            .font(.caption)
        }
    }
}

struct HappyBirthday: Widget {
    let kind: String = "HappyBirthday"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            HappyBirthdayEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    HappyBirthday()
} timeline: {
    DateEntry(date: .now, configuration: .smiley)
    DateEntry(date: .now, configuration: .starEyes)
}
