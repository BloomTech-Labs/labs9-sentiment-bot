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
            return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
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
    
    var backgroundColor: UIColor {
        switch self {
        case .default:
            return UIColor.white
        case .light:
            return UIColor.white
        case .dark:
            return UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .default, .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        
        UITabBar.appearance().barStyle = barStyle
        
        UITableViewCell.appearance().backgroundColor = backgroundColor
        UITableView.appearance().backgroundColor = backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
        
//        UIView.appearance(whenContainedInInstancesOf: [SegmentedControlViewController.self, SignInViewController.self, SignUpViewController.self]).backgroundColor = UIColor.clear.withAlphaComponent(0.25)
//
        UIView.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).backgroundColor = backgroundColor
        
        UIButton.appearance(whenContainedInInstancesOf: [UserContainerViewController.self]).tintColor = mainColor
        UIButton.appearance().backgroundColor = backgroundColor
        UIButton.appearance().tintColor = textColor

    }
}

