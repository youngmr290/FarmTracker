import SwiftUI
import CoreLocation

struct TaskDashboardView: View {
    @State private var allTasks: [Task] = []
    @State private var categories: [String] = []
    @State private var showingAddTaskSheet = false

    var body: some View {
        NavigationView {
            List {
                NavigationLink("📝 All Tasks", destination: AllTasksView(tasks: $allTasks, categories: categories))
                NavigationLink("🗺 Task Map", destination: TaskMapView(tasks: allTasks))
                NavigationLink("🗂 Manage Categories", destination: CategoryManagerView(categories: $categories, tasks: allTasks))
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Task Tracker")
            .navigationBarItems(trailing: Button(action: {
                showingAddTaskSheet = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddTaskSheet) {
                AddTaskView(tasks: $allTasks, categories: $categories)
            }
        }
    }
}
