//
//  DataManager.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 28.05.21.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    let userDefaults = UserDefaults.standard
 
    func presentationWasViewed() {
        userDefaults.setValue(false, forKey: "presentationWasViewed")
    }
    
    func isPresentationViewed() -> Bool {
        userDefaults.bool(forKey: "presentationWasViewed")
    }
    
    
    private init() {}
}

