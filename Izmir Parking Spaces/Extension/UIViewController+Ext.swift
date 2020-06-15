//
//  UIViewController+Ext.swift
//  Izmir Parking Spaces
//
//  Created by Murat Baykor on 15.06.2020.
//  Copyright © 2020 Murat Baykor. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertOnMainThread(alertTitle: String, alertMessage: String, buttonTitle: String) {
        
        DispatchQueue.main.async {
            
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
            
        }
    }
}
