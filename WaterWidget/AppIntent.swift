//
//  AppIntent.swift
//  WaterWidget
//
//  Created by Sofia Swidarowicz on 31/8/23.
//

import WidgetKit
import AppIntents

let groupName = "group.persistance"
let counterID = "count"

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Amount of Water", default: 0)
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    init() {
        self.value = -1
    }
    
    func perform() async throws -> some IntentResult {
        guard let store = UserDefaults(suiteName: groupName) else {
            return .result()
        }
        
        let count = store.integer(forKey: "count")
        store.setValue(count + 1, forKey: "count")
        return .result()
    }
}

struct ResetCounterAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    
    @Parameter(title: "Reset Count", default: 0)
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    init() {
        self.value = -1
    }
    
    func perform() async throws -> some IntentResult {
        guard let store = UserDefaults(suiteName: groupName) else {
            return .result()
        }
        
        store.setValue(value, forKey: counterID)
        return .result()
    }
}
