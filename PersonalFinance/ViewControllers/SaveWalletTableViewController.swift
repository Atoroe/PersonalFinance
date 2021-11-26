import UIKit

protocol TitleTableViewCellDelegate {
    func setText(for value: String)
}

class SaveWalletTableViewController: UITableViewController {
    
    var wallet: Wallet?
//    var purse: Purse {
//        get {
//            //setPurse(wallet)
//        }
//    }
    var walletTitle = "" {
        didSet {
            print(walletTitle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            tableView.register(TextFieldTableViewCell.nib(), forCellReuseIdentifier: TextFieldTableViewCell.identifier)
        
    }
    
    override func viewWillLayoutSubviews() {
        setNavBar()
    }
    
//    private func setPurse(_ wallet: Wallet?) -> Purse {
//        guard let wallet = wallet else  {
//            let purse =  Purse(
//                title: "",
//                typeOfPurse: TypeOfPurse.debitCreditCard.rawValue,
//                currency: PurseManager.shared.currencies["BYR"] ?? "Belarusian Ruble",
//                currentBalance: 0,
//                isInTotalBalance: true)
//            return purse
//        }
//        let purse = Purse(
//            title: wallet.title!,
//            typeOfPurse: wallet.typeOfWallet!,
//            currency: wallet.currency!,
//            currentBalance: wallet.currentBalance,
//            isInTotalBalance: wallet.isInTotalBalance)
//        return purse
//    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.identifier, for: indexPath) as? TextFieldTableViewCell else { return UITableViewCell() }
            titleCell.delegate = self
            return titleCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = String(indexPath.row)
            cell.contentConfiguration = content
            return cell
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SaveWalletTableViewController {
    private func setNavBar() {
        navigationController?.navigationBar.topItem?.title = nil
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveButtonTouched))
    }
    
    @objc func saveButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
}

extension SaveWalletTableViewController: TitleTableViewCellDelegate {
    func setText(for walletTitle: String) {
        self.walletTitle = walletTitle
    }
    
}

/*
 import UIKit

 class TitleTableViewCell: UITableViewCell {

     @IBOutlet weak var titleTextField: UITextField!
     
     static let identifier = "titleTableViewCell"
     var delegate: TitleTableViewCellDelegate!
     
     override func awakeFromNib() {
         super.awakeFromNib()
         titleTextField.delegate = self
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }
     
     static func nib() -> UINib {
         return UINib(nibName: "TextFieldTableViewCell", bundle: nil)
     }
     
     func setCell(placeholder: String, textAlignment: NSTextAlignment) {
         titleTextField.placeholder = placeholder
         titleTextField.textAlignment = textAlignment
     }
 }

 extension TitleTableViewCell: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         titleTextField.resignFirstResponder()
         return true
     }
     
     override func endEditing(_ force: Bool) -> Bool {
         guard let title = titleTextField.text else { return false }
         delegate.setText(for: title)
         return true
     }
 }

 */
