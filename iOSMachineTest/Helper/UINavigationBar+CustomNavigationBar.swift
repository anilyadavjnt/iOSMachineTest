//
//  UINavigationBar+CustomNavigationBar.swift
//  iOSMachineTest
//
//  Created by Anil Yadav on 12/03/25.
//  Email: anilyadavjnt@gmail.com
//  Contact No: +91-975211420
//

import UIKit

extension UIViewController {
    
    func setupNavigationBar(bgColor: UIColor = .systemRed, titleString: String = "") {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = bgColor
            appearance.shadowColor = nil
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = bgColor
            navigationController?.navigationBar.tintColor = bgColor
        }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationController?.isNavigationBarHidden = false
        if !titleString.isEmpty {
            let titleLbl = UILabel()
            titleLbl.font = .systemFont(ofSize: 16, weight: .bold)
            titleLbl.textColor = .white
            titleLbl.text = titleString
            titleLbl.textAlignment = .center
            titleLbl.adjustsFontSizeToFitWidth = true
            navigationItem.titleView = titleLbl
        }
    }    
}


extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.masksToBounds = false
    }
}
