//
//  ViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 24.05.21.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGradient(startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1), endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let presentationWasViewed = userDefaults.bool(forKey: "presentationWasViewed")
        if presentationWasViewed == false {
            startPesentation()
        }

    }
    
    private func startPesentation() {
        let when = DispatchTime.now() + 1
        if let pageVC = storyboard?.instantiateViewController(identifier: "PageViewController") as? PageViewController {
            pageVC.modalPresentationStyle = .fullScreen
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.present(pageVC, animated: true, completion: nil)
            }
        }
    }
}



