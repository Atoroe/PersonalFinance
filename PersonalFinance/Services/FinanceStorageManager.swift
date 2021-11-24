import CoreData

class FinanceStorageManager {
    
    static let shared = FinanceStorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersonalFinance")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - fetch/save/edit/delete wallet
    func fetchWallets(completion: (Result<[Wallet], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        
        do {
            let wallets = try viewContext.fetch(fetchRequest)
            completion(.success(wallets))
        } catch let error {
            completion(.failure(error))
        }
    }
    
//    func saveWallet(_ purse: Purse, completion: (Wallet) -> Void) {
//        let wallet = Wallet(context: viewContext)
//        wallet.title = purse.title
//        wallet.currency = purse.currency
//        wallet.typeOfWallet  = purse.typeOfPurse
//        wallet.currentBalance = purse.currentBalance
//        wallet.isInTotalBalance = purse.isInTotalBalance
//
//        completion(wallet)
//        saveContext()
//    }
    
    func editWalletTitle(_ wallet: Wallet, newTitle: String) {
        wallet.title = newTitle
        saveContext()
    }
    
    func deleteWallet(_ wallet: Wallet) {
        viewContext.delete(wallet)
        saveContext()
    }


    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

