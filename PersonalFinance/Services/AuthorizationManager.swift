//
//  AuthorizationManager.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 13.08.21.
//
import Locksmith

enum keys: String {
    case login = "login"
    case phoneNumber = "phoneNumber"
    case password = "password"
    case personalCode = "personalCode"
}

class AuthorizationManager {
    static let shared = AuthorizationManager()
    
    private let key = "myAccount"
    
    private init() {}
    
    func saveAccount(_ account: Account, clouser: (Bool) -> Void) {
        guard let phoneNumber = account.phoneNumber else { return }
        do {
            try Locksmith.saveData(data: [
                                    keys.login.rawValue: account.login,
                                    keys.phoneNumber.rawValue: phoneNumber,
                                    keys.password.rawValue: account.password,
                                    keys.personalCode.rawValue: "\(Int.random(in: 1000...9999))"
                                    ],
                                   forUserAccount: key )
            DataManager.shared.accountWasCreated()
            clouser(true)
        } catch {
            print(Error.self)
            clouser(false)
        }
    }
    
    func checkAccount(by login: String, and password: String, clouser: (Bool) -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: key),
              let savedLogin = dictionary[keys.login.rawValue] as? String,
              let savedPassword = dictionary[keys.password.rawValue] as? String else {
            clouser(false)
            return
        }
        if login == savedLogin && password == savedPassword {
            clouser(true)
        } else {
            clouser(false)
        }
    }
    
    func  getPersonalCode(by phoneNumber: String, clouser: (String?) -> Void){
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: key),
              let savedPhoneNumber = dictionary[keys.phoneNumber.rawValue] as? String,
              let personalCode = dictionary[keys.personalCode.rawValue] as? String else {
            return
        }
        savedPhoneNumber == phoneNumber ? clouser(personalCode) : clouser(nil)
    }
    
    func checkPersonalCode(inputedCode: String, clouser: (Bool) -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: key),
              let savedPersonalCode = dictionary[keys.personalCode.rawValue] as? String else { return }
        if savedPersonalCode == inputedCode{
            clouser(true)
        } else {
            print("валидация кода не прошла")
            clouser(false)
        }
    }
    
    func changePassword(on newPassword: String, clouser: (Bool) -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: key),
              let login = dictionary[keys.login.rawValue] as? String,
              let phoneNumber = dictionary[keys.phoneNumber.rawValue] as? String,
              let password = dictionary[keys.password.rawValue] as? String else { return }
        if password != newPassword {
            do {
                try Locksmith.updateData(data: [
                                            keys.login.rawValue : login,
                                            keys.phoneNumber.rawValue : phoneNumber,
                                            keys.password.rawValue : newPassword,
                                            keys.personalCode.rawValue : "\(Int.random(in: 1000...9999))"
                                            ], forUserAccount: key)
                clouser(true)
            } catch {
                print(Error.self)
                clouser(false)
            }
        } else {
            clouser(false)
        }
    }
    
    func printDictionary() {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: key) else { return }
        print(dictionary)
    }
    
    func deleteAccount() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "\(key)")
            DataManager.shared.accountWasDeleted()
            print("аккаунт удален")
        } catch  {
            print("не могу очистить")
        }
    }
}
