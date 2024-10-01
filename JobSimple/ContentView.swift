//
//  ContentView.swift
//  IOSApp
//
//  Created by Yahya on 2024-09-08.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isUserLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            Group {
                if isUserLoggedIn {
                    MainJobView(isUserLoggedIn: $isUserLoggedIn)  // Main job tracker screen
                } else {
                    LoginSignupView(isUserLoggedIn: $isUserLoggedIn)  // Login/signup screen
                }
            }
            .navigationBarHidden(true)  // Hide navigation bar when not needed
        }
        .onAppear {
            checkUserStatus()  // Check the user's authentication status when the view appears
        }
    }

    // Check if user is already logged in
    func checkUserStatus() {
        if Auth.auth().currentUser != nil {
            isUserLoggedIn = true  // User is logged in, show the main app screen
        } else {
            isUserLoggedIn = false  // User is not logged in, show login/signup view
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
