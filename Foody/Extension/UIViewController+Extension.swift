//
//  UIViewController+Extension.swift
//  Foody
//
//  Created by duc nguyen on 22/07/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(message: String, actions: [String], completions: @escaping ((Int)->Void)) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        
        actions.enumerated().forEach { element in
            let action = UIAlertAction(title: element.element, style: .default) { _ in
                completions(element.offset)
            }
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }
}
