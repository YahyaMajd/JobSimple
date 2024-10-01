import SwiftUI
import FirebaseAuth
import FirebaseFirestore
struct MainJobView: View {
    @Binding var isUserLoggedIn: Bool  // This binding tracks login status
    @State private var jobs: [Job] = []  // Jobs fetched from Firestore
    @State private var selectedFilter: JobStatus? = nil  // Filter state
    @State private var showingAddJobView = false  // Track the state for showing AddJobView

    let db = Firestore.firestore()  // Firestore database reference
    
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

    // Fetch jobs from Firestore and update the jobs array
    func fetchJobs() {
       db.collection("jobs").addSnapshotListener { snapshot, error in
           if let error = error {
               print("Error fetching jobs: \(error)")
               return
           }
           guard let documents = snapshot?.documents else {
               print("No jobs found")
               return
           }
           
           // Map Firestore documents to Job objects
           self.jobs = documents.map { doc in
               let data = doc.data()
               return Job(
                   id: doc.documentID,
                   title: data["title"] as? String ?? "",
                   company: data["company"] as? String ?? "",
                   link: data["link"] as? String ?? "",
                   status: data["status"] as? JobStatus, // need to make it a requirement
                   description: data["description"] as? String ?? "",
                   contactType: data["contactType"] as? String ?? "",
                   contactValue: data["contactValue"] as? String ?? ""
               )
           }
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
