//
//  WaterWidget4.swift
//  WaterWidgetExtension
//
//  Created by Sofia Swidarowicz on 2/9/23.
//

import SwiftUI
import WidgetKit

struct WidgetToggleProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> WidgetToggleTimelineEntry {
        let tasks = Array(TaskDataModel.shared.tasks)
        return WidgetToggleTimelineEntry(lastThreeTasks: tasks)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent4, in context: Context) async -> WidgetToggleTimelineEntry {
        let tasks = Array(TaskDataModel.shared.tasks)
        return WidgetToggleTimelineEntry(lastThreeTasks: tasks)
    }
    
    func timeline(for configuration: ConfigurationAppIntent4, in context: Context) async -> Timeline<WidgetToggleTimelineEntry> {
        let tasks = Array(TaskDataModel.shared.tasks)
        let entries = [WidgetToggleTimelineEntry(lastThreeTasks: tasks)]
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct BasicWidget: Widget {
    let kind: String = "BasicWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent4.self, provider: WidgetToggleProvider()) { entry in
            BasicToggleWidgetView(entry: entry)
                .containerBackground(.black.gradient, for: .widget)
        }
        .configurationDisplayName("Ranger Detail")
                .description("See your favorite ranger.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular, .accessoryInline, .accessoryRectangular])
    }
}

struct WidgetToggleTimelineEntry: TimelineEntry {
    let date: Date = .now
    var lastThreeTasks: [TaskModel]
}

struct StatusView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        if case .accessoryRectangular = family {
            EmptyView()
        }
    }
}

struct EmptyView: View {
    var body: some View {
        Text("No Water tasks found")
            .font(.headline)
            .foregroundStyle(.white, .gray)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct BasicToggleWidgetView: View {
    var entry: WidgetToggleProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
             
            if entry.lastThreeTasks.isEmpty {
                EmptyView()
            } else {
                Text("Water Task")
                    .font(.headline)
                    .foregroundStyle(.white, .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                ForEach(entry.lastThreeTasks.sorted {
                    !$0.isCompleted && $1.isCompleted
                }) { task in
                    HStack(spacing: 6) {
                        Button(intent: ConfigurationAppIntent4(id: task.id)) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.taskTitle)
                                .textScale(.secondary)
                                .lineLimit(1)
                                .foregroundStyle(.white, .gray)
                                .strikethrough(task.isCompleted, pattern: .solid, color: .primary)
                            Divider()
                                .overlay(.white)
                        }
                    }
                    if task.id != entry.lastThreeTasks.last?.id {
                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview(as: .accessoryRectangular) {
    BasicWidget()
} timeline: {
    WidgetToggleTimelineEntry(lastThreeTasks: TaskDataModel.shared.tasks)
}

