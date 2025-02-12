import SwiftUI

struct ContentView: View {
    @State private var showSignIn = false  // Controls Sign-In Modal
    @State private var showSignUp = false  // Controls Sign-Up Modal

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Full-screen black background
//                .allowsHitTesting(false) // Ensures keyboard interaction works
            
            VStack {
                Spacer()
                
                Text("AI-VisualTranscend")
                    .font(.system(size: 44))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack(spacing: 40) {
                    Button(action: { showSignIn = true }) { // Show Sign-In Form
                        Text("Sign In")
                            .foregroundColor(.white)
                            .frame(width: 120, height: 45)
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(5) // Adds spacing without affecting background

                    }
                    .buttonStyle(PlainButtonStyle()) // Removes default shadow effect

                    Button(action: { showSignUp = true }) { // Show Sign-Up Form
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .frame(width: 120, height: 45)
                            .background(Color.red)
                            .cornerRadius(12)
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
    
    @FocusState private var focusedField: Field?

    
    enum Field {
          case email, password
      }
    @Environment(\.dismiss) var dismiss // Allows closing the sheet

    var body: some View {
        VStack {
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit { focusedField = nil }

            Button(action: {
                print("User Signed In: \(email)")
                dismiss() // Closes the sheet
            }) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
            }

            Button("Cancel") {
                dismiss() // Closes the sheet
            }
            .foregroundColor(.red)
            .padding()
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // Added Delay
                focusedField = .email // Auto-focus after delay
            }
        }
        .onTapGesture { focusedField = nil } // Tap to dismiss keyboard
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Button("Done") { focusedField = nil }
                    }
                }
    }
}


struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    @FocusState private var focusedField: Field?

    enum Field {
        case firstName, lastName, username, email, password
    }

    @Environment(\.dismiss) var dismiss

    var body: some View {
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

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit { focusedField = nil }

            Button(action: { dismiss() }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding()
            }

            Button("Cancel") { dismiss() }
                .foregroundColor(.red)
                .padding()
        }
        .padding()
        .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { //  Added Delay
                        focusedField = .firstName // Auto-focus after delay
                    }
                }
        .onTapGesture { focusedField = nil } // Tap anywhere to dismiss keyboard
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Done") { focusedField = nil }
            }
        }
    }
}



#Preview {
    ContentView()
}

