//
//  SignUpViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 30.05.21.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var eyeImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNameContainerView: UIView!
    @IBOutlet weak var emailContainerView: UIView!
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
    }
    
    override func viewWillLayoutSubviews() {
        addGradient(views: view, signUpButton)
        setContanerViews(views: userNameContainerView, emailContainerView, passwordContainerView)
        signUpButton.layer.cornerRadius = 4
    }
    
    @IBAction func signUpTouched() {
        
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
    
}

//MARK: Init UI
extension SignInViewController {
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
}

// MARK: - textField methods
extension SignInViewController: UITextFieldDelegate {
    
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
        resignFirstResponder()
        return true
    }
}


