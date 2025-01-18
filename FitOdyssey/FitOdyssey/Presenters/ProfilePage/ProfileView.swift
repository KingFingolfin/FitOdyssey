
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
        .navigationBarBackButtonHidden(false)
        .background(.appBackground)
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






