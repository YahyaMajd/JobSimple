import SwiftUI
import FirebaseAuth

struct MainJobView: View {
    @Binding var isUserLoggedIn: Bool  // This binding tracks login status
    @State private var jobs: [Job] = [ /* Add some sample data here or fetch from database */ ]
    @State private var selectedFilter: JobStatus? = nil  // Filter state
    @State private var showingAddJobView = false  // Track the state for showing AddJobView

    var filteredJobs: [Job] {
        if let selectedFilter = selectedFilter {
            return jobs.filter { $0.status == selectedFilter }
        } else {
            return jobs
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Job Tracker!")
                    .font(.largeTitle)
                    .padding()

                // Filter Menu
                Picker("Filter by Status", selection: $selectedFilter) {
                    Text("All").tag(JobStatus?.none)
                    Text("Applied").tag(JobStatus?.some(.applied))
                    Text("Interview Pending").tag(JobStatus?.some(.interviewPending))
                    Text("Rejected").tag(JobStatus?.some(.rejected))
                    Text("Accepted").tag(JobStatus?.some(.accepted))
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Job List
                List(filteredJobs) { job in
                    JobRowView(job: job)
                }
                .listStyle(PlainListStyle())

                Spacer()

                // Navigation Link to Add Job View
                NavigationLink(destination: AddJobView()) {
                    Text("Add New Job")
                        .bold()
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                // Logout button
                Button(action: {
                    logoutUser()
                }) {
                    Text("Log Out")
                        .bold()
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Main Job Tracker")
        }
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
            // Update the state to indicate the user is logged out
            print("User signed out successfully.")
            isUserLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
