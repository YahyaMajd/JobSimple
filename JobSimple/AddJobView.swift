//
//  AddJobView.swift
//  IOSApp
//
//  Created by Yahya on 2024-09-30.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct AddJobView: View {
    @State private var title: String = ""
    @State private var company: String = ""
    @State private var link: String = ""
    @State private var status: String = "applied"  // Default status
    @State private var description: String = ""
    @State private var contactType: String = "email"
    @State private var contactValue: String = ""
    
    let db = Firestore.firestore()

    var body: some View {
        VStack {
            TextField("Job Title", text: $title)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Company Name", text: $company)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Job Posting Link", text: $link)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Status", selection: $status) {
                Text("Applied").tag("applied")
                Text("Interview Pending").tag("interviewPending")
                Text("Rejected").tag("rejected")
                Text("Accepted").tag("accepted")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("Description", text: $description)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Contact Type", selection: $contactType) {
                Text("Email").tag("email")
                Text("Phone").tag("phone")
                Text("LinkedIn").tag("linkedin")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TextField("Contact Information", text: $contactValue)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                addJobToFirestore()
            }) {
                Text("Add Job")
                    .bold()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }

    // Function to add a job to Firestore
    func addJobToFirestore() {
        let jobData: [String: Any] = [
            "title": title,
            "company": company,
            "link": link,
            "status": status,
            "description": description,
            "contactType": contactType,
            "contactValue": contactValue
        ]

        db.collection("jobs").addDocument(data: jobData) { error in
            if let error = error {
                print("Error adding job: \(error.localizedDescription)")
            } else {
                print("Job added successfully!")
                clearForm()
            }
        }
    }

    // Function to clear the form after submitting
    func clearForm() {
        title = ""
        company = ""
        link = ""
        status = "applied"
        description = ""
        contactType = "email"
        contactValue = ""
    }
}
