//
//  Theme.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/27/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

enum Theme: Int {
    case dark, light

    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }

    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .dark
    }
    
    var mainColor: UIColor {
        switch self {
        case .dark:
            return UIColor(red: 132.0/255.0, green: 13.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        case .light:
            return UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .dark:
            return .black
        case .light:
            return .black
        }
    }
    
    var backgroundColor1: UIColor {
        switch self {
        case .dark:
            //Dark Gray
            return UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .light:
            //Sky
            return UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    var backgroundColor2: UIColor {
        switch self {
        case .dark:
            //Light Gray
            return UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        case .light:
            return UIColor.white
        }
    }
    
    var backgroundColor3: UIColor {
        switch self {
        case .dark:
            return UIColor(white: 0.4, alpha: 1.0)
        case .light:
            return UIColor.white
        }
    }
    
    var tabBarColor: UIColor {
        switch self {
        case .dark:
            //Dark Gray
            return UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .light:
            return UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.black
        }
    }
    
    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        UIApplication.shared.delegate?.window??.backgroundColor = backgroundColor3
//        UIApplication.shared.delegate?.window??.backgroundColor = mainColor
        
        UITabBar.appearance().barTintColor = tabBarColor
       //UITabBar.appearance().barStyle = barStyle

        //UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().barTintColor = backgroundColor1
//        UINavigationBar.appearance().barStyle = barStyle
        

        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = backgroundColor1
        
        UITableViewCell.appearance().backgroundColor = backgroundColor2
        UITableView.appearance().backgroundColor = backgroundColor2
        
        //UILabel.appearance().textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).textColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).textColor = textColor
       
        UIView.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).backgroundColor = backgroundColor1
        UIView.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).backgroundColor = backgroundColor2
        
        UIButton.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).tintColor = .white
        UIButton.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).backgroundColor = mainColor
        UIButton.appearance().tintColor = textColor
        
//        let controlBackground = UIImage(named: "controlBackground")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//        
//        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//        
//        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
//        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
        
        styleSignInVC()
        styleSignUpVC()
    }
    
    
    func styleSignInVC() {
        UIButton.appearance(whenContainedInInstancesOf: [SignInViewController.self]).backgroundColor = mainColor
        UITextField.appearance(whenContainedInInstancesOf: [SignInViewController.self]).backgroundColor = backgroundColor1
        UITextField.appearance(whenContainedInInstancesOf: [SignInViewController.self]).textColor = textColor
    }
    
    func styleSignUpVC() {
        UIButton.appearance(whenContainedInInstancesOf: [SignUpViewController.self]).backgroundColor = mainColor
        UITextField.appearance(whenContainedInInstancesOf: [SignUpViewController.self]).backgroundColor = backgroundColor1
        UITextField.appearance(whenContainedInInstancesOf: [SignUpViewController.self]).textColor = textColor
    }
}

