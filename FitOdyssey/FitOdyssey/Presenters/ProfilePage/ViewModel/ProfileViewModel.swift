import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var profile = User(
        uid: "",
        email: "",
        name: "",
        age: "",
        height: "",
        gender: "",
        ImageUrl: "",
        before_image: "",
        after_image: "",
        measurements: [],
        workoutPlans: []
    )

    @Published var profileImage: UIImage? = nil
    @Published var beforeImage: UIImage? = nil
    @Published var afterImage: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var shouldShowImagePicker: Bool = false
    @Published var meals: [Meal] = []
    @Published var exercises: [Exercise] = []
    @Published var myWorkouts: [WorkoutPlan] = []
    
    init() {
        fetchUser()
    }
    
    
    
     func fetchUser() {
        guard let fromId = Auth.auth().currentUser?.uid else {
            print("User ID not found.")
            return
        }

        let firestore = Firestore.firestore()
        firestore.collection("Users")
            .document(fromId)
            .getDocument { snapshot, error in
                if let error = error {
                    print("Failed fetching user: \(error)")
                } else {
                    do {
                        if let data = snapshot?.data() {
                            let user = try Firestore.Decoder().decode(User.self, from: data)
                            self.profile = user
                            
                            print("🟣 Workout Plans IDs: \(user.workoutPlans)")
                            
                            self.fetchWorkoutPlans(planIds: user.workoutPlans)
                            
                            if !user.ImageUrl.isEmpty {
                                self.loadProfileImage(from: user.ImageUrl)
                            }
                            if !user.before_image.isEmpty {
                                self.loadBeforeImage(from: user.before_image)
                            }
                            if !user.after_image.isEmpty {
                                self.loadAfterImage(from: user.after_image)
                            }
                        }
                    } catch {
                        print("Error decoding user: \(error)")
                    }
                    print("User fetched successfully")
                }
            }
    }

    private func fetchWorkoutPlans(planIds: [String]) {
        guard !planIds.isEmpty else {
            print("No workout plans to fetch.")
            return
        }

        let firestore = Firestore.firestore()

        firestore.collection("Plans")
            .whereField(FieldPath.documentID(), in: planIds)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Failed fetching workout plans: \(error)")
                    return
                }

                do {
                    var plans = try snapshot?.documents.compactMap { document -> WorkoutPlan? in
                        var plan = try Firestore.Decoder().decode(WorkoutPlan.self, from: document.data())
                        plan.id = document.documentID
                        return plan
                    } ?? []
                    
                    let allExerciseIds = plans.flatMap { $0.exerciseIds }
                    if allExerciseIds.isEmpty {
                        print("No exercise IDs found.")
                        DispatchQueue.main.async {
                            self.myWorkouts = plans
                        }
                        return
                    }

                    firestore.collection("Exercises")
                        .whereField(FieldPath.documentID(), in: allExerciseIds)
                        .getDocuments { snapshot, error in
                            if let error = error {
                                print("Error fetching exercises: \(error)")
                                DispatchQueue.main.async {
                                    self.myWorkouts = plans
                                }
                                return
                            }

                            var exerciseMap: [String: Exercise] = [:]
                            snapshot?.documents.forEach { document in
                                do {
                                    let exercise = try document.data(as: Exercise.self)
                                    if let id = exercise.id {
                                        exerciseMap[id] = exercise
                                    }
                                } catch {
                                    print("Error decoding exercise: \(error)")
                                }
                            }

                            for i in 0..<plans.count {
                                let exerciseIds = plans[i].exerciseIds
                                plans[i].exercises = exerciseIds.compactMap { exerciseMap[$0] }
                            }

                            DispatchQueue.main.async {
                                self.myWorkouts = plans
                            }
                            print("Workout plans fetched and updated successfully.")
                        }
                } catch {
                    print("Error decoding workout plans: \(error)")
                }
            }
    }
    
    
    func addWorkoutPlanToUser(name: String, exercises: [String]) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let firestore = Firestore.firestore()
        let newPlanRef = firestore.collection("Plans").document()
        
        let workoutPlanData: [String: Any] = [
            "name": name,
            "exerciseIds": exercises.map { $0 }
        ]
        
        newPlanRef.setData(workoutPlanData) { error in
            if let error = error {
                print("Failed to create workout plan: \(error.localizedDescription)")
                return
            }
            
            print("Workout plan created successfully.")
            
            let userRef = firestore.collection("Users").document(userId)
            userRef.updateData([
                "workoutPlans": FieldValue.arrayUnion([newPlanRef.documentID])
            ]) { error in
                if let error = error {
                    print("Failed to update user with workout plan ID: \(error.localizedDescription)")
                } else {
                    print("User updated successfully with new workout plan ID.")
                    
                    self.fetchExercises(for: exercises) { fetchedExercises in
                        let newPlan = WorkoutPlan(
                            id: newPlanRef.documentID,
                            name: name,
                            exercises: fetchedExercises
                        )
                        
                        DispatchQueue.main.async {
                            self.myWorkouts.append(newPlan)
                            self.profile.workoutPlans.append(newPlanRef.documentID)
                        }
                    }
                }
            }
        }
    }

    func fetchExercises(for exerciseIds: [String], completion: @escaping ([Exercise]) -> Void) {
        let firestore = Firestore.firestore()
        
        firestore.collection("Exercises")
            .whereField(FieldPath.documentID(), in: exerciseIds)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching exercises: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let exerciseDocs = snapshot?.documents else {
                    print("No exercises found.")
                    completion([])
                    return
                }
                
                var exercises: [Exercise] = []
                for document in exerciseDocs {
                    do {
                        let exercise = try document.data(as: Exercise.self)
                        exercises.append(exercise)
                    } catch {
                        print("Error decoding exercise: \(error)")
                    }
                }
                
                completion(exercises)
            }
    }

    
    private func loadProfileImage(from urlString: String) {
        ImageManager.shared.fetchImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.profileImage = image
            }
        }
    }
    
    
    
    private func loadBeforeImage(from urlString: String) {
        ImageManager.shared.fetchImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.beforeImage = image
            }
        }
    }

    private func loadAfterImage(from urlString: String) {
        ImageManager.shared.fetchImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.afterImage = image
            }
        }
    }
    
    func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = profile.name
        
        changeRequest.commitChanges { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully.")
            }
        }
        storeUserInfo(uid: user.uid)
    }
    
    func uploadProfileImage() {
        guard let profileImage = profileImage else {
            print("No profile image selected")
            return
        }
        
        guard let user = Auth.auth().currentUser else { return }
        
        ImageManager.shared.uploadImage(profileImage, for: user.uid) { [weak self] url in
            if let url = url {
                DispatchQueue.main.async {
                    self?.profile.ImageUrl = url
                }
            } else {
                print("Failed to upload profile image.")
            }
        }
    }
    
    
    func uploadBeforeImage() {
        guard let beforeImage = beforeImage else {
            print("No before image selected")
            return
        }

        guard let user = Auth.auth().currentUser else { return }

        ImageManager.shared.uploadImage(beforeImage, for: "\(user.uid)_before") { [weak self] url in
            if let url = url {
                DispatchQueue.main.async {
                    self?.profile.before_image = url

                    let db = Firestore.firestore()
                    db.collection("Users")
                        .document(user.uid)
                        .updateData(["before_image": url]) { error in
                            if let error = error {
                                print("Failed to update before_image in Firestore: \(error.localizedDescription)")
                            } else {
                                print("Before image updated successfully in Firestore.")
                            }
                        }
                }
            } else {
                print("Failed to upload before image.")
            }
        }
    }
    
    func uploadAfterImage() {
        guard let afterImage = afterImage else {
            print("No before image selected")
            return
        }

        guard let user = Auth.auth().currentUser else { return }

        ImageManager.shared.uploadImage(afterImage, for: "\(user.uid)_after") { [weak self] url in
            if let url = url {
                DispatchQueue.main.async {
                    self?.profile.after_image = url

                    let db = Firestore.firestore()
                    db.collection("Users")
                        .document(user.uid)
                        .updateData(["after_image": url]) { error in
                            if let error = error {
                                print("Failed to update after_image in Firestore: \(error.localizedDescription)")
                            } else {
                                print("Before image updated successfully in Firestore.")
                            }
                        }
                }
            } else {
                print("Failed to upload after image.")
            }
        }
    }

    
    private func storeUserInfo(uid: String) {
        let db = Firestore.firestore()
        let user = User(
                uid: uid,
                email: profile.email,
                name: profile.name,
                age: profile.age,
                height: profile.height,
                gender: profile.gender,
                ImageUrl: profile.ImageUrl,
                before_image: profile.before_image,
                after_image: profile.after_image,
                measurements: profile.measurements,
                workoutPlans: profile.workoutPlans
            )
        try? db.collection("Users").document(uid)
            .setData(from: user) { error in
            if let error = error {
                print("Error saving user info: \(error.localizedDescription)")
            } else {
                print("User info saved successfully.")
            }
        }
    }
    
    
    func deleteWorkoutPlan(planId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let firestore = Firestore.firestore()

        let userRef = firestore.collection("Users").document(userId)
        userRef.updateData([
            "workoutPlans": FieldValue.arrayRemove([planId])
        ]) { error in
            if let error = error {
                print("Failed to remove workout plan from user: \(error.localizedDescription)")
                return
            }

            print("Workout plan removed from user successfully.")

            // Delete the plan document itself
            firestore.collection("Plans").document(planId).delete { error in
                if let error = error {
                    print("Failed to delete workout plan document: \(error.localizedDescription)")
                    return
                }

                print("Workout plan document deleted successfully.")

                DispatchQueue.main.async {
                    self.myWorkouts.removeAll { $0.id == planId }
                    self.profile.workoutPlans.removeAll { $0 == planId }
                }
            }
        }
    }

    
    
    func saveMeasurements(biceps: Double, shoulders: Double, waist: Double, chest: Double, weight: Double) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let newMeasurement = Measurements(
            date: Date(),
            biceps: biceps,
            chest: chest,
            waist: waist,
            shoulders: shoulders,
            weight: weight
        )

        DispatchQueue.main.async {
            self.profile.measurements.append(newMeasurement)
        }

        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userId)

        do {
            let encodedMeasurement = try Firestore.Encoder().encode(newMeasurement)

            userRef.updateData([
                "measurements": FieldValue.arrayUnion([encodedMeasurement])
            ]) { error in
                if let error = error {
                    print("Error saving measurements: \(error.localizedDescription)")
                } else {
                    print("Measurements saved successfully")
                }
            }
        } catch {
            print("Failed to encode measurement: \(error.localizedDescription)")
        }
    }

        
        func loadLatestMeasurements() -> Measurements? {
            return profile.measurements.last
        }
}





