import SwiftUI
import Foundation

struct JobRowView: View {
    var job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Job Title and Link
            HStack {
                VStack(alignment: .leading) {
                    Text(job.title)
                        .font(.headline)
                    Text(job.company)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                // Link to job posting
                Link("Job Posting", destination: URL(string: job.link)!)
            }

            // Status with Color
            HStack {
                Text(statusText(job.status))
                    .foregroundColor(Color(job.status.color))
                    .bold()
                Spacer()
            }

            // Job Description
            Text(job.description)
                .font(.body)
                .foregroundColor(.secondary)

            // Contact Info if available
            if let contact = job.contact {
                HStack {
                    contactIcon(for: contact.type)
                    Text(contact.value)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    // Helper methods
    func statusText(_ status: JobStatus) -> String {
        switch status {
        case .applied:
            return "Applied"
        case .interviewPending:
            return "Interview Pending"
        case .rejected:
            return "Rejected"
        case .accepted:
            return "Accepted"
        }
    }

    func contactIcon(for type: ContactInfo.ContactType) -> some View {
        switch type {
        case .email:
            return Image(systemName: "envelope.fill").foregroundColor(.blue)
        case .phone:
            return Image(systemName: "phone.fill").foregroundColor(.green)
        case .linkedin:
            return Image(systemName: "link.circle.fill").foregroundColor(.blue)
        }
    }
}
