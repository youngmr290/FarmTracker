import SwiftUI

struct EditTaskView: View {
    @Binding var task: Task

    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Title", text: $task.title)
                Toggle("Completed", isOn: $task.isCompleted)
            }

            Section {
                DatePicker("Due Date", selection: Binding(
                    get: { task.dueDate ?? Date() },
                    set: { task.dueDate = $0 }
                ), displayedComponents: .date)
            }
        }
        .navigationTitle("Edit Task")
    }
}
