import SwiftUI

struct TypingTextView: View {
    let fullText: String
    @State private var displayedText = ""
    @State private var charIndex = 0
    @State private var showCursor = true
    let typingSpeed = 0.05  // Speed of typing in seconds
    let restartDelay = 2.0   // Delay before restarting animation

    var body: some View {
        Text(displayedText + (showCursor ? "|" : ""))
            .font(.system(size: 32, weight: .bold, design: .monospaced))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .onAppear {
                startTypingAnimation()
                startCursorBlinking()
            }
    }
    
    func startTypingAnimation() {
        displayedText = ""
        charIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if charIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: charIndex)
                displayedText.append(fullText[index])
                charIndex += 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + restartDelay) {
                    startTypingAnimation() // Restart animation after delay
                }
            }
        }
    }

    func startCursorBlinking() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            showCursor.toggle()
        }
    }
}

struct ContentView: View {
    @State private var showSignIn = false  // Controls Sign-In Modal
    @State private var showSignUp = false  // Controls Sign-Up Modal

    var body: some View {
        ZStack {
            // Gradient Background from Black to Blue (#0A07F0)
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 10/255, green: 7/255, blue: 240/255)]),
                        startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                       .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                TypingTextView(fullText: "AI-VisualTranscend")
                
                Spacer()
                
                HStack(spacing: 40) {
                    Button(action: { showSignIn = true }) { // Show Sign-In Form
                        Text("Sign In")
                            .foregroundColor(.white)
                            .frame(width: 120, height: 45)
                            .background(Color(red: 4/255, green: 7/255, blue: 100/255))
                            .cornerRadius(12)
                            .overlay( //  White Border
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white, lineWidth: 2) // White stroke
                                    )
                            .padding(5) // Adds spacing without affecting background

                    }
                    .buttonStyle(PlainButtonStyle()) // Removes default shadow effect

                    Button(action: { showSignUp = true }) { // Show Sign-Up Form
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .frame(width: 120, height: 45)
                            .background(Color(red: 180/255, green: 20/255, blue: 30/255))
                            .cornerRadius(12)
                            .overlay( //  White Border
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white, lineWidth: 2) // White stroke
                                    )
                            .padding(5) // Adds spacing without affecting background
                    }
                    .buttonStyle(PlainButtonStyle()) // Removes default shadow effect

                }
//                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: Binding(get: { showSignIn || showSignUp }, set: { _ in
            showSignIn = false
            showSignUp = false
        })) {
            if showSignIn {
                            NavigationView { SignInView() } //  Wrap inside NavigationView
                        } else if showSignUp {
                            NavigationView { SignUpView() } // Wrap inside NavigationView
                        }
                    }
                }
            }

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignedIn = false  // Controls navigation
    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var isValidForm = false

    @FocusState private var focusedField: Field?

    enum Field {
        case email, password
    }

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                    .onTapGesture { dismissKeyboard() }

                VStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    // Email Field
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .email)
                        .onChange(of: email) { validateForm() }
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }

                    if !emailError.isEmpty {
                        Text(emailError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading)
                    }

                    //  Password Field
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .password)
                        .onChange(of: password) { validateForm() }
                        .submitLabel(.done)
                        .onSubmit { focusedField = nil }

                    if !passwordError.isEmpty {
                        Text(passwordError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading)
                    }

                    // Sign In Button
                    Button(action: signIn) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isValidForm ? Color.blue : Color.gray) // Disable if invalid
                            .cornerRadius(10)
                            .padding()
                    }
                    .disabled(!isValidForm) //  Button is disabled if form is invalid

                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    .padding()

                    //  Navigation to Sign-Up Page
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    focusedField = .email
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") { dismissKeyboard() }
                }
            }
            .fullScreenCover(isPresented: $isSignedIn) {
                HomeView()
                    .interactiveDismissDisabled(true) // Prevents swipe-away
            }
        }
    }

    ///  Function to Validate Email & Password
    private func validateForm() {
        emailError = isValidEmail(email) ? "" : "Invalid email format"
        passwordError = isValidPassword(password) ? "" : "Password must have:\n• At least 7 characters\n• 1 Uppercase Letter\n• 1 Number\n• 1 Special Character"
        isValidForm = emailError.isEmpty && passwordError.isEmpty
    }

    /// Sign-In Logic
    private func signIn() {
        if isValidForm {
            print("User Signed In: \(email)") //  Terminal Output
            isSignedIn = true
        }
    }

    /// Email Validation Regex
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    /// Password Validation Regex
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    /// Dismiss Keyboard
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    @State private var isValidForm = false

    @FocusState private var focusedField: Field?

    enum Field {
        case firstName, lastName, username, email, password
    }

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                    .onTapGesture { dismissKeyboard() }

                VStack {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .lastName }

                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .username }

                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($focusedField, equals: .username)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }

                    //  Email Field with Validation
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .email)
                        .onChange(of: email) { validateForm() }
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }

                    if !emailError.isEmpty {
                        Text(emailError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading)
                    }

                    //  Password Field with Validation
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .textInputAutocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .password)
                        .onChange(of: password) { validateForm() }
                        .submitLabel(.done)
                        .onSubmit { focusedField = nil }

                    if !passwordError.isEmpty {
                        Text(passwordError)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.leading)
                    }

                    //  Sign Up Button (Disabled Until All Fields Are Filled)
                    Button(action: {
                        print("User Signed Up: \(email)")
                        dismiss()
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isValidForm ? Color.green : Color.gray)
                            .cornerRadius(10)
                            .padding()
                    }
                    .disabled(!isValidForm) // Button disabled if any field is empty or invalid

                    Button("Cancel") { dismiss() }
                        .foregroundColor(.red)
                        .padding()

                    // Navigation Link to Sign-In Page
                    NavigationLink(destination: SignInView()) {
                        Text("Already have an account? Sign In")
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    focusedField = .firstName
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") { dismissKeyboard() }
                }
            }
        }
    }

    /// Validate Email, Password, and Ensure All Fields Are Filled
    private func validateForm() {
        emailError = isValidEmail(email) ? "" : "Invalid email format"
        passwordError = isValidPassword(password) ? "" : "Password must have:\n• At least 6 characters\n• 1 uppercase letter\n• 1 number\n• 1 special character"
        isValidForm = emailError.isEmpty && passwordError.isEmpty &&
                      !firstName.isEmpty && !lastName.isEmpty && !username.isEmpty
    }

    /// Email Validation Regex
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    /// Password Validation Regex (Min 6)
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    ///  Dismiss Keyboard
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct HomeView: View {
    @State private var isLoggedOut = false  // Controls logout navigation

    var body: some View {
        ZStack {
            // Gradient Background from Black to Blue (#0A07F0)
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(red: 10/255, green: 7/255, blue: 240/255)]),
                        startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                       .ignoresSafeArea()
            VStack {
                Spacer()

                Text("Welcome to Home Page!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()

                Text("You are now signed in.")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                Spacer()
            }
            .navigationBarBackButtonHidden(true) //  Hides the back button
            .navigationBarItems(trailing: Button(action: logout) { //  Logout button
                Image(systemName: "power") // Logout icon
                    .foregroundColor(.red)
            })
        }
        .fullScreenCover(isPresented: $isLoggedOut) {  //  Forces full-screen navigation
            ContentView()
                .interactiveDismissDisabled(true) //  Prevents swipe dismissal
        }
    }

    /// Function to handle logout
    private func logout() {
        isLoggedOut = true
    }
}


   






#Preview {
    ContentView()
}

