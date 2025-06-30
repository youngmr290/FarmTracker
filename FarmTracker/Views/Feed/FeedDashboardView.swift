import SwiftUI
import CoreData   // ← only needed for NSPredicate

struct FeedDashboardView: View {
    
    // Core-Data context & fetch
    @Environment(\.managedObjectContext) private var ctx
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FeedPaddock.name, ascending: true)],
        predicate: NSPredicate(format: "farmId == %@", "local-farm"),
        animation: .default
    )
    private var paddocks: FetchedResults<FeedPaddock>
    
    // The rest of your state remains the same
    @State private var feedLogs: [FeedLogEntry] = []
    @State private var livestockTypes: [String] = ["Ewes", "Lambs", "Wethers"]
    @State private var feedTypes: [String] = ["Hay", "Straw", "Lupins", "Oats", "Barley"]
    
    @State private var showAddSheet = false
    @State private var showLogSheet = false
    @State private var showLivestockEditor = false
    @State private var showFeedEditor = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Feed Tracker")
                .font(.largeTitle)
                .bold()
                .padding([.top, .horizontal])

            // --- action buttons ---
            HStack {
                Button(action: { showLogSheet = true }) {
                    Label("Log Feeding", systemImage: "plus.circle")
                }
                .padding(.horizontal)

                NavigationLink(
                    destination: FeedSummaryView(
                        logs: feedLogs,
                        livestockTypes: livestockTypes,
                        feedTypes: feedTypes
                    )
                ) {
                    Label("Feed Summary", systemImage: "chart.bar.fill")
                }
                .padding(.horizontal)
            }

            // --- paddock list ---
            if paddocks.isEmpty {
                Text("No paddocks added yet.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                List {
                    ForEach(paddocks) { paddock in
                        VStack(alignment: .leading) {
                            Text(paddock.name ?? "Unnamed").font(.headline)
                            Text("Type: \(paddock.livestockType ?? "—")")
                            Text("Feed: \(paddock.feedType ?? "—")")
                            Text("Animals: \(paddock.numberOfAnimals)")
                            Text(String(format: "Total Feed: %.1f kg", paddock.totalFeedKgPerFeeding))
                                .foregroundColor(.blue)
                        }
                    }
                    .onDelete(perform: deletePaddocks)   // ← now deletes via Core Data
                }
            }
            
            // --- add paddock button ---
            Button { showAddSheet = true } label: {
                Label("Add Paddock", systemImage: "plus")
            }
            .padding()
            
            // --- editors ---
            HStack {
                Button("Edit Livestock Types") { showLivestockEditor = true }
                    .padding(.horizontal)
                
                Button("Edit Feed Types") { showFeedEditor = true }
                    .padding(.horizontal)
            }
            Spacer()
        }
        // -------- sheets --------
        .sheet(isPresented: $showAddSheet) {
            AddEditPaddockView(livestockTypes: $livestockTypes, feedTypes: $feedTypes)
                .environment(\.managedObjectContext, ctx)
        }
        .sheet(isPresented: $showLogSheet) {
            LogFeedView(feedLogs: $feedLogs,
                        feedTypes: feedTypes)
        }
        .sheet(isPresented: $showLivestockEditor) {
            ListManagerView(title: "Livestock Types", items: $livestockTypes)
        }
        .sheet(isPresented: $showFeedEditor) {
            ListManagerView(title: "Feed Types", items: $feedTypes)
        }
    }
    
    // MARK: delete helper
    private func deletePaddocks(at offsets: IndexSet) {
        offsets.map { paddocks[$0] }.forEach(ctx.delete)
        try? ctx.save()
    }
}
