import SwiftUI

struct HomeView: View {
    var showLogin: () -> Void
    @AppStorage("isProUser") private var isProUser = false

    var body: some View {
        VStack {
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
                        
                        NavigationLink("💉 Husbandry Records", destination: VaccinationListView())
                        
                        NavigationLink("🛠 Machinery Maintenance",
                                       destination: MaintenanceListView())

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
            if isProUser {
                Button("Logout") {
                    AuthService.shared.logout()
                    isProUser = false
                    print("🔴 Logged out")
                }
                .padding()
            } else {
                Button("Go Pro (Login)") {
                    showLogin()
                }
                .padding()
            }
        }
    }
}
