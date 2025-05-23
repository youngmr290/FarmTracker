import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var paddock: Paddock
    @State private var taskTitle: String = ""
    @State private var dueDate: Date? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task title", text: $taskTitle)
                }

                Section {
                    DatePicker("Due Date (optional)", selection: Binding(
                        get: { dueDate ?? Date() },
                        set: { dueDate = $0 }
                    ), displayedComponents: .date)
                }

                Button("Add Task") {
                    let newTask = Task(title: taskTitle, isCompleted: false, dueDate: dueDate)
                    paddock.tasks.append(newTask)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(taskTitle.isEmpty)
            }
            .navigationBarTitle("New Task", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
