import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showProfile = true
    @State private var isImagePickerPresented = false
    @Environment(\.dismiss) var dismiss
    
    let genderOptions = ["Male", "Female", "Other"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    if viewModel.isLoading {
                        ProgressView(LocalizedStringKey("Loading..."))
                            .frame(width: 120, height: 120)
                    } else if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.appOrange, lineWidth: 2))
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                    } else {
                        Image("Avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.appOrange, lineWidth: 2))
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                    }
                    
                    Text("Tap to change profile picture")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                Group {
                    ProfileField(
                        title: "Full Name",
                        text: $viewModel.profile.name,
                        placeholder: "Enter your full name"
                    )
                    
                    WheelNumberField(
                        title: "Age",
                        value: Binding(
                            get: { viewModel.profile.age },
                            set: { viewModel.profile.age = $0 }
                        ),
                        range: 1...150,
                        unit: "years"
                    )
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Gender")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Picker("Gender", selection: $viewModel.profile.gender) {
                            ForEach(genderOptions, id: \.self) {
                                Text(LocalizedStringKey($0))
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    
                    
                    WheelNumberField(
                        title: "Height",
                        value: Binding(
                            get: { viewModel.profile.height },
                            set: { viewModel.profile.height = $0 }
                        ),
                        range: 50...300,
                        unit: "cm"
                    )
                }

                
                Button(action: {
                    viewModel.updateProfile()
                }) {
                    Text("Save Changes")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appOrange)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
        }
        .navigationBarBackButtonHidden(false)
        .background(Color.appBackground)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $viewModel.profileImage)
                .onDisappear {
                    viewModel.uploadProfileImage()
                }
        }
    }
}

