//
//  ContentView.swift
//  CleanNav
//
//  Created by Patrick Dinger on 7/21/25.
//

import SwiftUI
import SwiftUIIntrospect

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
    ToolbarItem(placement: .navigation) {
        Button("Action") {}
    }

    ToolbarItem(placement: .title) {
        Button("Center") {}
    }

    ToolbarItemGroup(placement: .automatic) {
        Button("Action 1") {}
        Button("Action 2") {}
        Button("Action 3") {}
    }

//    ToolbarItemGroup(placement: .primaryAction) {
//        Button("Bottom") {}
//    }
}

class ViewModel {
    var tabBarController: UITabBarController?

    func toggle() {
        guard let tabBarController else { return }
        print("Sidebar Hidden? \(tabBarController.isTabBarHidden)")
        tabBarController.setTabBarHidden(!tabBarController.isTabBarHidden, animated: true)
    }
}

struct ContentView: View {
    @AppStorage("tabSelection") private var selection: Int = 3

    let notificationItems = [Item(name: "Notification One"), Item(name: "Notification Two")]
    @State private var notificationSelection: Set<String> = []

    @State private var viewModel = ViewModel()

    // Stack
    let stackItems = [Item(name: "One"), Item(name: "two")]

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                Tab("Home", systemImage: "house", value: 1) {
                    Text("Welcome Home")
                        .font(.largeTitle)
                }

                Tab("Master/Detail", systemImage: "envelope.front", value: 2) {
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
                        List {
                            NavigationLink("One Level") {
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
                }
            }

            .toolbar(content: {
                myToolbarItems()

            })
            .tabViewStyle(.sidebarAdaptable)
            .introspect(.tabView, on: .iOS(.v26)) { tabBarController in
                viewModel.tabBarController = tabBarController
            }

            VStack {
                Spacer()

                Button("Toggle Floating Bar") {
                    viewModel.toggle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
