import Foundation
import SwiftUI
import FirebaseAuth

struct LoginSignupView: View {
    @Binding var isUserLoggedIn: Bool  // This binding tracks login status
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoginMode: Bool = true
    @State private var errorMessage: String?
    @State private var showPassword: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Picker("Mode", selection: $isLoginMode) {
                    Text("Login").tag(true)
                    Text("Sign Up").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )

                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding()
                    }
                }
                .padding(.horizontal)

                Button(action: {
                    if validateFields() {
                        isLoginMode ? loginUser() : signUpUser()
                    }
                }) {
                    Text(isLoginMode ? "Log In" : "Sign Up")
                        .bold()
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()

            }
            .navigationTitle(isLoginMode ? "Log In" : "Sign Up")
            .padding()
        }
    }

    // Email validation using a simple regex
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    // Password validation for minimum length, uppercase, lowercase, and symbol
    func isValidPassword(_ password: String) -> Bool {
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@",
            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{8,}$")
        return passwordPredicate.evaluate(with: password)
    }

    // Validate email and password fields
    func validateFields() -> Bool {
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
            return false
        }

        if !isLoginMode && !isValidPassword(password) {
            errorMessage = "Password must be at least 8 characters, include an uppercase letter, a lowercase letter, a number, and a special character."
            return false
        }

        errorMessage = nil
        return true
    }

    func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    self.errorMessage = "The password you entered is incorrect."
                case AuthErrorCode.invalidEmail.rawValue:
                    self.errorMessage = "Please enter a valid email address."
                case AuthErrorCode.userNotFound.rawValue:
                    self.errorMessage = "There is no account associated with this email."
                default:
                    self.errorMessage = error.localizedDescription
                }
                print("Login Error: \(error.localizedDescription)")
            } else {
                // Successful login, handle navigation
                self.errorMessage = nil
                print("Login successful")
                isUserLoggedIn = true
            }
        }
    }

    func signUpUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    self.errorMessage = "This email is already associated with an account."
                case AuthErrorCode.invalidEmail.rawValue:
                    self.errorMessage = "Please enter a valid email address."
                case AuthErrorCode.weakPassword.rawValue:
                    self.errorMessage = "The password is too weak. Please choose a stronger password."
                default:
                    self.errorMessage = error.localizedDescription
                }
                print("Signup Error: \(error.localizedDescription)")
            } else {
                // Successful signup, handle navigation
                self.errorMessage = nil
                print("Signup successful")
                isUserLoggedIn = false
            }
        }
    }


}
