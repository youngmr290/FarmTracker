import SwiftUI

enum TaskFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case dueToday = "Today"
    case overdue = "Overdue"
    case completed = "Done"

    var id: String { rawValue }
}

struct AllTasksView: View {
    @Binding var tasks: [Task]
    var categories: [String]

    @State private var filter: TaskFilter = .all
    @State private var selectedCategory: String = ""

    private var filteredTasks: [Task] {
        tasks.filter { task in
            let passesCategory = selectedCategory.isEmpty || task.category == selectedCategory

            let passesFilter: Bool = {
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
            }()

            return passesCategory && passesFilter
        }
    }

    var body: some View {
        VStack {
            Picker("Filter", selection: $filter) {
                ForEach(TaskFilter.allCases) { f in
                    Text(f.rawValue).tag(f)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Picker("Category", selection: $selectedCategory) {
                Text("All Categories").tag("")
                ForEach(categories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)

            List {
                ForEach(filteredTasks) { task in
                    HStack {
                        Button(action: {
                            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                tasks[index].isCompleted.toggle()
                            }
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }

                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.headline)
                                .strikethrough(task.isCompleted)

                            if let date = task.dueDate {
                                Text("Due: \(date, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            if task.coordinate != nil {
                                Text("📍 Location set")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }

                            if let cat = task.category {
                                Text("📂 \(cat)")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteTask)
            }
        }
        .navigationTitle("All Tasks")
    }

    private func deleteTask(at offsets: IndexSet) {
        let taskIDsToDelete = offsets.map { filteredTasks[$0].id }
        tasks.removeAll { task in
            taskIDsToDelete.contains(task.id)
        }
    }

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }
}
