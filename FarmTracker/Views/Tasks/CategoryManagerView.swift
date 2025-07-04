import SwiftUI
import CoreData

struct CategoryManagerView: View {
    @Environment(\.managedObjectContext) private var ctx

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)],
        animation: .default
    ) private var categories: FetchedResults<Category>

    @State private var alertMessage: String?
    @State private var showAlert = false

    var body: some View {
        List {
            ForEach(categories) { category in
                HStack {
                    Text(category.name ?? "")
                    Spacer()
                    Text("(\(category.tasks?.count ?? 0))")
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

    private func handleDelete(_ category: Category) {
        let count = category.tasks?.count ?? 0
        if count > 0 {
            alertMessage = "You cannot delete the category '\(category.name)' because it is still used by \(count) task(s)."
            showAlert = true
        } else {
            ctx.delete(category)
            try? ctx.save()
        }
    }
}
