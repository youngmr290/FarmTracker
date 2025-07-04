import SwiftUI
import MapKit
import CoreData

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var ctx

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
    ) private var categories: FetchedResults<Category>

    @State private var title = ""
    @State private var dueDate = Date()
    @State private var includeDueDate = false
    @State private var includeLocation = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -31.95, longitude: 115.86),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    @State private var selectedCategoryID: NSManagedObjectID? = nil
    @State private var newCategory: String = ""

    var body: some View {
        NavigationView {
            Form {
                // MARK: Title Section
                Section(header: Text("Task Title")) {
                    TextField("Enter task name", text: $title)
                }

                // MARK: Due Date Section
                Section {
                    Toggle("Add due date", isOn: $includeDueDate)
                    if includeDueDate {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    }
                }

                // MARK: Location Section
                Section {
                    Toggle("Add location", isOn: $includeLocation)
                    if includeLocation {
                        Map(coordinateRegion: $mapRegion, interactionModes: [.all], annotationItems: annotation) { item in
                            MapPin(coordinate: item.coordinate)
                        }
                        .frame(height: 200)
                        .gesture(TapGesture().onEnded {
                            let center = mapRegion.center
                            selectedCoordinate = center
                        })

                        if selectedCoordinate != nil {
                            Text("📍 Location selected")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }

                // MARK: Category Section
                Section(header: Text("Category (Optional)")) {
                    Picker("Select Existing", selection: $selectedCategoryID) {
                        Text("None").tag(nil as NSManagedObjectID?)
                        ForEach(categories, id: \.objectID) { category in
                            Text(category.name ?? "Unnamed")
                                .tag(category.objectID as NSManagedObjectID?)
                        }
                    }

                    TextField("Or Add New Category", text: $newCategory)
                }

                // MARK: Save Button
                Section {
                    Button("Save Task") {
                        print("🟢 Save button tapped")

                        let task = TaskEntry(context: ctx)
                        task.farmId = "local-farm"
                        task.updatedAt = Date()
                        task.title = title
                        task.dueDate = includeDueDate ? dueDate : nil
                        task.isCompleted = false
                        task.id = UUID()

                        if let coord = selectedCoordinate {
                            task.latitude = coord.latitude
                            task.longitude = coord.longitude
                        }

                        if !newCategory.isEmpty {
                            let category = Category(context: ctx)
                            category.name = newCategory
                            category.id = UUID()
                            task.category = category
                        } else if let id = selectedCategoryID,
                                  let picked = categories.first(where: { $0.objectID == id }) {
                            task.category = picked
                        }

                        do {
                            try ctx.save()
                            print("✅ Save succeeded")
                        } catch {
                            print("❌ Save failed: \(error)")
                        }

                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("New Task")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    struct MapPinLocation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    var annotation: [MapPinLocation] {
        selectedCoordinate.map { [MapPinLocation(coordinate: $0)] } ?? []
    }
}
