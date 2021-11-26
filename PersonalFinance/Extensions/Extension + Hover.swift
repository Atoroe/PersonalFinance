import UIKit
import Hover

extension UIImage {
    
    static var share: UIImage {
        return UIImage(named: "share-logo")!
    }
    
    static var income: UIImage {
        return UIImage(named: "dollar-sign")!
    }
    
    static var payment: UIImage {
        return UIImage(named: "minus-sign")!
    }
}

extension UIColor {
    
    static var hoverOrange: UIColor {
        return UIColor(red: 246/255, green: 89/255, blue: 32/255, alpha: 1.0)
    }
    
    static var hoverGreen: UIColor {
        return UIColor(red: 66/255, green: 149/255, blue: 65/255, alpha: 1.0)
    }
    
    static var hoverBlue: UIColor {
        return UIColor(red: 10/255, green: 89/255, blue: 244/255, alpha: 1.0)
    }
}
