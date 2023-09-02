//
//  ContentView.swift
//  WdigetIsland
//
//  Created by Sofia Swidarowicz on 31/8/23.
//

import SwiftUI
import WidgetKit

//let groupName = "group.persistance"
//let counterID = "count"

struct ContentView: View {
    // New iOS 17
    @AppStorage(counterID) var count = 0
    // Another way to use it
    //@AppStorage(counterID, store: UserDefaults(suiteName: groupName)) var count: Int = 0

    var body: some View {
        VStack {
            Text(count, format: .number)
                
            HStack {
                Button {
                    count += 1
                    WidgetCenter.shared.reloadAllTimelines()
                    //WidgetCenter.shared.reloadTimelines(ofKind: "WaterWidget2")
                } label: {
                     Text("+").textScale(.secondary) + Text("1")
                }
                .buttonStyle(.borderedProminent)
               
                Button {
                    //reset()
                    count = 0
                    WidgetCenter.shared.reloadAllTimelines()
                } label: {
                     Text("Reset")
                }.buttonStyle(.borderedProminent)
            }
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white)
        .padding()
        .background(.black.gradient)
    }
    
    // Older way to store
    func reset() {
        guard let store = UserDefaults(suiteName: groupName) else {
            print("we couldn't get the correct value from the data base")
            return
        }
        
        store.setValue(0, forKey: "count")
    }
}

#Preview {
    ContentView()
}
