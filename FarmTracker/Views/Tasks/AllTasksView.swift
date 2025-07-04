import SwiftUI
import CoreData

enum TaskFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case dueToday = "Today"
    case overdue = "Overdue"
    case completed = "Done"

    var id: String { rawValue }
}

struct AllTasksView: View {
    @Environment(\.managedObjectContext) private var ctx

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskEntry.dueDate, ascending: true)],
        animation: .default
    ) private var allTasks: FetchedResults<TaskEntry>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) private var categories: FetchedResults<Category>

    @State private var filter: TaskFilter = .all
    @State private var selectedCategory: Category?

    private var filteredTasks: [TaskEntry] {
        allTasks.filter { task in
            let matchesCategory = selectedCategory == nil || task.category == selectedCategory

            let matchesFilter: Bool = {
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

            return matchesCategory && matchesFilter
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
                Text("All Categories").tag(Category?.none)
                ForEach(categories) { category in
                    Text(category.name ?? "").tag(Optional(category))
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)

            List {
                ForEach(filteredTasks) { task in
                    HStack {
                        Button(action: {
                            task.isCompleted.toggle()
                            try? ctx.save()
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }

                        VStack(alignment: .leading) {
                            Text(task.title ?? "")
                                .font(.headline)
                                .strikethrough(task.isCompleted)

                            if let date = task.dueDate {
                                Text("Due: \(date, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            if task.latitude != 0 || task.longitude != 0 {
                                Text("📍 Location set")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }

                            if let cat = task.category {
                                Text("📂 \(cat.name ?? "")")
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
        for index in offsets {
            let task = filteredTasks[index]
            ctx.delete(task)
        }
        try? ctx.save()
    }

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }
}
