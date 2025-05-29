import SwiftUI

struct FeedSummaryView: View {
    var logs: [FeedLogEntry]
    var paddocks: [FeedPaddock]
    var livestockTypes: [String]
    var feedTypes: [String]

    @State private var selectedPaddock: String = ""
    @State private var selectedLivestockType: String = ""
    @State private var selectedFeedType: String = ""
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    @State private var endDate = Date()

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    private var filteredLogs: [FeedLogEntry] {
        logs.filter { log in
            (selectedPaddock.isEmpty || log.paddockName == selectedPaddock) &&
            (selectedLivestockType.isEmpty || log.livestockType == selectedLivestockType) &&
            (selectedFeedType.isEmpty || log.feedType == selectedFeedType) &&
            (log.date >= startDate && log.date <= endDate)
        }
    }

    private var totalKg: Double {
        filteredLogs.map { $0.amountKg }.reduce(0, +)
    }

    var body: some View {
        Form {
            // 🔍 Filters
            Section(header: Text("Filters")) {
                Picker("Paddock", selection: $selectedPaddock) {
                    Text("All").tag("")
                    ForEach(paddocks.map { $0.name }, id: \.self) {
                        Text($0)
                    }
                }

                Picker("Livestock Type", selection: $selectedLivestockType) {
                    Text("All").tag("")
                    ForEach(livestockTypes, id: \.self) {
                        Text($0)
                    }
                }

                Picker("Feed Type", selection: $selectedFeedType) {
                    Text("All").tag("")
                    ForEach(feedTypes, id: \.self) {
                        Text($0)
                    }
                }

                DatePicker("From", selection: $startDate, displayedComponents: .date)
                DatePicker("To", selection: $endDate, displayedComponents: .date)
            }

            // 📊 Total Summary
            Section(header: Text("Total Feed")) {
                Text(String(format: "%.1f kg", totalKg))
                    .font(.title)
                    .foregroundColor(.blue)
            }

            // 📋 Log Entries
            Section(header: Text("Entries")) {
                List(filteredLogs) { log in
                    VStack(alignment: .leading) {
                        Text("\(log.paddockName) — \(log.feedType)")
                            .font(.headline)
                        Text("Date: \(dateFormatter.string(from: log.date))")
                        Text(String(format: "%.1f kg", log.amountKg))
                    }
                }
            }
        }
        .navigationTitle("Feed Summary")
    }
}
