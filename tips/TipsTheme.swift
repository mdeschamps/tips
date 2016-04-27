//
//  TipsTheme.swift
//  tips
//
//  Created by Manuel Deschamps on 4/26/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

enum TipsTheme: Int {
    case Light = 0, Dark
    
    var airColor: UIColor {
        return UIColor(red: 241.0/255.0, green: 102.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    }
    
    var tintColor: UIColor {
        switch self {
        case .Light:
            return airColor
        case .Dark:
            return UIColor.whiteColor()
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Light:
            return UIColor.whiteColor()
        case .Dark:
            return airColor
        }
    }
    
    var secondaryTintColor: UIColor {
        return backgroundColor
    }
    
    var secondaryBackgroundColor: UIColor {
        return tintColor
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .Light:
            return .Default
        case .Dark:
            return .Black
        }
    }
}

struct ThemeManager {
    
    static func applyTheme(theme: TipsTheme = SettingsViewController.currentTheme()) {
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().backgroundColor = theme.backgroundColor
        UINavigationBar.appearance().tintColor = theme.tintColor
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: theme.tintColor], forState: UIControlState.Normal)
        
        TipsView.appearance().backgroundColor = theme.backgroundColor
        TipsView.appearance().tintColor = theme.tintColor
        SecondaryTipsView.appearance().backgroundColor = theme.tintColor
        SecondaryTipsView.appearance().tintColor = theme.backgroundColor
        
        UISegmentedControl.appearance().backgroundColor = theme.backgroundColor
        UISegmentedControl.appearance().tintColor = theme.tintColor
        
        TipsLabel.appearance().textTintColor = theme.tintColor
        SecundaryTipsLabel.appearance().textTintColor = theme.secondaryTintColor
        
        let sharedApplication = UIApplication.sharedApplication()
        let windows = sharedApplication.windows
        for window in windows {
            //window.tintColor = theme.tintColor
            //window.backgroundColor = theme.backgroundColor
            
            for subview in window.subviews {
                subview.removeFromSuperview()
                window.addSubview(subview)
            }
        }
    }
}
