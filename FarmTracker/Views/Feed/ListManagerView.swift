import SwiftUI

struct ListManagerView: View {
    @Environment(\.presentationMode) var presentationMode

    let title: String
    @Binding var items: [String]
    var protectedItems: [String] = [] // can't delete these

    @State private var newItem: String = ""

    var body: some View {
        NavigationView {
            Form {
                // ➕ Add new item
                Section(header: Text("Add New")) {
                    HStack {
                        TextField("New \(String(title.dropLast()))", text: $newItem)
                        Button("Add") {
                            let trimmed = newItem.trimmingCharacters(in: .whitespaces)
                            if !trimmed.isEmpty && !items.contains(trimmed) {
                                items.append(trimmed)
                                newItem = ""
                            }
                        }
                        .disabled(newItem.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                // 📋 List existing items
                Section(header: Text("Current \(title)")) {
                    List {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text(item)
                                Spacer()
                                if protectedItems.contains(item) {
                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle("Manage \(title)")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    // 🗑 Safe delete
    private func deleteItems(at offsets: IndexSet) {
        let deletable = offsets
            .map { items[$0] }
            .filter { !protectedItems.contains($0) }

        items.removeAll { deletable.contains($0) }
    }
}
