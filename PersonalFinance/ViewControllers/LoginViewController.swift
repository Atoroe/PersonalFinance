//
//  LoginViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 28.05.21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var eyeImage: UIImageView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    
    @IBOutlet weak var mainContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintHeight: NSLayoutConstraint!
    
    private var isEyeOff = true
    private var initialConstraintHeight: CGFloat = 0
    private var inintialMainContainerHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPasswordHidden()
        inintialMainContainerHeight = mainContainerHeight.constant
        initialConstraintHeight = bottomConstraintHeight.constant
        registerForKeyboardNotifications()
        navigationItem.backButtonTitle = ""
        
        AuthorizationManager.shared.printDictionary()
    }
    
    override func viewWillLayoutSubviews() {
        addGradient(views: view, loginButton, facebookButton)
        setContanerViews(views: loginContainerView, passwordContainerView)
        setButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func loginTouched() {
        signIn()
    }
    
    @IBAction func forgetPassTouched() {
        guard let forgetPasswordVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgetPasswordViewController") as? ForgetPasswordViewController else  { return }
        navigationController?.pushViewController(forgetPasswordVC, animated: true)
    }
    
    @IBAction func createAnAccountTouched() {
        loginTextField.text = nil
        passwordTextField.text = nil
        showSignUpViewController()
    }
    
    @IBAction func facebookTouched() {
        
    }
    
    //MARK: Autorization
    private func signIn() {
        guard let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
                  setRedBorderFor(views: loginContainerView, passwordContainerView)
                  return
              }
        AuthorizationManager.shared.checkAccount(by: login, and: password) { isValidation in
            print(isValidation)
            if isValidation {
                loginTextField.text = nil
                passwordTextField.text = nil
                switchToHomeSB()
            } else {
                setRedBorderFor(views: loginContainerView, passwordContainerView)
            }
        }
    }
    
    private func showSignUpViewController() {
        guard let signInVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as? SignUpViewController else { return }
        signInVC.modalPresentationStyle = .fullScreen
        present(signInVC, animated: true, completion: nil)
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
    
    
}

//MARK: Set UI
extension LoginViewController {
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
    
    private func setButtons() {
        loginButton.layer.cornerRadius = 4
        facebookButton.layer.cornerRadius = 4
        //        facebookButton.setTitle("Facebook", for: .normal)
        //        let image = UIImage(named: "facebook")
        //        facebookButton.setImage(UIImage(named: "facebook"), for: .normal)
        //        facebookButton.imageEdgeInsets.left = -50
    }
    
    private func setRedBorderFor(views: UIView...) {
        views.forEach { view in
            view.layer.borderColor = CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)
        }
    }
    
    //MARK: - show HomeVC
    private func switchToHomeSB() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeTabBarController = storyboard.instantiateViewController(identifier: "HomeTabBarController")
        homeTabBarController.modalPresentationStyle = .fullScreen
        self.present(homeTabBarController, animated: true, completion: nil)
    }
}

// MARK: - textField methods
extension LoginViewController: UITextFieldDelegate {
    
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
            passwordTextField.becomeFirstResponder()
        } else {
            signIn()
        }
        return true
    }
}

