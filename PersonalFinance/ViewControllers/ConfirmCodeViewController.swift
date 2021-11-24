import UIKit

class ConfirmCodeViewController: UIViewController {
    
    @IBOutlet weak var confirmCodeButton: UIButton!
    @IBOutlet var codeViews: [UIView]!
    @IBOutlet var personalCodeTextFields: [UITextField]!
    @IBOutlet weak var buttomConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPhoneNumberTextColor()
    }
    
    override func viewWillLayoutSubviews() {
        setUI()
        initViews(views: codeViews)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        personalCodeTextFields.first?.becomeFirstResponder()
        registerForKeyboardNotifications()
        
        guard let phoneNumber = phoneNumber else {
            return
        }
        print(phoneNumber)

    }
    
    @IBAction func confirmCodeTouched() {
        checkPersonalCode()
    }
    
    private func showNewPasswordVC() {
        guard let NewPasswordVС = UIStoryboard(
                name: "Main",
                bundle: nil).instantiateViewController(withIdentifier: "NewPasswordVС") as? NewPasswordViewController else  {
            return }
        navigationController?.pushViewController(NewPasswordVС, animated: true)
    }
    
//MARK: - set UI
    private func setUI() {
        title = "Phone Confirmation"
        confirmCodeButton.layer.cornerRadius = 4
        confirmCodeButton.addGradient(
            startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1),
            endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1))
    }
    
    private func initViews(views: [UIView]) {
        views.forEach { view in
            view.layer.borderWidth = 2
            view.layer.borderColor = CGColor.init(
                red: 195/255,
                green: 211/255,
                blue: 212/255,
                alpha: 1)
            view.layer.cornerRadius = 4
        }
    }
    
    private func setRedBorderFor(views: [UIView]) {
        views.forEach { view in
            view.layer.borderColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
        }
    }
    
//MARK: - checking personal code
    private func checkPersonalCode() {
        var code = ""
        personalCodeTextFields.forEach { textField in
            if let number = textField.text {
                code += number
            } else {
                setRedBorderFor(views: codeViews)
            }
        }
        AuthorizationManager.shared.checkPersonalCode(inputedCode: code) { isConfirm in
            if isConfirm {
                personalCodeTextFields.forEach { textField in
                    textField.text = nil
                }
                self.showNewPasswordVC()
            } else {
                setRedBorderFor(views: codeViews)
                self.alertLabel.isHidden = false
            }
        }
    }
    
    private func setPhoneNumberTextColor() {
        guard let phoneNumber = phoneNumber else {
            return
        }

        let color = UIColor.darkGray
        let phoneNumberColor = UIColor.systemBlue
        
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        let phoneNumberAttributes = [NSAttributedString.Key.foregroundColor: phoneNumberColor]
        
        let firstPart = "We sent a code to "
        let secondPart = ". Please write down."
        
        let firstAttrString = NSMutableAttributedString(string: firstPart, attributes: attributes)
        let phoneAttrString = NSAttributedString(string: phoneNumber, attributes: phoneNumberAttributes)
        let secondAttrString = NSAttributedString(string: secondPart, attributes: attributes)
        
        firstAttrString.append(phoneAttrString)
        firstAttrString.append(secondAttrString)
        
        phoneNumberLabel.attributedText = firstAttrString
    }
}

//MARK: - TextFieldDelegate
extension ConfirmCodeViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
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
        } else {
            buttomConstraintHeight.constant = 16
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkPersonalCode()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 1
    }
}
