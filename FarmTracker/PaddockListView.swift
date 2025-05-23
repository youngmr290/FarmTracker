import SwiftUI

struct PaddockListView: View {
    var paddocks: [Paddock]

    var body: some View {
        List(paddocks) { paddock in
            NavigationLink(destination: PaddockDetailView(paddock: paddock)) {
                VStack(alignment: .leading) {
                    Text(paddock.name).font(.headline)
                    Text("Sheep: \(paddock.sheepCount)").font(.subheadline)
                }
            }
        }
    }
}
