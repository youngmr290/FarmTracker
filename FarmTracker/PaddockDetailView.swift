import SwiftUI

struct PaddockDetailView: View {
    @State var paddock: Paddock
    @State private var showAddTaskSheet = false
    @State private var filter: TaskFilter = .all

    enum TaskFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case dueToday = "Today"
        case overdue = "Overdue"
        case completed = "Done"

        var id: String { rawValue }
    }

    var filteredTasks: [Task] {
        paddock.tasks.filter { task in
            switch filter {
            case .all:
                return true
            case .dueToday:
                guard let due = task.dueDate else { return false }
                return Calendar.current.isDateInToday(due)
            case .overdue:
                guard let due = task.dueDate else { return false }
                return due < Date() && !task.isCompleted
            case .completed:
                return task.isCompleted
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Paddock: \(paddock.name)")
                .font(.title)
            Text("Sheep Count: \(paddock.sheepCount)")

            HStack {
                Text("Tasks").font(.headline)
                Spacer()
                Button(action: {
                    showAddTaskSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }

            Picker("Filter", selection: $filter) {
                ForEach(TaskFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical, 5)

            List {
                ForEach(filteredTasks) { task in
                    NavigationLink(destination: EditTaskView(task: binding(for: task))) {
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle(paddock.name)
        .sheet(isPresented: $showAddTaskSheet) {
            AddTaskView(paddock: $paddock)
        }
    }

    private func binding(for task: Task) -> Binding<Task> {
        guard let index = paddock.tasks.firstIndex(where: { $0.id == task.id }) else {
            fatalError("Task not found")
        }
        return $paddock.tasks[index]
    }

    private func toggleTaskCompletion(taskID: UUID) {
        if let index = paddock.tasks.firstIndex(where: { $0.id == taskID }) {
            paddock.tasks[index].isCompleted.toggle()
        }
    }
}
