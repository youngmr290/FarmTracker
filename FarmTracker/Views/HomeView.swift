import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Main Features")) {
                    NavigationLink(
                        destination: TaskDashboardView(),
                        label: {
                            Text("📝 Task Tracker")
                        }
                    )

                    NavigationLink(
                        destination: FeedDashboardView(),
                        label: {
                            Text("🐑 Feed Tracker")
                        }
                    )
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("FarmTrack")
        }
    }
}
