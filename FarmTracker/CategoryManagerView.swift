import SwiftUI

struct CategoryManagerView: View {
    @Binding var categories: [String]
    var tasks: [Task]

    @State private var alertMessage: String?
    @State private var showAlert = false

    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                HStack {
                    Text(category)
                    Spacer()
                    Text("(\(taskCount(for: category)))")
                        .foregroundColor(.gray)
                    Button(action: {
                        handleDelete(category)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .navigationTitle("Manage Categories")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Cannot Delete"),
                  message: Text(alertMessage ?? ""),
                  dismissButton: .default(Text("OK")))
        }
    }

    private func taskCount(for category: String) -> Int {
        tasks.filter { $0.category == category }.count
    }

    private func handleDelete(_ category: String) {
        let count = taskCount(for: category)
        if count > 0 {
            alertMessage = "You cannot delete the category '\(category)' because it is still used by \(count) task(s)."
            showAlert = true
        } else {
            if let index = categories.firstIndex(of: category) {
                categories.remove(at: index)
            }
        }
    }
}
