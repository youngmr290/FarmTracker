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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image("logo-nobackground-1000")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 58)

                        Text("FarmTrack")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }

            }
        }
    }
}
