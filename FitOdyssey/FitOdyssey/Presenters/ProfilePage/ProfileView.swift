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
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                            .onTapGesture {
                                isImagePickerPresented.toggle()
                            }
                    } else {
                        Image("Avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
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
                        .background(Color.blue)
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

struct ProfileField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey(title))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("", text: $text, prompt: Text(LocalizedStringKey(placeholder)))
                .padding()
                .background(Color.appTextFieldBackGround)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
}
struct WheelNumberField: View {
    let title: String
    @Binding var value: String
    let range: ClosedRange<Int>
    let unit: String
    @State private var isPickerShown = false
    @State private var selectedNumber: Int

    init(title: String, value: Binding<String>, range: ClosedRange<Int>, unit: String) {
        self.title = title
        self._value = value
        self.range = range
        self.unit = unit
        let initialValue = Int(value.wrappedValue) ?? range.lowerBound
        self._selectedNumber = State(initialValue: initialValue)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(LocalizedStringKey(title))
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button(action: {
                    isPickerShown = true
                }) {
                    HStack {
                        Text("\(value.isEmpty ? "--" : value) \(unit)")
                            .foregroundColor(value.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.appTextFieldBackGround)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)

            if isPickerShown {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPickerShown = false
                    }

                VStack(spacing: 15) {
                    Text("Select \(title)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    Picker("", selection: $selectedNumber) {
                        ForEach(Array(range), id: \.self) { number in
                            Text("\(number) \(unit)")
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(height: 150)

                    HStack {
                        Button("Cancel") {
                            isPickerShown = false
                        }
                        .foregroundColor(.red)
                        .padding()

                        Spacer()

                        Button("Done") {
                            value = String(selectedNumber)
                            isPickerShown = false
                        }
                        .foregroundColor(.blue)
                        .padding()
                    }
                }
                .padding()
                .frame(width: 320)
                .background(Color.black.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                .transition(.scale)
            }
        }
        .animation(.easeInOut, value: isPickerShown)
    }
}
