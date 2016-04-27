//
//  ViewController.swift
//  tips
//
//  Created by Manuel Deschamps on 4/21/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BillAmountViewDelegate, SettingsViewControllerDelegate {
    
    @IBOutlet weak var billAmountView: BillAmountView!
    @IBOutlet weak var labelsContainer: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentage: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // App State notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.restoreState), name: "tipsAppWillEnterForeground", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.saveState), name: "tipsAppDidEnterBackground", object: nil)
        
        ThemeManager.applyTheme()
        
        billAmountView.delegate = self
        billAmountView.translatesAutoresizingMaskIntoConstraints = false
        billAmountView.becomeFirstResponder()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let defaultTip = defaults.integerForKey(SettingsViewController.DefaultTipPercentageKey)
        onDefaultTipChange(TipsPercentage(rawValue: defaultTip))
    }
    
    private var token: dispatch_once_t = 0
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_once(&token) { () -> Void in
            self.hideControls()
        }
    }

    // MARK: App State
    func restoreState() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let restoredAmount = defaults.stringForKey("bill_amount")
        if !(restoredAmount?.isEmpty)!  {
            billAmountView.restoreValue(restoredAmount!)
        }
    }
    
    func saveState() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(billAmountView.billAmount, forKey: "bill_amount")
        defaults.synchronize()
    }
    
    // MARK: IB Action handlers
    @IBAction func onTipChanged(sender: AnyObject) {
        onAmountChanged(billAmountView.billAmount)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        if billAmountView.isFirstResponder() {
            billAmountView.endEditing(true)
        } else {
            billAmountView.becomeFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      showControls()
        
      let settingsVC = segue.destinationViewController as! SettingsViewController
      settingsVC.delegate = self
    }
    
    // MARK: Toggle UI Components with animation
    
    func hideControls(animated: Bool = true) {
        labelsContainer.alpha = 0.0
        tipPercentage.alpha = 0.0
        
        let displacedOrigin = billAmountView.frame.origin.y + 200
        if animated {
            UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseIn], animations: {
                self.billAmountView.frame.origin.y = displacedOrigin
                }, completion: nil)
        } else {
            self.billAmountView.frame.origin.y = displacedOrigin
        }
    }
    
    func showControls() {
        // Restore label's initial position during animation.
        UIView.animateWithDuration(0.4, delay: 0, options: [.CurveEaseIn], animations: {
            self.billAmountView.frame.origin.y -= 200
        }, completion: nil)
        
        UIView.animateWithDuration(0.2, delay: 0.2, options: [.CurveEaseIn], animations: {
            self.labelsContainer.alpha = 1.0
            self.tipPercentage.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK: BillAmountViewDelegate
    
    func onAmountStarted() {
        showControls()
    }
    
    func onAmountChanged(newBillAmount: String) {        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        
        let tipPercentageChosen = TipsPercentage(rawValue: tipPercentage.selectedSegmentIndex)?.percentage
        
        let newBillAmountOrZero = newBillAmount.isEmpty ? "0" : newBillAmount
        let billAmount = formatter.numberFromString(newBillAmountOrZero)?.doubleValue
        
        let tip = billAmount! * tipPercentageChosen!
        let total = billAmount! + tip
        
        formatter.numberStyle = .CurrencyStyle
        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
    }
    
    // MARK: SettingsViewControllerDelegate

    func onDefaultTipChange(newTip: TipsPercentage?) {
        tipPercentage.selectedSegmentIndex = newTip!.rawValue
    
        onAmountChanged(billAmountView.billAmount)
    }
}

