//
//  ConfirmCodeViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 31.05.21.
//

import UIKit

class ConfirmCodeViewController: UIViewController {

    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet var codeViews: [UIView]!
    @IBOutlet var confirmationCodeTextFields: [UITextField]!
    @IBOutlet weak var buttomConstraintHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        initNavBar()
        initUI()
        initViews(views: codeViews)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        confirmationCodeTextFields.first?.becomeFirstResponder()
        registerForKeyboardNotifications()
    }
    
    @IBAction func sendCodeTouched() {
        
    }
    
    
    private func initNavBar() {
        navigationController?.isNavigationBarHidden = false
        title = "Forget Password"
    }
    
    private func initUI() {
        sendCodeButton.layer.cornerRadius = 4
        sendCodeButton.addGradient(
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
}

extension ConfirmCodeViewController: UITextFieldDelegate {
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
