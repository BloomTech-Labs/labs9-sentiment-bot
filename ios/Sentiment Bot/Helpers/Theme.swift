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
//        case .default:
//            return UIColor(red: 132.0/255.0, green: 13.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 132.0/255.0, green: 13.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        case .light:
            return UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
//        case .default:
//            return .default
        case .dark:
            return .black
        case .light:
            return .black

        }
    }
    
    var backgroundColor1: UIColor {
        switch self {
//        case .default:
//            return UIColor(red: 181.0/255.0, green: 228.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        case .dark:
            //Dark Gray
            return UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .light:
            return UIColor(red: 118.0/255.0, green: 214.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    var backgroundColor2: UIColor {
        switch self {
//        case .default:
//            return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        case .dark:
            //Light Gray
            return UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        case .light:
            return UIColor.white
        }
    }
    
    var backgroundColor3: UIColor {
        switch self {
//        case .default:
//            return UIColor(red: 218.0/255.0, green: 206.0/255.0, blue: 199.0/255.0, alpha: 1.0)
        case .dark:
            return UIColor(white: 0.4, alpha: 1.0)
        case .light:
            return UIColor.white
        }
    }
    
    var textColor: UIColor {
        switch self {
//        case .default:
//            return UIColor.black
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
        
        //UIApplication.shared.delegate?.window??.backgroundColor = mainColor
        
        UITabBar.appearance().backgroundColor = backgroundColor1
        UITabBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().barStyle = barStyle
        
        UITableViewCell.appearance().backgroundColor = backgroundColor2
        UITableView.appearance().backgroundColor = backgroundColor2
        

        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).textColor = textColor
        
        UILabel.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).textColor = textColor
        UILabel.appearance().textColor = textColor
        //UILabel.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).textColor = .white
        UIView.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).backgroundColor = backgroundColor1

        
        UIButton.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).tintColor = .white
        
        let controlBackground = UIImage(named: "controlBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
        
        
        UIButton.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).backgroundColor = mainColor
        UIButton.appearance(whenContainedInInstancesOf: [ProfileViewController.self]).backgroundColor = mainColor
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

