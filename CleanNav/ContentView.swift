//
//  ContentView.swift
//  CleanNav
//
//  Created by Patrick Dinger on 7/21/25.
//

import SwiftUI

struct Item: Identifiable, Hashable {
    var id: String { name }
    let name: String
}

struct TestNavigationStack: View {
    let stackItems = [Item(name: "One"), Item(name: "two")]

    var body: some View {
        NavigationStack {
            List(stackItems) { item in
                NavigationLink(item.name, value: item)
            }

            .navigationDestination(for: Item.self) { item in
                Text(item.name)
            }
        }
    }
}

struct TestNavigationSplitView: View {
    let stackItems = [Item(name: "One"), Item(name: "two")]
    @State private var employeeIds: Set<String> = []

    var body: some View {
        NavigationSplitView {
            List(stackItems, selection: $employeeIds) { item in
                Text(item.name)
            }

        } detail: {
            Text("\(stackItems.count) selected")
        }
    }
}

@ToolbarContentBuilder
func myToolbarItems() -> some ToolbarContent {
    ToolbarItem {
        Button("Action") {}
    }
    ToolbarItemGroup(placement: .automatic) {
        Button("Action 1") {}
        Button("Action 2") {}
        Button("Action 3") {}
        Button("Action 4") {}
        Button("Action 5") {}
        Button("Action 6") {}
    }

//    ToolbarItemGroup(placement: .primaryAction) {
//        Button("Bottom") {}
//    }
}

struct ContentView: View {
    @AppStorage("tabSelection") private var selection: Int = 3

    let notificationItems = [Item(name: "Notification One"), Item(name: "Notification Two")]
    @State private var notificationSelection: Set<String> = []

    // Stack
    let stackItems = [Item(name: "One"), Item(name: "two")]

    var body: some View {
        TabView(selection: $selection) {
            Tab("Home", systemImage: "house", value: 1) {
                Text("Welcome Home")
                    .font(.largeTitle)
            }

            Tab("Notifications", systemImage: "envelope.front", value: 2) {
                NavigationSplitView {
                    List(notificationItems, selection: $notificationSelection) { item in
                        Text(item.name)
                    }
                    .navigationTitle("List Title")
                    .navigationSubtitle("List Subtitle")
                    .toolbar {
                        myToolbarItems()
                    }
                } detail: {
                    Text(notificationSelection.first?.description ?? "No selection")
                        .navigationTitle("Detail Title")
                        .navigationSubtitle("Detail Subtitle")
                        .toolbar {
                            myToolbarItems()
                        }
                }
                .toolbar {
                    myToolbarItems()
                }
            }

            Tab("Stack", systemImage: "square.stack", value: 3) {
                NavigationStack {
                    List(stackItems) { item in
                        NavigationLink(item.name, value: item)
                    }

                    .navigationDestination(for: Item.self) { item in
                        NavigationSplitView {
                            List(notificationItems, selection: $notificationSelection) { item in
                                Text(item.name)
                            }
                            .navigationTitle("List Title")
                            .navigationSubtitle("List Subtitle")
                            .toolbar(content: {
                                myToolbarItems()
                            })

                        } detail: {
                            Text(notificationSelection.first?.description ?? "No selection")
                                .navigationTitle("Detail Title")
                                .navigationSubtitle("Detail Subtitle")
                                .toolbar(content: {
                                    myToolbarItems()
                                })
                        }

                    }
                }
            }
//            .customizationID("com.myApp.notifications")

//            Tab("Explore", systemImage: "play") {
//                Text("Explore")
//            }
//            .customizationID("com.myApp.explore")
//
//            Tab("Profile", systemImage: "play") {
//                Text("Profile")
//            }
//            .customizationID("com.myApp.play")
//
//            Tab(role: .search) {
//                // ...
//            }
        }
        .toolbar(content: {
            myToolbarItems()
//            ToolbarItemGroup(placement: .bottomBar) {
//                Button("Bottom Action") {}
//            }
        })
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
