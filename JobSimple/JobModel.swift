//
//  JobModel.swift
//  IOSApp
//
//  Created by Yahya on 2024-09-30.
//

import Foundation
struct Job: Identifiable {
    var id : String  // Unique ID for each job
    var title: String
    var company: String
    var link: String
    var status: JobStatus?  // Enum for the status
    var description: String
    var contactType: String
    var contactValue: String
}

enum JobStatus {
    case applied, interviewPending, rejected, accepted
    
    var color: String {
        switch self {
        case .applied:
            return "yellow"
        case .interviewPending:
            return "blue"
        case .rejected:
            return "red"
        case .accepted:
            return "green"
        }
    }
}

struct ContactInfo {
    enum ContactType {
        case email, phone, linkedin
    }
    var type: ContactType
    var value: String  // The actual contact info (email, phone number, or LinkedIn profile)
}
