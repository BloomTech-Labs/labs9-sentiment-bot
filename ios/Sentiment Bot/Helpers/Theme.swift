//
//  Theme.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/27/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit

enum Theme: Int {
    case `default`, dark, light

    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }

    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
    var mainColor: UIColor {
        switch self {
        case .default:
            return UIColor(red: 132.0/255.0, green: 13.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 132.0/255.0, green: 13.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        case .light:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .default, .light:
            return .default
        case .dark:
            return .black
        }
    }
    
    var backgroundColor1: UIColor {
        switch self {
        case .default:
            return UIColor(red: 181.0/255.0, green: 228.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        case .light:
            return UIColor.white
        case .dark:
            //Dark Gray
            return UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        }
    }
    
    var backgroundColor2: UIColor {
        switch self {
        case .default:
            return UIColor(red: 136.0/255.0, green: 196.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        case .light:
            return UIColor.white
        case .dark:
            //Light Gray
            return UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        }
    }
    
    var backgroundColor3: UIColor {
        switch self {
        case .default:
            return UIColor(red: 218.0/255.0, green: 206.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        case .light:
            return UIColor.white
        case .dark:
            return UIColor(white: 0.4, alpha: 1.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .default:
            return UIColor.black
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        UIApplication.shared.delegate?.window??.backgroundColor = backgroundColor3
        
        
        UITabBar.appearance().barStyle = barStyle
        
        UITabBar.appearance().backgroundColor = backgroundColor1
        
        UINavigationBar.appearance().barStyle = barStyle
        
        UITableViewCell.appearance().backgroundColor = backgroundColor2
        UITableView.appearance().backgroundColor = backgroundColor2

        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableView.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).textColor = textColor
        
        UIView.appearance(whenContainedInInstancesOf: [ProfileViewController.self]).backgroundColor = backgroundColor2
        
        UIView.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).backgroundColor = backgroundColor1

        
        UIButton.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).tintColor = mainColor
        
        let controlBackground = UIImage(named: "controlBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
        
        
        UIButton.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).backgroundColor = mainColor
        UIButton.appearance().tintColor = textColor
    
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

