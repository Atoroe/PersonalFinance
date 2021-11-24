import UIKit

class NewPasswordViewController: UIViewController {

    @IBOutlet weak var paswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var repeatPasswordView: UIView!
    
    @IBOutlet weak var passwordEyeImage: UIImageView!
    @IBOutlet weak var repeatPasswordEyeImage: UIImageView!
    
    @IBOutlet weak var savePasswordButton: UIButton!
    
    @IBOutlet weak var savePasswordBottomConstraintHeight: NSLayoutConstraint!
    
    private let minLength = 6
    
    private lazy var regex = "^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{\(minLength),}$"
    private var isPasswordEyeOff = true
    private var isRepeatPasswordEyeOff = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPasswordHidden()
        registerForKeyboardNotifications()
    }

    override func viewWillLayoutSubviews() {
            setUI()
        setContanerViews(views: passwordView, repeatPasswordView)
    }
    
    @IBAction func savePasswordTouched() {
        savePassword()
    }
    
    //MARK: set UI
    private func setUI() {
        title = "Forget Password"
        savePasswordButton.layer.cornerRadius = 4
        savePasswordButton.addGradient(
            startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1),
            endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1))
    }
    
    private func setContanerViews(views: UIView...) {
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
    
    private func setRedBorderFor(views: UIView...) {
        views.forEach { view in
            view.layer.borderColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
        }
    }

    
    //MARK: - change password
    private func savePassword() {
        guard let password = paswordTextField.text, !password.isEmpty,
              let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty else {
                  setRedBorderFor(views: passwordView, repeatPasswordView)
                  return
              }
        if password == repeatPassword{
            validatePassword(password)
            AuthorizationManager.shared.changePassword(on: password) { isPasswordChanged in
                if isPasswordChanged {
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    setRedBorderFor(views: passwordView, repeatPasswordView)
                    print("не сохранился новый пароль")
                }
            }
        } else {
            setRedBorderFor(views: passwordView, repeatPasswordView)
        }
    }
    
    private func validatePassword(_ password: String) {
        if password.matches(regex) {
            return
        } else {
            setRedBorderFor(views: passwordView, repeatPasswordView)
            let alert = UIAlertController(
                title: "Ошибка ввода пароля!",
                message: "Минимум \(minLength) символов\n Пароль должен содержать: \n1 большую букву, \n1 маленькую букву, \n1 цифру и\nспециальный символ",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    //MARK: Show or Hide passwordTF
    private func isPasswordHidden() {
        let passwordEyeDetector = UITapGestureRecognizer(target: self, action: #selector(passwordEyeImageTapped(_:)))
        passwordEyeImage.isUserInteractionEnabled = true
        passwordEyeImage.addGestureRecognizer(passwordEyeDetector)
        
        let repeatPasswordEyeDetector = UITapGestureRecognizer(target: self, action: #selector(repeatPasswordEyeImageTapped(_:)))
        repeatPasswordEyeImage.isUserInteractionEnabled = true
        repeatPasswordEyeImage.addGestureRecognizer(repeatPasswordEyeDetector)
    }
    
    @objc func passwordEyeImageTapped(_ recognizer: UITapGestureRecognizer) {
        isPasswordEyeOff.toggle()
        if isPasswordEyeOff {
            passwordEyeImage.image = UIImage(named: "eye-off")
            paswordTextField.isSecureTextEntry = true
        } else {
            passwordEyeImage.image = UIImage(named: "eye")
            paswordTextField.isSecureTextEntry = false
        }
    }
    
    @objc func repeatPasswordEyeImageTapped(_ recognizer: UITapGestureRecognizer) {
        isRepeatPasswordEyeOff.toggle()
        if isRepeatPasswordEyeOff {
            repeatPasswordEyeImage.image = UIImage(named: "eye-off")
            repeatPasswordTextField.isSecureTextEntry = true
        } else {
            repeatPasswordEyeImage.image = UIImage(named: "eye")
            repeatPasswordTextField.isSecureTextEntry = false
        }
    }
    
}

// MARK: - textField methods
extension NewPasswordViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillChange(_ notification: NSNotification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            savePasswordBottomConstraintHeight.constant = keyboardFrame.height + 16
            self.view.layoutIfNeeded()
        } else {
            savePasswordBottomConstraintHeight.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == paswordTextField {
            repeatPasswordTextField.becomeFirstResponder()
        } else {
            savePassword()
        }
        resignFirstResponder()
        return true
    }
}


