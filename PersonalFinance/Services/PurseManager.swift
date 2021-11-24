enum TypeOfPurse: String {
    case cash = "Cash"
    case debitCreditCard = "Debit/credit card"
    case deposit = "Deposit"
}

class PurseManager {
    static let shared = PurseManager()
    
    let currencies = [
        "BYR" : "Belarusian Ruble",
        "RUB" : "Russian Ruble",
        "USD" : "United States Dollar",
        "EUR" : "Euro",
        "UAH" : "Ukrainian Hryvnia",
        "PLN" : "Polysh Zloty"
    ]
    

    
    private init() {}
}
