import SwiftUI

struct LogFeedView: View {
    var paddocks: [FeedPaddock]
    @Binding var feedLogs: [FeedLogEntry]
    var feedTypes: [String]

    @Environment(\.presentationMode) var presentationMode

    @State private var selectedPaddock: FeedPaddock?
    @State private var selectedFeedType: String = ""
    @State private var customAmount: String = ""
    @State private var date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Paddock")) {
                    Picker("Select", selection: $selectedPaddock) {
                        ForEach(paddocks) { paddock in
                            Text(paddock.name).tag(Optional(paddock))
                        }
                    }
                }

                if let paddock = selectedPaddock {
                    Section(header: Text("Feeding")) {
                        Text("Livestock: \(paddock.livestockType)")

                        Picker("Feed Type", selection: $selectedFeedType) {
                            ForEach(feedTypes, id: \.self) { Text($0) }
                        }

                        HStack {
                            Text("Amount (kg)")
                            Spacer()
                            TextField("", text: $customAmount)
                                .keyboardType(.decimalPad)
                                .frame(width: 80)
                        }
                        .onAppear {
                            customAmount = String(format: "%.1f", paddock.totalFeedKgPerFeeding)
                            selectedFeedType = paddock.feedType
                        }

                        DatePicker("Date", selection: $date, displayedComponents: .date)
                    }
                }

                Button("Save Log") {
                    if let paddock = selectedPaddock,
                       let amount = Double(customAmount), !selectedFeedType.isEmpty {
                        let log = FeedLogEntry(
                            paddockName: paddock.name,
                            livestockType: paddock.livestockType,
                            feedType: selectedFeedType,
                            amountKg: amount,
                            date: date
                        )
                        feedLogs.append(log)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(selectedPaddock == nil || selectedFeedType.isEmpty)
            }
            .navigationTitle("Log Feeding")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
