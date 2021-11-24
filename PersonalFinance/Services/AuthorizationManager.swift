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
        let account = getAccount()
        if login == account?.login && password == account?.password {
            clouser(true)
        } else {
            clouser(false)
        }
    }
    
    func changeLogin(on newLogin: String, clouser: (Bool) -> Void) {
        guard var account = getAccount() else { return }
        if account.login != newLogin {
            account.login = newLogin
            saveAccount(account) { isSaved in
                isSaved == true ? clouser(true) : clouser(false)
            }
        } else {
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
    
    func checkPersonalCode(inputedCode: String, clouser: (Bool) -> Void) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: key),
              let savedPersonalCode = dictionary[keys.personalCode.rawValue] as? String else { return }
        if savedPersonalCode == inputedCode{
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
    
    func printDictionary() {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: key) else { return }
        print(dictionary)
    }
    
    func getAccountDict() -> [String : String] {
        var autorizationData = ["" : ""]
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: key) as? [String : String] else {
            return ["" : ""] }
        for (key, value) in dictionary {
            autorizationData[key] = value
        }
        return autorizationData
    }
    
    func getAccount() -> Account? {
        let accountDict = getAccountDict()
        guard let login = accountDict[keys.login.rawValue],
              let password = accountDict[keys.password.rawValue] else { return nil}
        let account = Account(
            login: login,
            phoneNumber: accountDict[keys.phoneNumber.rawValue],
            password: password,
            personalCode: accountDict[keys.personalCode.rawValue]
        )
        return account
    }
    
    func deleteAccount() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "\(key)")
            DataManager.shared.accountWasDeleted()
            print("account deleted")
        } catch  {
            print("failt to delete an account")
        }
    }
}
