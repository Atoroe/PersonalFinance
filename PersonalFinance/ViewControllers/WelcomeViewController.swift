import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGradient(startPointColor: #colorLiteral(red: 0.03529411765, green: 0.07450980392, blue: 0.3803921569, alpha: 1),
                         endPointColor: #colorLiteral(red: 0.007843137255, green: 0.02745098039, blue: 0.1843137255, alpha: 1))
        
        //AuthorizationManager.shared.deleteAccount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if DataManager.shared.isPresentationViewed() {
            showLoginViewController()
            //showHomeVC()
        } else {
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
    
    private func showLoginViewController() {
        guard let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        present(navigationController, animated:true, completion: nil)
    }
    
    //MARK: - ЗАГЛУШКА
    private func showHomeVC() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        guard let navigationVC = storyboard.instantiateViewController(withIdentifier: "HomeNavigationViewController") as? UINavigationController else { return }
//        navigationVC.modalPresentationStyle = .fullScreen
//        self.present(navigationVC, animated: true, completion: nil)
        guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "HomeTabBarController") as? UITabBarController else { return }
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true, completion: nil)
    }
}



