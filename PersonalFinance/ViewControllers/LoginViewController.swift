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
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    
    private var isEyeOff = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPasswordHidden()
    }
    
    override func viewWillLayoutSubviews() {
        addGradient(views: view, loginButton, facebookButton)
        setContanerViews()
        setButtons()
    }
    
    @IBAction func loginTouched() {
        
    }
    
    @IBAction func forgetPassTouched() {
        
    }
    
    @IBAction func createAnAccountTouched() {
        
    }
    
    @IBAction func facebookTouched() {
        
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
extension LoginViewController {
    private func addGradient(views: UIView...) {
        views.forEach { $0.addGradient(
            startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1),
            endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1)
            )
        }
    }
    
    private func setContanerViews() {
        emailContainerView.layer.borderWidth = 2
        emailContainerView.layer.borderColor = CGColor.init(
            red: 195/255,
            green: 211/255,
            blue: 212/255,
            alpha: 1)
        emailContainerView.layer.cornerRadius = 4
        passwordContainerView.layer.borderWidth = 2
        passwordContainerView.layer.borderColor = CGColor.init(
            red: 195/255,
            green: 211/255,
            blue: 212/255,
            alpha: 1)
        passwordContainerView.layer.cornerRadius = 4
    }
    
    private func setButtons() {
        loginButton.layer.cornerRadius = 4
        facebookButton.layer.cornerRadius = 4
    }
}

