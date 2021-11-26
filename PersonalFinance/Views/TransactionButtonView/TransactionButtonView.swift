//
//  TransactionButtonView.swift
//  PersonalFinance
//
//  Created by Artiom Poluyanovich on 24.11.21.
//

import UIKit

class TransactionButtonView: UIView {
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var transactionButton: UIButton!
    
    private let buttonImage = UIImage(named: "share-logo")
    private var isTouched = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTransactionButton()
    }
    
    @IBAction func transactionButtonTouched() {
        isTouched.toggle()
        if isTouched {
            blurView.isHidden = true
            print("blurView.isHidden = false")
        } else {
            blurView.isHidden = false
            print("blurView.isHidden = true")
        }
    }
    
    private func setTransactionButton() {
        transactionButton.layer.cornerRadius = transactionButton.frame.size.height / 2
        transactionButton.clipsToBounds = true
        transactionButton.setImage(buttonImage, for: .normal)
//        transactionButton.imageEdgeInsets = UIEdgeInsets.init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    }

}
