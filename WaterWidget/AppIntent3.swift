//
//  AppIntent.swift
//  WaterWidget
//
//  Created by Sofia Swidarowicz on 31/8/23.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent3: WidgetConfigurationIntent, Equatable, Hashable {
    
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
        let count = readCounter() + 1
        writerCounter(value: count)
        return .result()
    }

    static func == (lhs: ConfigurationAppIntent3, rhs: ConfigurationAppIntent3) -> Bool {
        lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    var hashValue: Int {
        value.hashValue
    }

    func writerCounter(value: Int) {
        guard let store = UserDefaults(suiteName: groupName) else {
            return
        }
        store.setValue(value, forKey: counterID)
    }
    
    func readCounter() -> Int {
        guard let store = UserDefaults(suiteName: groupName) else {
            return -1
        }
        
        return store.integer(forKey: counterID)
    }
    
    func reset() {
        guard let store = UserDefaults(suiteName: groupName) else {
            return
        }
        
        store.setValue(0, forKey: counterID)
    }
}
