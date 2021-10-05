//
//  ContentViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 27.05.21.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var exploreTheAppButton: UIButton!
    
    var content: Content?
    var numberOfPages = 0
    var currentPage = 0
    var isButtonHiden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    @IBAction func exploreTheAppTouched() {
        showLoginViewController()
    }
    
    private func setUI() {
        guard let content = content else { return }
        backgroundImage.image = UIImage(named: content.backgroundImage)
        titleLable.text = content.title
        descriptionLable.text = content.description
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = numberOfPages
        exploreTheAppButton.isHidden = isButtonHiden ? true : false
    }
    
    private func showLoginViewController() {
        guard let loginVC = storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else { return }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
}
