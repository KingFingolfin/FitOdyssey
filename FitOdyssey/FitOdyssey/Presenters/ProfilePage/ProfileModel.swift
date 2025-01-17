import Foundation

struct ProfileModel {
    var fullName: String
    var username: String
    var imageUrl: String
    var language: Language
    
    enum Language: String, CaseIterable {
        case georgian = "ქართული"
        case english = "English"
    }
}
