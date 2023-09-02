//
//  WaterWidget.swift
//  WaterWidget
//
//  Created by Sofia Swidarowicz on 31/8/23.
//

import WidgetKit
import SwiftUI

struct Provider2: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry2 {
        SimpleEntry2(title: "", date: Date(), configuration: ConfigurationAppIntent2(value: readCounter()))
    }

    func snapshot(for configuration: ConfigurationAppIntent2, in context: Context) async -> SimpleEntry2 {
        SimpleEntry2(title: "", date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent2, in context: Context) async -> Timeline<SimpleEntry2> {
        var entries: [SimpleEntry2] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let count = readCounter()
        var title = ""
        if count == 0 {
            title = "☺️"
        } else if count >= 1 && count <= 4 {
            title = "🙂"
        } else if count >= 5 && count <= 8 {
            title = "🤩"
        } else if count >= 9 && count <= 10 {
            title = "🚀"
        } else {
            title = "🌊"
        }
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry2(title: title, date: entryDate, configuration: ConfigurationAppIntent2(value: count))
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

struct SimpleEntry2: TimelineEntry, Hashable {
    let title: String
    let date: Date
    let configuration: ConfigurationAppIntent2
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(configuration)
    }
    
    static func == (lhs: SimpleEntry2, rhs: SimpleEntry2) -> Bool {
        lhs.date == rhs.date &&
        lhs.configuration == rhs.configuration &&
        lhs.title == rhs.title
    }
}

struct WaterWidgetEntryView2 : View {
    var entry: Provider2.Entry
    var time: Date = .now

    var body: some View {
        VStack {
            Text("Intake of water:")
                .font(.headline)
            Divider()
                .background(.white)
            Text(entry.configuration.value, format: .number)
                .contentTransition(.numericText())
                
            
            HStack {
                Button(intent: ConfigurationAppIntent2()) {
                    Text("+")
                    // new iOS 17
                        .textScale(.secondary)
                    + Text("1")
                        
                }
                
                Button(intent: ConfigurationAppIntent2(value: 0)) {
                    Text("Reset")
                }
            }
            VStack {
                Text(time, style: .timer)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            VStack {
                Text(entry.title)
            }
            // new iOS 17
            .id(entry)
            // new iOS 17
            .transition(.push(from: .bottom))
            .animation(.smooth(duration: 1.5), value: entry.date)
        }
       
        .fontDesign(.rounded)
        .buttonStyle(.borderedProminent)
        // new iOS 17
        .foregroundStyle(.white)
    }
}

struct WaterWidget2: Widget {
    let kind: String = "WaterWidget2"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent2.self, provider: Provider2()) { entry in
            WaterWidgetEntryView2(entry: entry)
                .containerBackground(.black.gradient, for: .widget)
        }
    }
}

extension ConfigurationAppIntent2 {
    fileprivate static var niceStart: ConfigurationAppIntent2 {
        let intent = ConfigurationAppIntent2()
        intent.value = 1
        return intent
    }
    
    fileprivate static var good: ConfigurationAppIntent2 {
        let intent = ConfigurationAppIntent2()
        intent.value = 5
        return intent
    }
    
    fileprivate static var accomplished: ConfigurationAppIntent2 {
        let intent = ConfigurationAppIntent2()
        intent.value = 8
        return intent
    }
}

#Preview(as: .systemSmall) {
    WaterWidget2()
} timeline: {
    SimpleEntry2(title: "☺️", date: .now, configuration: .niceStart)
    SimpleEntry2(title: "🙂", date: .now, configuration: .good)
    SimpleEntry2(title: "🚀", date: .now, configuration: .accomplished)
}
