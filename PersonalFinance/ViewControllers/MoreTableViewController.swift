import UIKit

class MoreTableViewController: UITableViewController {
    
    private let maxNumberCount = 12
    
    private var account: Account?
    private var userPhoto: UIImage? {
        get {
            guard let userPhoto = DataManager.shared.loadUserPhoto() else {
                return UIImage(named: "userProfile")
            }
            return userPhoto
        }
    }
    private var number = ""
    private var regexPhoneNumber: NSRegularExpression {
        do {
            let regexPhoneNumber = try NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
            return regexPhoneNumber
        } catch {
            return NSRegularExpression()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
//        guard let account = AuthorizationManager.shared.getAccount() else { return }
//        self.account = account
    }
    
    override func viewWillLayoutSubviews() {
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let account = AuthorizationManager.shared.getAccount() else { return }
        self.account = account
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath.row {
        case 0:
            guard let login = account?.login,
                  let phoneNumber = account?.phoneNumber else { return UITableViewCell() }
            var content = cell.defaultContentConfiguration()
            content.image = userPhoto
            content.imageProperties.cornerRadius = content.image?.size.width ?? 0 / 2
            content.text = login
            content.secondaryText = format(phoneNumber: phoneNumber, shouldRemoveLastDigit: false)
            cell.contentConfiguration = content
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            showUserSettingsVC()
        }
    }
    
    
    // MARK: - Navigation
    
    private func showUserSettingsVC() {
        guard let UserSettingsVC = UIStoryboard(
            name: "Home",
            bundle: nil).instantiateViewController(withIdentifier: "UserSettingViewController") as? UserSettingViewController else  { return }
        navigationController?.pushViewController(UserSettingsVC, animated: true)
    }
    
}

extension  MoreTableViewController {
    private func setNavBar() {
        //navigationController?.isNavigationBarHidden = false
        let startPointColor = UIColor(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1)
        let endPointColor = UIColor(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1)
        navigationController?.navigationBar.setGradientBackground(
            colors: [startPointColor, endPointColor],
            startPoint: .bottomRight,
            endPoint: .topLeft)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - mask for phone number
    private func format(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else { return "+" }
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regexPhoneNumber.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
        
        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }
        
        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
    }
}
