//
//  SettingsViewController.swift
//  tips
//
//  Created by Manuel Deschamps on 4/26/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

enum TipsPercentage: Int {
    case p18 = 0, p20, p22
    
    var percentage: Double {
        switch self {
        case .p18:
            return 0.18
        case .p20:
            return 0.20
        case .p22:
            return 0.22
        }
    }
}

protocol SettingsViewControllerDelegate: class {
    func onDefaultTipChange(newTip: TipsPercentage?)
}

class SettingsViewController : UIViewController {
    
    static let DefaultTipPercentageKey = "default_tip_percentage"
    static let DefaultThemeKey = "default_theme"
    
    weak var delegate:SettingsViewControllerDelegate?
    
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var themeControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let defaultTip = defaults.integerForKey(SettingsViewController.DefaultTipPercentageKey)
        defaultTipControl.selectedSegmentIndex = defaultTip ?? 0
        
        themeControl.selectedSegmentIndex = SettingsViewController.currentTheme().rawValue
    }
    
    static func currentTheme() -> TipsTheme {
        if let storedTheme = NSUserDefaults.standardUserDefaults().valueForKey(DefaultThemeKey)?.integerValue {
            return TipsTheme(rawValue: storedTheme)!
        } else {
            return .Light
        }
    }
    
    @IBAction func onDefaultTipChange(sender: AnyObject) {
        let tipPercentage = TipsPercentage(rawValue:defaultTipControl.selectedSegmentIndex)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger((tipPercentage?.rawValue)!, forKey: SettingsViewController.DefaultTipPercentageKey)
        defaults.synchronize()
        
        delegate?.onDefaultTipChange(tipPercentage)
    }
    
    @IBAction func onThemeChange(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(themeControl.selectedSegmentIndex, forKey: SettingsViewController.DefaultThemeKey)
        defaults.synchronize()
        
        ThemeManager.applyTheme()
    }
}
