
import UIKit
class WalletsTableViewController: UITableViewController {

    private var wallets: [Wallet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func viewWillLayoutSubviews() {
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    @IBAction func addButtomTouched(_ sender: UIBarButtonItem) {
                guard let SaveWalletTableVС = UIStoryboard(
                        name: "Home",
                        bundle: nil).instantiateViewController(withIdentifier: "SaveWalletTableViewController") as? SaveWalletTableViewController else  { return }
                navigationController?.pushViewController(SaveWalletTableVС, animated: true)
    }
    
    private func getData() {
        FinanceStorageManager.shared.fetchWallets { result in
            switch result {
            case .success(let wallets):
                self.wallets = wallets
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wallets.count
    }

//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "wallet", for: indexPath)
//        let wallet = wallets[indexPath.row]
//        var content = cell.defaultContentConfiguration()
//        content.text = wallet.title
//        content.secondaryText = "\(wallet.currentBalance) \(wallet.currency)"
//        cell.contentConfiguration = content
//
//        return cell
//    }
    

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

extension WalletsTableViewController {
    private func setNavBar() {
        navigationController?.isNavigationBarHidden = false
        let startPointColor = UIColor(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1)
        let endPointColor = UIColor(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1)
        navigationController?.navigationBar.setGradientBackground(
            colors: [startPointColor, endPointColor],
            startPoint: .bottomRight,
            endPoint: .topLeft)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
}
