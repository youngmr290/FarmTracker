import SwiftUI

struct AllTasksView: View {
    var farm: Farm

    var body: some View {
        List {
            ForEach(farm.paddocks) { paddock in
                Section(header: Text(paddock.name)) {
                    ForEach(paddock.tasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            VStack(alignment: .leading) {
                                Text(task.title)
                                if let date = task.dueDate {
                                    Text("Due: \(dateFormatter.string(from: date))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("All Tasks")
    }

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }
}
