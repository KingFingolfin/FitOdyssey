
import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showProfile = true
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
                        .background(Color.appTextFieldBackGround)
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
                        .background(Color.appTextFieldBackGround)
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
    }
}






