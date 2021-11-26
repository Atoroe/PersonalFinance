import Charts
import Hover
import UIKit

class HomeViewController: UIViewController {
    
    /*
    class func instanceFromNib() -> TransactionButtonView {
        return UINib(nibName: "TransactionButtonView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! TransactionButtonView
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        setHoverButton()
    }
    
    override func viewWillLayoutSubviews() {
        addGradient(for: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
}

//MARK: Set UI
extension HomeViewController {
    private func addGradient(for views: UIView...) {
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
    
    private func addXib() {
        if let TransactionButtonXib = Bundle.main.loadNibNamed("TransactionButtonView", owner: self, options: nil)?.first as? TransactionButtonView {
            view.addSubview(TransactionButtonXib)
        }
    }
    
    private func setHoverButton() {
        let hoverView = HoverView(with: HoverConfiguration(image: .share, color: .color(UIColor.hoverOrange)),
                                                items: [
                                                    HoverItem(title: "Add income",
                                                              image: .income,
                                                              color: .color(UIColor.hoverGreen)) {
                                                                  self.showIncomeVC()},
                                                    HoverItem(title: "Make a payment",
                                                              image: .payment,
                                                              color: .color(UIColor.hoverBlue)) {
                                                                  self.showPaymentVC()}
                                                        ])
        view.addSubview(hoverView)
        hoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                hoverView.topAnchor.constraint(equalTo: view.topAnchor),
                hoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                hoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                hoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
    }
}

//MARK: Navigation
extension HomeViewController {
    private func showPaymentVC() {
        print("Tapped 'Make a payment'")
    }
    
    private func showIncomeVC() {
        print("Tapped 'Add income'")
    }
}




