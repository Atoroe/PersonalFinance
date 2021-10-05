//
//  SignUpViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 30.05.21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var eyeImage: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var mainContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintHeight: NSLayoutConstraint!
    
    private let minLength = 6
    private let maxNumberCount = 12
    private var regexPhoneNumber: NSRegularExpression {
            do {
                let regexPhoneNumber = try NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
                return regexPhoneNumber
            } catch {
                return NSRegularExpression()
            }
    }
    
    private var isEyeOff = true
    private var initialConstraintHeight: CGFloat = 0
    private var inintialMainContainerHeight: CGFloat = 0
    private var newAccount: Account!
    
    private lazy var regex = "^(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{\(minLength),}$"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPasswordHidden()
        inintialMainContainerHeight = mainContainerHeight.constant
        initialConstraintHeight = bottomConstraintHeight.constant
        registerForKeyboardNotifications()
    }
    
    override func viewWillLayoutSubviews() {
        addGradient(views: view, signUpButton)
        setContanerViews(views: loginContainerView, phoneContainerView, passwordContainerView)
        signUpButton.layer.cornerRadius = 4
    }
    
    @IBAction func signUpTouched() {
        createNewAccount()
    }
    
    @IBAction func haveAnAccountTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Show or Hide passwordTF
    private func isPasswordHidden() {
        let detector = UITapGestureRecognizer(target: self, action: #selector(eyeImageTapped(_:)))
        eyeImage.isUserInteractionEnabled = true
        eyeImage.addGestureRecognizer(detector)
    }
    
    @objc func eyeImageTapped(_ recognizer: UITapGestureRecognizer) {
        isEyeOff.toggle()
        if isEyeOff {
            eyeImage.image = UIImage(named: "eye-off")
            passwordTextField.isSecureTextEntry = true
        } else {
            eyeImage.image = UIImage(named: "eye")
            passwordTextField.isSecureTextEntry = false
        }
    }
    
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
            let pattern = "(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
        } else {
            let pattern = "(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
        }
        
        return "+" + number
    }
    
    //MARK: Autorization
    private func createNewAccount() {
        guard let userName = loginTextField.text, !userName.isEmpty,
              let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  setRedBorderFor(views: loginContainerView, phoneContainerView ,passwordContainerView)
                  return
        }
        
        validatePassword(password)
        
        if !DataManager.shared.isAccountWasCreated() {
            newAccount = Account(login: userName, phoneNumber: phoneNumber.digits, password: password)
            guard let newAccount = newAccount else { return }

            AuthorizationManager.shared.saveAccount(newAccount, clouser: { isSaved in
                if isSaved {
                    loginTextField.text = nil
                    phoneTextField.text = nil
                    passwordTextField.text = nil
                    dismiss(animated: true, completion: nil)
                }
            })
        } else {
            let alert = UIAlertController(
                title: "Account has already been created!",
                message: "This device already \nhas a created account",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.loginTextField.text = nil
                self.phoneTextField.text = nil
                self.passwordTextField.text = nil
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
        

    }

    private func validatePassword(_ password: String) {
        if password.matches(regex) {
            return
        } else {
            setRedBorderFor(views: passwordContainerView)
            let alert = UIAlertController(
                title: "Password entered error!",
                message: "Minimum \(minLength) characters in password \nPassword must contain at least: \n1 capital letter, \n1 small letter, \n1 number and a special character",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}

//MARK: Set UI
extension SignUpViewController {
    private func addGradient(views: UIView...) {
        views.forEach { $0.addGradient(
            startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1),
            endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1)
        )
        }
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
    
}

// MARK: - textField methods
extension SignUpViewController: UITextFieldDelegate {
    
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
            mainContainerHeight.constant += keyboardFrame.height - bottomConstraintHeight.constant
            bottomConstraintHeight.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        } else {
            mainContainerHeight.constant = inintialMainContainerHeight
            bottomConstraintHeight.constant = initialConstraintHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            phoneTextField.becomeFirstResponder()
        } else {
            createNewAccount()
        }
        resignFirstResponder()
        return true
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


