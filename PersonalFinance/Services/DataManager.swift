import UIKit


class DataManager {
    static let shared = DataManager()
    
    let userDefaults = UserDefaults.standard
    let keyImage = "image"
    
    private init() {}
 
    func presentationWasViewed() {
        userDefaults.setValue(true, forKey: "presentationWasViewed")
    }
    
    func isPresentationViewed() -> Bool {
        userDefaults.bool(forKey: "presentationWasViewed")
    }
    
    func accountWasCreated() {
        userDefaults.setValue(true, forKey: "accountWasCreated")
    }
    
    func isAccountWasCreated() -> Bool {
        userDefaults.bool(forKey: "accountWasCreated")
    }
    
    func accountWasDeleted() {
        userDefaults.setValue(false, forKey: "accountWasCreated")
    }
    
    func saveUserPhoto(_ image: UIImage) {
        let data = image.jpegData(compressionQuality: 1.0)
        userDefaults.set(data, forKey: keyImage)
        userDefaults.synchronize()
    }
    
    func loadUserPhoto() -> UIImage? {
        guard let data = userDefaults.value(forKey: keyImage) as? Data else { return nil }
        guard let image = UIImage(data: data, scale: 1.0) else { return nil }
        return image
    }
    
}

