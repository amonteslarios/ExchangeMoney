//
//  UIViewController+Extension.swift
//  ConvertCurrencies
//
//  Created by Anthony Montes Larios on 26/02/21.
//

import UIKit

extension UIViewController {
    
    func setupHideKeyboardOnTap( container : UIView) {
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        container.addGestureRecognizer(tap)
    }
        
    /// Se sale de foco cuando se presione fuera
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
