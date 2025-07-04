import SwiftUI

struct VaccinationDetailView: View {
    let record: VaccinationRecord

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    LabeledText("Date", date: record.dateGiven ?? Date())
                    LabeledText("Animal Class", text: record.animalClass ?? "—")
                    LabeledText("Number of Stock", text: "\(record.numberOfStock)")
                    LabeledText("Product", text: record.product ?? "—")
                    if let batch = record.batchNumber, !batch.isEmpty {
                        LabeledText("Batch", text: batch)
                    }
                }

                if let data = record.photo,
                   let uiImage = UIImage(data: data) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Photo")
                            .font(.headline)
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Vaccination Details")
    }
}


private struct LabeledText: View {
    let label: String
    let content: Text

    init(_ label: String, text: String) {
        self.label = label
        self.content = Text(text)
    }

    init(_ label: String, date: Date) {
        self.label = label
        self.content = Text(date, style: .date)
    }

    var body: some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .fontWeight(.semibold)
            Spacer()
            content
                .multilineTextAlignment(.trailing)
        }
    }
}
