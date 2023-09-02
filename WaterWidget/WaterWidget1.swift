//
//  WaterWidget.swift
//  WaterWidget
//
//  Created by Sofia Swidarowicz on 31/8/23.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(value: readCounter()))
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: ConfigurationAppIntent(value: readCounter()))
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    func readCounter() -> Int {
        guard let store = UserDefaults(suiteName: groupName) else {
            return -1
        }
        
        return store.integer(forKey: counterID)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct WaterWidgetEntryView : View {
    var entry: Provider.Entry
    var time: Date = .now

    var body: some View {
        VStack {
            Text("Intake of water:")
            
            Text(entry.configuration.value, format: .number)
            
            HStack {
                Button(intent: ConfigurationAppIntent()) {
                    Text("+1")
                }
                Button(intent: ResetCounterAppIntent(value: 0)) {
                    Text("Reset")
                }
            }
            HStack {
                Text("Time:")
                Text(time, style: .timer)
                    .padding(.horizontal, 10)
            }
        }
    }
}

struct WaterWidget1: Widget {
    let kind: String = "WaterWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WaterWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.value = 1
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.value = 5
        return intent
    }
    
    fileprivate static var waveHand: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.value = 8
        return intent
    }
}

#Preview(as: .systemSmall) {
    WaterWidget1()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
    SimpleEntry(date: .now, configuration: .waveHand)
    SimpleEntry(date: .now, configuration: .starEyes)
    SimpleEntry(date: .now, configuration: .smiley)
}

// containerBackground: navigation, tabView and widget https://developer.apple.com/documentation/swiftui/containerbackgroundplacement?changes=la
