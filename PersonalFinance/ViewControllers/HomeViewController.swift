import Charts

class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

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
}



