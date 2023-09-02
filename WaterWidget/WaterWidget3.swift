
//
//  WaterWidget.swift
//  WaterWidget
//
//  Created by Sofia Swidarowicz on 31/8/23.
//

import WidgetKit
import SwiftUI

struct Provider3: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry3 {
        SimpleEntry3(date: Date(), configuration: ConfigurationAppIntent3(value: readCounter()))
    }

    func snapshot(for configuration: ConfigurationAppIntent3, in context: Context) async -> SimpleEntry3 {
        SimpleEntry3(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent3, in context: Context) async -> Timeline<SimpleEntry3> {
        var entries: [SimpleEntry3] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let count = readCounter()
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry3(date: entryDate, configuration: ConfigurationAppIntent3(value: count))
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

struct SimpleEntry3: TimelineEntry, Hashable {
    
    let date: Date
    let configuration: ConfigurationAppIntent3
    var simplyId: String = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(configuration)
       
        hasher.combine(simplyId)
    }
    
    static func == (lhs: SimpleEntry3, rhs: SimpleEntry3) -> Bool {
        lhs.date == rhs.date &&
        lhs.configuration == rhs.configuration &&
        lhs.simplyId == rhs.simplyId
    }
}

struct WaterWidgetEntryView3 : View {
    var entry: Provider3.Entry
    var time: Date = .now
    @Environment(\.showsWidgetContainerBackground) var showWidgetBackground
    @Environment(\.widgetRenderingMode) var renderingMode
    
    @ViewBuilder
    func makeRendingMode() -> some View {
        if renderingMode == .vibrant {
            VStack {
                Text(time, style: .timer)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.top, 2)
            }
            VStack {
                Text(makeEmojisTitle())
                    .padding(.top, 5)
            }
        } else if (!showWidgetBackground && renderingMode == .fullColor) {
            VStack {
                Text(time, style: .timer)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
            }
            VStack {
                Text(makeEmojisTitle())
                    .padding(.top, 3)
            }
        } else {
            VStack {
                Text(time, style: .timer)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            VStack {
                Text(makeEmojisTitle())
            }
        }
    }

    var body: some View {
        VStack {
            Text("Intake of water:")
                .font(.headline)
            Divider()
                .background(.white)
            Text(entry.configuration.value, format: .number)
                .contentTransition(.numericText())
                
            
            HStack {
                Button(intent: ConfigurationAppIntent3()) {
                    Text("+")
                    // new iOS 17
                        .textScale(.secondary)
                    + Text("1")
                }
                
                Button(intent: ResetCounterAppIntent(value: 0)) {
                    Text("Reset")
                }
            }
            
            VStack {
                makeRendingMode()
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
    
    func makeEmojisTitle() -> String {
        var title = ""
        let count = entry.configuration.value
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
        return title
    }
}

struct WaterWidget3: Widget {
    let kind: String = "WaterWidget3"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent3.self, provider: Provider3()) { entry in
            WaterWidgetEntryView3(entry: entry)
                .containerBackground(.black.gradient, for: .widget)
                
        }
        .configurationDisplayName("Take water often 2")
        .description("Displays a water intake amount 2")
        .supportedFamilies(
            [.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryInline, .accessoryRectangular]
        )
    }
}

extension ConfigurationAppIntent3 {
    fileprivate static var niceStart: ConfigurationAppIntent3 {
        let intent = ConfigurationAppIntent3()
        intent.value = 1
        return intent
    }
    
    fileprivate static var good: ConfigurationAppIntent3 {
        let intent = ConfigurationAppIntent3()
        intent.value = 5
        return intent
    }
    
    fileprivate static var accomplished: ConfigurationAppIntent3 {
        let intent = ConfigurationAppIntent3()
        intent.value = 10
        return intent
    }
}

#Preview(as: .systemSmall) {
    WaterWidget3()
} timeline: {
    SimpleEntry3(date: .now, configuration: .niceStart)
    SimpleEntry3(date: .now, configuration: .good)
    SimpleEntry3(date: .now, configuration: .accomplished)
}
