//
//  ForgetPasswordViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 30.05.21.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var buttomConstraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        initNavBar()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
        registerForKeyboardNotifications()
    }
    
    @IBAction func sendCodeTouched() {
        guard let confirmCodeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmCodeViewController") as? ConfirmCodeViewController else  { return }
        navigationController?.pushViewController(confirmCodeVC, animated: true)
    }
    
    
    private func initNavBar() {
        navigationController?.isNavigationBarHidden = false
        title = "Email Confirmation"
    }
    
    private func initUI() {
        sendCodeButton.layer.cornerRadius = 4
        sendCodeButton.addGradient(
            startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1),
            endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1))
        emailContainerView.layer.borderWidth = 2
        emailContainerView.layer.borderColor = CGColor.init(
                red: 195/255,
                green: 211/255,
                blue: 212/255,
                alpha: 1)
        emailContainerView.layer.cornerRadius = 4
    }

}

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
        false
    }
    
    
}
