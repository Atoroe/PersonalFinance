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
    
    ////////////
    func accountWasDeleted() {
        userDefaults.setValue(false, forKey: "accountWasCreated")
    }
    
}

