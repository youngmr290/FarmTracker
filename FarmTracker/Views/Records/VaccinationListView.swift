import SwiftUI
import CoreData

struct VaccinationListView: View {
    @Environment(\.managedObjectContext) private var ctx
    @State private var showingAddSheet = false

    // Filter state
    @State private var filterFrom  = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    @State private var filterTo    = Date()
    @State private var filterClass = ""

    // Build predicate from filter values
    private var predicate: NSPredicate {
        var parts: [NSPredicate] = [
            NSPredicate(format: "dateGiven >= %@ AND dateGiven <= %@",
                        filterFrom as NSDate, filterTo as NSDate)
        ]
        if !filterClass.isEmpty {
            parts.append(NSPredicate(format: "animalClass == %@", filterClass))
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: parts)
    }

    // Base fetch (we’ll filter in-memory for simplicity)
    @FetchRequest private var records: FetchedResults<VaccinationRecord>
    init() {
        _records = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \VaccinationRecord.dateGiven,
                                               ascending: false)],
            predicate: nil,
            animation: .default)
    }

    var body: some View {
        VStack {
            // MARK: Filters
            GroupBox {
                DatePicker("From", selection: $filterFrom, displayedComponents: .date)
                DatePicker("To",   selection: $filterTo,   displayedComponents: .date)
                TextField("Animal Class filter (optional)", text: $filterClass)
            }
            .padding(.horizontal)

            // MARK: Summary
            Text("Total treatments: \(records.filter { predicate.evaluate(with: $0) }.count)")
                .font(.headline)
                .padding(.top, 4)

            // MARK: List
            List {
                ForEach(records.filter { predicate.evaluate(with: $0) }) { rec in
                    NavigationLink(destination: VaccinationDetailView(record: rec)) {
                        VStack(alignment: .leading) {
                            Text(rec.product ?? "Unnamed").font(.headline)
                            Text(rec.animalClass ?? "").font(.subheadline)
                            HStack {
                                Text(rec.dateGiven ?? Date(), style: .date)
                                Spacer()
                                Text("Qty: \(rec.numberOfStock)")
                            }
                            .font(.caption)

                            if let batch = rec.batchNumber {
                                Text("Batch: \(batch)").font(.caption2)
                            }
                        }
                    }
                }
            }
        }
        // Attach nav chrome to whole screen
        .navigationTitle("Records")
        .toolbar {
            Button {
                showingAddSheet = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            // Sheet embeds its own nav bar
            NavigationView {
                AddVaccinationView()
            }
        }
    }
}
