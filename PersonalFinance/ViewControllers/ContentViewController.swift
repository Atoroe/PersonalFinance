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
    
    var content: Content?
    var numberOfPages = 0
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    private func initUI() {
        guard let content = content else { return }
        backgroundImage.image = UIImage(named: content.backgroundImage)
        titleLable.text = content.title
        descriptionLable.text = content.description
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = numberOfPages
    }

}
