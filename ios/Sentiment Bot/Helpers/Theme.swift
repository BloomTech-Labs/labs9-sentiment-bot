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
        return Theme(rawValue: storedTheme) ?? .light
    }
    
    var mainColor: UIColor {
        switch self {
        case .dark:
            return UIColor(red: 194/255, green: 10/255, blue: 13/255, alpha:1.0)
        case .light:
            return UIColor(red: 40/255, green: 85/255, blue: 136/255, alpha: 1.0)
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
            return UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
        case .light:
            //Day One Blue
            return UIColor(red: 40/255, green: 85/255, blue: 136/255, alpha: 1.0)
        }
    }
    
    var backgroundColor2: UIColor {
        switch self {
        case .dark:
            //Light Gray
            return UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
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
            return .black //backgroundColor1
        case .light:
            return .black //UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
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
        UISegmentedControl.appearance().tintColor = mainColor
        UISegmentedControl.appearance().backgroundColor = .white
        
        UITabBar.appearance().barTintColor = tabBarColor
        UITabBar.appearance().backgroundColor = tabBarColor
        //UITabBar.appearance().barStyle = barStyle

        //UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().barTintColor = backgroundColor1        

        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = backgroundColor1
        
        UITableViewCell.appearance(whenContainedInInstancesOf: [TimelineViewController.self]).backgroundColor = backgroundColor2
        UITableViewCell.appearance(whenContainedInInstancesOf: [ManagerTimelineViewController.self]).backgroundColor = backgroundColor2
        UITableViewCell.appearance(whenContainedInInstancesOf: [MembersTableViewController.self]).backgroundColor = backgroundColor2
        UITableViewCell.appearance(whenContainedInInstancesOf: [SettingsTableViewController.self]).backgroundColor = backgroundColor2
        UITableViewCell.appearance(whenContainedInInstancesOf: [SendSurveyViewController.self]).backgroundColor = backgroundColor2
        
        
        //UITableViewCell.appearance().backgroundColor = backgroundColor2
        UITableView.appearance().backgroundColor = backgroundColor2
        
        //UILabel.appearance().textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).textColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        UILabel.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).textColor = textColor
       
        UIView.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).backgroundColor = backgroundColor1
        UIView.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).backgroundColor = backgroundColor2
        //UIView.appearance(whenContainedInInstancesOf: [SettingsTableViewController.self]).backgroundColor = backgroundColor2
        
        UIView.appearance(whenContainedInInstancesOf: [JoinCreateViewController.self]).backgroundColor = backgroundColor2
        
        UIButton.appearance().tintColor = textColor
        UIButton.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).tintColor = .white
        UIButton.appearance(whenContainedInInstancesOf: [ManagementViewController.self]).backgroundColor = mainColor
        UIButton.appearance(whenContainedInInstancesOf: [JoinCreateViewController.self]).backgroundColor = mainColor
//        UIButton.appearance(whenContainedInInstancesOf: [SignInUpViewController.self]).backgroundColor = mainColor
        
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
        
//        styleSignInVC()
//        styleSignUpVC()
    }
    
    
//    func styleSignInVC() {
//        UIButton.appearance(whenContainedInInstancesOf: [SignInViewController.self]).backgroundColor = mainColor
//        UITextField.appearance(whenContainedInInstancesOf: [SignInViewController.self]).backgroundColor = .white
//        UITextField.appearance(whenContainedInInstancesOf: [SignInViewController.self]).textColor = .black
//    }
//
//    func styleSignUpVC() {
//        UIButton.appearance(whenContainedInInstancesOf: [SignUpViewController.self]).backgroundColor = mainColor
//        UITextField.appearance(whenContainedInInstancesOf: [SignUpViewController.self]).backgroundColor = .white
//        UITextField.appearance(whenContainedInInstancesOf: [SignUpViewController.self]).textColor = .black
//    }
}

