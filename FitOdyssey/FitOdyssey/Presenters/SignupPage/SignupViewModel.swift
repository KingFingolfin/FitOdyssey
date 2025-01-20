//
//  SignupViewModel.swift
//  FitOdyssey
//
//  Created by Giorgi on 13.01.25.
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

final class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var weight: String = ""
    @Published var height: String = ""
    @Published var gender: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var statusMessage: String? = nil
    @Published var isSuccess: Bool = false
    @Published var shouldNavigateToLogin: Bool = false

    func validateForm() -> (isValid: Bool, message: String?) {
        guard !name.isEmpty,
              !age.isEmpty,
              !weight.isEmpty,
              !height.isEmpty,
              !gender.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            return (false, "All fields are required.")
        }
        
        guard let ageValue = Int(age), ageValue > 0 else {
            return (false, "Please enter a valid age.")
        }
        guard let weightValue = Double(weight), weightValue > 0 else {
            return (false, "Please enter a valid weight.")
        }
        guard let heightValue = Double(height), heightValue > 0 else {
            return (false, "Please enter a valid height.")
        }
        guard gender.lowercased() == "male" || gender.lowercased() == "female" else {
            return (false, "Gender must be 'Male' or 'Female'.")
        }
        guard isValidEmail(email) else {
            return (false, "Please enter a valid email address.")
        }
        guard password.count >= 6 else {
            return (false, "Password must be at least 6 characters long.")
        }
        guard password == confirmPassword else {
            return (false, "Passwords do not match.")
        }
        return (true, nil)
    }

    func SignUp() async {
        let validationResult = validateForm()
        
        DispatchQueue.main.async { [weak self] in
            self?.statusMessage = validationResult.message
        }
        if !validationResult.isValid {
            return
        }
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            saveUserInfo()
            
            DispatchQueue.main.async { [weak self] in
                self?.statusMessage = "Sign-up successful!"
                self?.isSuccess = true
                self?.shouldNavigateToLogin = true
            }
        }
        catch {
            DispatchQueue.main.async { [weak self] in
                self?.statusMessage = "Error during sign-up: \(error.localizedDescription)"
            }
        }
    }

    
    func saveUserInfo() {
        let firestore = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let email = Auth.auth().currentUser?.email else { return }

        let user = User(
            uid: uid,
            email: email,
            name: name,
            age: Int(age) ?? 0,
            weight: weight,
            height: Double(height) ?? 0.0,
            gender: gender,
            ImageUrl: "",
            before_image: "",
            after_image: "",
            measurements: [],
            workoutPlans: []
        )

        do {
            try firestore.collection("Users")
                .document(uid)
                .setData(from: user) { error in
                    if let error = error {
                        print("Failed to save user data: \(error.localizedDescription)")
                    } else {
                        print("User data saved successfully.")
                    }
                }
        } catch {
            print("Failed saving user data.")
        }
    }

    func saveMeasurement(measurement: Measurements) {
        let firestore = Firestore.firestore()
        guard let userId = Auth.auth().currentUser?.uid else { return }

        do {
            try firestore.collection("Users")
                .document(userId)
                .collection("Measurements")
                .document(UUID().uuidString)
                .setData(from: measurement) { error in
                    if let error = error {
                        print("Error saving measurement: \(error.localizedDescription)")
                    } else {
                        print("Measurement saved successfully.")
                    }
                }
        } catch {
            print("Failed saving measurement data.")
        }
    }

//    func saveWorkoutPlan(plan: WorkoutPlan) {
//        let firestore = Firestore.firestore()
//        guard let userId = Auth.auth().currentUser?.uid else { return }
//
//        do {
//            try firestore.collection("Users")
//                .document(userId)
//                .collection("WorkoutPlans")
//                .document(plan.id ?? UUID().uuidString)
//                .setData(from: plan) { error in
//                    if let error = error {
//                        print("Error saving workout plan: \(error.localizedDescription)")
//                    } else {
//                        print("Workout plan saved successfully.")
//                    }
//                }
//        } catch {
//            print("Failed saving workout plan.")
//        }
//    }

    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
