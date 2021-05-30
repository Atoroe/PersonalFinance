//
//  PageViewController.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 27.05.21.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let contents = Content.getContents()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        showFirstViewController()
    }
    
    private func showViewControllerAtIndex(_ index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < contents.count else {
            DataManager.shared.presentationWasViewed()
            return nil
        }
        guard let contentVC = storyboard?.instantiateViewController(identifier: "ContentViewController") as? ContentViewController else {
            return nil
        }
        contentVC.content = contents[index]
        contentVC.currentPage = index
        contentVC.numberOfPages = contents.count
        if index == contents.count - 1 {
            contentVC.isButtonHiden = false
        }
        
        return contentVC
    }

    
    private func showFirstViewController() {
        if let contentVC = showViewControllerAtIndex(0) {
            setViewControllers(
                [contentVC],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! ContentViewController).currentPage
        pageNumber -= 1
        
        return showViewControllerAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! ContentViewController).currentPage
        pageNumber += 1
        
        return showViewControllerAtIndex(pageNumber)
    }
}


