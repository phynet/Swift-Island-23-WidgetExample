//
//  AppIntent4.swift
//  WaterWidgetExtension
//
//  Created by Sofia Swidarowicz on 2/9/23.
//

 
import WidgetKit
import AppIntents

struct ConfigurationAppIntent4: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Water 4"
    @Parameter(title: "Toggle Intent", default: "")
    var id: String
    
    init(id: String) {
        self.id = id
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult {
        if let index = TaskDataModel.shared.tasks.firstIndex(where: {
            $0.id == id
        }) {
            TaskDataModel.shared.tasks[index].isCompleted.toggle()
            print("Updated!")
        }
        return .result()
    }
}
