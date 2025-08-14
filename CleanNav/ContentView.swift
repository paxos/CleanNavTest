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

//    ToolbarItemGroup {}
    
    ToolbarItemGroup(placement: .primaryAction) {
        Button {} label: {
            Label("a", systemImage: "circle.dashed")
                .labelStyle(.iconOnly)
        }
    }

    ToolbarItemGroup(placement: .secondaryAction) {
        Button("Secondary 1") {}
        Button("Secondary 2") {}
        Button("Secondary 3") {}
    }
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
    @State private var path: [String] = []
    @State private var search = ""

    // Stack
    let stackItems = [Item(name: "One"), Item(name: "two")]

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                Tab("Home", systemImage: "house", value: 1) {
                    Text("Welcome Home!")
                        .font(.largeTitle)
                        .navigationTitle("Title")
                        .navigationSubtitle("Subtitle")
                }

                Tab("Master/Detail", systemImage: "envelope.front", value: 2) {
                    NavigationSplitView {
                        List(notificationItems, selection: $notificationSelection) { item in
                            Text(item.name)
                                .tag(item.name)
                        }
                        .navigationTitle("List Title")
                        .navigationSubtitle("List Subtitle")
                        .navigationBarTitleDisplayMode(.inline)
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
                                    .navigationBarTitleDisplayMode(.inline)
                                    .searchable(text: $search, prompt: "Search")
                                    .toolbar(content: {
                                        myToolbarItems()
                                    })

                                } detail: {
                                    Text(notificationSelection.first?.description ?? "No selection")
                                        .navigationTitle("Detail Title")
                                        .navigationSubtitle("Detail Subtitle")
                                        .navigationBarTitleDisplayMode(.inline)
                                        .searchable(text: $search, prompt: "Search")
                                        .toolbar(content: {
                                            myToolbarItems()
                                        })
                                }
                            }
                        }
                        .searchable(text: $search, prompt: "Search")
                        .toolbar(content: {
                            myToolbarItems()
                        })
                        .navigationTitle("List Title")
                        .navigationSubtitle("List Subtitle")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }

                Tab("Master/Detail > Stack", systemImage: "square.split.2x1", value: 4) {
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
                        NavigationStack(path: $path) {
                            Button("Push") {
                                path.append("Pushed Content")
                            }
                            .buttonStyle(.glassProminent)
                            .searchable(text: $search, prompt: "Search")
                            .toolbar {
                                myToolbarItems()
                            }
                        }
                        .navigationDestination(for: String.self) { item in
                            Text(item)
                        }
                    }
                    .searchable(text: $search, prompt: "Search")
                    .toolbar {
                        myToolbarItems()
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
