import SwiftUI
import CoreData

struct TaskDashboardView: View {
    @Environment(\.managedObjectContext) private var ctx

    var body: some View {
        NavigationView {
            List {
                NavigationLink("📝 All Tasks", destination: AllTasksView())
                NavigationLink("🗺 Task Map", destination: TaskMapView())
                NavigationLink("🗂 Manage Categories", destination: CategoryManagerView())
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Task Tracker")
            .navigationBarItems(trailing: NavigationLink(destination: AddTaskView()) {
                Image(systemName: "plus")
            })
        }
    }
}
