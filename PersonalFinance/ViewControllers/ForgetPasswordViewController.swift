import UIKit

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var buttomConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let maxNumberCount = 12
    private var number = ""
    private var regexPhoneNumber: NSRegularExpression {
            do {
                let regexPhoneNumber = try NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
                return regexPhoneNumber
            } catch {
                return NSRegularExpression()
            }
    }
    
    override func viewWillLayoutSubviews() {
        setNavBar()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        phoneTextField.text = nil
        alertLabel.isHidden = true
        phoneTextField.becomeFirstResponder()
        registerForKeyboardNotifications()
        activityIndicator.isHidden = true
    }
    
    @IBAction func sendCodeTouched() {
        sentConfirmationCodeBySMS()
    }
    
//MARK: - set UI
    private func setNavBar() {
        let startPointColor = UIColor(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1)
        let endPointColor = UIColor(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1)
        navigationController?.navigationBar.setGradientBackground(
            colors: [startPointColor, endPointColor],
            startPoint: .bottomRight,
            endPoint: .topLeft)
        navigationController?.isNavigationBarHidden = false
        title = "Phone Number Confirmation"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.backButtonTitle = ""
    }
    
    private func setUI() {
        sendCodeButton.layer.cornerRadius = 4
        sendCodeButton.addGradient(
            startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1),
            endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1))
        phoneContainerView.layer.borderWidth = 2
        phoneContainerView.layer.borderColor = CGColor.init(
            red: 195/255,
            green: 211/255,
            blue: 212/255,
            alpha: 1)
        phoneContainerView.layer.cornerRadius = 4
    }
    
    private func setRedBorderFor(views: UIView...) {
        views.forEach { view in
            view.layer.borderColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
        }
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
    
    private func showConfirmVC(with fullPhoneNumber: String) {
        guard let confirmCodeVC = UIStoryboard(
                name: "Main",
                bundle: nil).instantiateViewController(withIdentifier: "ConfirmCodeViewController") as? ConfirmCodeViewController else  {
            return }
        confirmCodeVC.phoneNumber = fullPhoneNumber
        navigationController?.pushViewController(confirmCodeVC, animated: true)
        return
    }
}

// MARK: - Sending confirmation code by SMS
extension ForgetPasswordViewController {
    func sentConfirmationCodeBySMS() {
        guard let phoneNumber = phoneTextField.text?.digits, phoneNumber.count == 12 else {
            setRedBorderFor(views: phoneContainerView)
            return }
        number = phoneTextField.text ?? ""
        AuthorizationManager.shared.getPersonalCode(by: phoneNumber, clouser: { personalCode in
            guard let personalCode = personalCode else { return }
            phoneTextField.text = nil
            sendSMS(to: phoneNumber, with: personalCode)
        })
    }
    
    func sendSMS(to recipient: String, with confirmationCode: String) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        NetworkManager.shared.postRequestToRocketSMS(phone: recipient, message: confirmationCode) { result in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            switch result {
            case .success(let status):
                self.checkResult(in: status) { result in
                    guard let result = result else {
                        self.alertLabel.isHidden = false
                        return
                    }
                    print(result)
                    self.showConfirmVC(with: self.number)
                }
            case .failure(let error):
                print(error.localizedDescription )
            }
        }
    }
    
    func checkResult(in result: [String:Any], complition: (String?) -> Void) {
        if result.count == 1 {
            guard let error = result["error"] as? String else { return }
            print("Error: \(error)")
            complition(nil)
        } else {
            guard let id = result["id"] as? Int,
                  let status = result["status"] as? String else { return }
            complition("Sucsess! Id: \(id), Status: \(status)")
        }
    }
}

//MARK: - TextFieldDelegate
extension ForgetPasswordViewController: UITextFieldDelegate {
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillChange(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillShowNotification {
            buttomConstraintHeight.constant = keyboardFrame.height + 16
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sentConfirmationCodeBySMS()
        resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let fullString = (textField.text ?? "") + string
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            return false
        }
        return true
    }
}
