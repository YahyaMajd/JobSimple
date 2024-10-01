# JobSimple

JobSimple is a Swift-based job application tracking app built using SwiftUI and Firebase. It allows users to track job applications, sort them by status, and store relevant details such as the job posting link, company information, and contact details.

## Features

- **User Authentication**: Firebase Authentication for secure login and signup.
- **Job Tracking**: Add job applications with details like title, company, link, status (applied, interview pending, accepted, rejected), and description.
- **Filter and Sort**: Filter job applications by their status.
- **Firestore Integration**: Job data is stored and retrieved dynamically using Firebase Firestore.
- **Logout Functionality**: Users can log out of their account securely.

## Screens

- **Login/Signup View**: Allows users to create an account or log in to access their job applications.
- **Main Job View**: Displays the list of job applications with filtering options and a button to add new job entries.
- **Add Job View**: A form where users can input job details and save them to Firestore.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+
- Firebase account for Firestore and Authentication

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/YahyaMajd/JobSimple.git
