import SwiftUI
import MapKit

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var tasks: [Task]
    @Binding var categories: [String]

    @State private var title = ""
    @State private var dueDate = Date()
    @State private var includeDueDate = false
    @State private var includeLocation = false
    @State private var selectedCoordinate: CLLocationCoordinate2D?

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -31.95, longitude: 115.86),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var selectedCategory: String = ""
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
                
                Section(header: Text("Category (Optional)")) {
                    Picker("Select Existing", selection: $selectedCategory) {
                        Text("None").tag("")
                        ForEach(categories, id: \.self, content: Text.init)
                    }

                    TextField("Or Add New Category", text: $newCategory)
                }

                // MARK: Save Button
                Section {
                    Button("Save Task") {
                        let categoryToUse: String? = {
                            if !newCategory.isEmpty {
                                if !categories.contains(newCategory) {
                                    categories.append(newCategory)
                                }
                                return newCategory
                            } else if !selectedCategory.isEmpty {
                                return selectedCategory
                            } else {
                                return nil
                            }
                        }()

                        let task = Task(
                            title: title,
                            dueDate: includeDueDate ? dueDate : nil,
                            coordinate: includeLocation ? selectedCoordinate : nil,
                            category: categoryToUse
                        )
                        tasks.append(task)
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

    // MARK: Pin Wrapper for Map
    struct MapPinLocation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    var annotation: [MapPinLocation] {
        selectedCoordinate.map { [MapPinLocation(coordinate: $0)] } ?? []
    }
}
