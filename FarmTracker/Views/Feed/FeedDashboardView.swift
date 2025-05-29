// FeedDashboardView.swift
import SwiftUI

struct FeedDashboardView: View {
    @State private var paddocks: [FeedPaddock] = []
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

            HStack {
                Button(action: { showLogSheet = true }) {
                    Label("Log Feeding", systemImage: "plus.circle")
                }
                .padding(.horizontal)

                NavigationLink(
                    destination: FeedSummaryView(
                        logs: feedLogs,
                        paddocks: paddocks,
                        livestockTypes: livestockTypes,
                        feedTypes: feedTypes
                    )
                ) {
                    Label("Feed Summary", systemImage: "chart.bar.fill")
                }
                .padding(.horizontal)
            }

            if paddocks.isEmpty {
                Text("No paddocks added yet.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                List {
                    ForEach(paddocks) { paddock in
                        VStack(alignment: .leading) {
                            Text(paddock.name).font(.headline)
                            Text("Type: \(paddock.livestockType)")
                            Text("Feed: \(paddock.feedType)")
                            Text("Animals: \(paddock.numberOfAnimals)")
                            Text(String(format: "Total Feed: %.1f kg", paddock.totalFeedKgPerFeeding))
                                .foregroundColor(.blue)
                        }
                    }
                    .onDelete { paddocks.remove(atOffsets: $0) }
                }
            }

            Button(action: { showAddSheet = true }) {
                Label("Add Paddock", systemImage: "plus")
            }.padding()

            HStack {
                Button("Edit Livestock Types") {
                    showLivestockEditor = true
                }
                .padding(.horizontal)

                Button("Edit Feed Types") {
                    showFeedEditor = true
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .sheet(isPresented: $showAddSheet) {
            AddEditPaddockView(paddocks: $paddocks, livestockTypes: $livestockTypes, feedTypes: $feedTypes)
        }
        .sheet(isPresented: $showLogSheet) {
            LogFeedView(paddocks: paddocks, feedLogs: $feedLogs, feedTypes: feedTypes)
        }
        .sheet(isPresented: $showLivestockEditor) {
            ListManagerView(title: "Livestock Types", items: $livestockTypes)
        }
        .sheet(isPresented: $showFeedEditor) {
            ListManagerView(title: "Feed Types", items: $feedTypes)
        }
    }
}
