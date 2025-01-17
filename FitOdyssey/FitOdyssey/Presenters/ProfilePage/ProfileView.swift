
import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showProfile: Bool
    @State private var isImagePickerPresented = false
    @State private var isBeforeImagePickerPresented = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                VStack {
                    if viewModel.isLoading {
                        ProgressView(LocalizedStringKey("Loading..."))
                            .frame(width: 120, height: 120)
                    } else if let beforeImage = viewModel.beforeImage {
                        Image(uiImage: beforeImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .onTapGesture {
                                isBeforeImagePickerPresented.toggle()
                            }
                    } else {
                        Image(.avatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .onTapGesture {
                                isBeforeImagePickerPresented.toggle()
                            }
                    }
                }
                
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
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                    } else {
                        Image("Avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                    }
                }
                
                VStack(spacing: 5) {
                    Text(LocalizedStringKey("Full Name"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    TextField("", text: $viewModel.profile.name, prompt: Text(LocalizedStringKey("Full Name")))
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                }
                
                VStack(spacing: 5) {
                    Text(LocalizedStringKey("Weight"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    TextField("", text: $viewModel.profile.weight, prompt: Text(LocalizedStringKey("Weight")))
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                }
                
                VStack(spacing: 5) {
                    Text(LocalizedStringKey("Exercises:"))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    List(viewModel.exercises) { exercise in
                        HStack {
                            if let url = URL(string: exercise.image) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(exercise.name)
                                    .font(.headline)
                                Text(exercise.instructions)
                                    .font(.subheadline)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
                
                HStack {
                    Text(LocalizedStringKey("Language"))
                        .foregroundColor(.gray)
                        .padding(.leading)
                }
                .padding()
                
                HStack(spacing: 20) {
                    Button(LocalizedStringKey("ქართული")) {
                        print("Pressed Georgian")
                    }
                    .padding()
                    .frame(width: 140)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    
                    Button(LocalizedStringKey("English")) {
                        print("Pressed English")
                    }
                    .padding()
                    .frame(width: 140)
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Spacer()
                
                HStack {
                    Button(LocalizedStringKey("Save")) {
                        viewModel.updateProfile()
                        print("Profile saved")
                    }
                    .foregroundColor(Color(red: 81/255, green: 89/255, blue: 246/255))
                    .fontWeight(.bold)
                    
                    Button(LocalizedStringKey("Log out")) {
                        try? Auth.auth().signOut()
                        dismiss()
                        print("User logged out")
                    }
                    .padding()
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .frame(maxWidth: 135)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }}
        .navigationBarBackButtonHidden(true)
        .background(Color(red: 241/255, green: 242/255, blue: 246/255))
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $viewModel.profileImage)
                .onDisappear {
                    viewModel.uploadProfileImage()
                }
        }
        .sheet(isPresented: $isBeforeImagePickerPresented) {
            ImagePicker(image: $viewModel.beforeImage)
                .onDisappear {
                    viewModel.uploadBeforeImage()
                }
        }
    }
}






