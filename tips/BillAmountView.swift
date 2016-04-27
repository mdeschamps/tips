//
//  BillAmountView.swift
//  tips
//
//  Created by Manuel Deschamps on 4/25/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

protocol BillAmountViewDelegate: class {
    func onAmountChanged(newBillAmount: String)
    func onAmountStarted()
}

/// UIView to handle keyboard events and to animate new digits added to the Bill.
/// This might be a little bit overkill but I wanted to play more with Animations, Constraints, etc
class BillAmountView: UIView, UIKeyInput, UITextInputTraits {
        
    weak var delegate:BillAmountViewDelegate?
    
    var billAmount: String = ""
    var rightAlignedConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        insertCurrencySymbol()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    // MARK: UITextInputTraits
    var keyboardType: UIKeyboardType = UIKeyboardType.DecimalPad
    
    // MARK: UIKeyInput
    
    func hasText() -> Bool {
        return !billAmount.isEmpty
    }
    
    func insertText(text: String = "") {
        if !hasText() {
            for subview in subviews {
                subview.removeFromSuperview()
            }
            delegate?.onAmountStarted()
        }
        
        let (digit, isDecimalDot, isSymbol) = addDigit(text)
        if digit == nil { return }
        
        let newLabel = TipsLabel(frame: CGRectMake(10, 10, 10, 10))
        newLabel.font = UIFont.systemFontOfSize(50, weight: UIFontWeightUltraLight)
        newLabel.text = digit
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let lastView = subviews.last
        
        addSubview(newLabel)
        
        calculateConstraints(lastView, newLabel: newLabel)
        
        if !isDecimalDot && !isSymbol {
            animateNewDigit(newLabel)
        }
        
        delegate?.onAmountChanged(billAmount)
    }
    
    func deleteBackward() {
        if let rightMostView = subviews.last {
            if billAmount.characters.count != 0 {
                billAmount.removeAtIndex(billAmount.endIndex.predecessor())
            }

            rightMostView.removeFromSuperview()
            
            if let newRightMostView = subviews.last {
                calculateRightAlignmentConstraint(newRightMostView)
            }
        }
        
        delegate?.onAmountChanged(billAmount)
    }
    
    // MARK: i18n
    func currencySymbol() -> String {
        let currentLocale = NSLocale.currentLocale()
        return currentLocale.objectForKey(NSLocaleCurrencySymbol) as! String
    }
    
    func currencySeparator() -> String {
        let currentLocale = NSLocale.currentLocale()
        return currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
    }
    
    // MARK: App states
    
    func restoreValue(value: String) {
        if Double(value) > 0.0 {
            billAmount = ""
            for subview in subviews {
                subview.removeFromSuperview()
            }
            for character in value.characters {
                insertText(String(character))
            }
        }
    }
    
    // MARK: Privates
    
    private func insertCurrencySymbol() {
        let newLabel = TipsLabel(frame: CGRectMake(10, 10, 10, 10))
        newLabel.font = UIFont.systemFontOfSize(50)
        newLabel.text = currencySymbol()
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(newLabel)
        
        calculateRightAlignmentConstraint(newLabel)
    }
    
    private func addDigit(digit: String) -> (String?, Bool, Bool) {
        let isDecimalDot = digit == currencySeparator()
        let isSymbol = !isDecimalDot && Int(digit) == nil
        
        let decimalsArray = billAmount.componentsSeparatedByString(currencySeparator())
        let decimalsTyped = decimalsArray.count == 2 ? decimalsArray.last!.characters.count : 0
        
        if isDecimalDot {
            if decimalsTyped > 0 || decimalsArray.count > 1 {
                return (nil, false, false)
            }
        } else {
            if decimalsTyped >= 2 || billAmount.characters.count > 6 {
                return (nil, false, false)
            }
        }
        
        if isDecimalDot || !isSymbol  {
            billAmount += digit
        }
        
        return (digit, isDecimalDot, isSymbol)
    }
    
    private func calculateConstraints(lastLabel: UIView?, newLabel: UILabel) {
        if lastLabel != nil {
            addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[previous]-(0)-[label]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["previous":lastLabel!, "label": newLabel]))
        }
        calculateRightAlignmentConstraint(newLabel)
        
        let topConstraint = NSLayoutConstraint(item: newLabel, attribute: .Baseline, relatedBy: .Equal, toItem: self, attribute: .Baseline, multiplier: 1, constant: 0)
        addConstraint(topConstraint)
    }
    
    private func calculateRightAlignmentConstraint(newRightMostView: UIView) {
        if rightAlignedConstraint != nil {
            removeConstraint(rightAlignedConstraint)
        }
        
        rightAlignedConstraint = NSLayoutConstraint(item: newRightMostView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        addConstraint(rightAlignedConstraint)
    }
    
    private func animateNewDigit(newLabel: UILabel) {
        // Save the original configuration.
        let initialFrame = newLabel.frame
        
        // Displace the label so it's hidden outside of the screen before animation starts.
        var displacedFrame = initialFrame
        displacedFrame.origin.y = initialFrame.origin.y - 25
        
        newLabel.frame = displacedFrame
        newLabel.alpha = 0.2
        
        // Restore label's initial position during animation.
        UIView.animateWithDuration(0.4, delay: 0, options: [.CurveEaseInOut], animations: {
            newLabel.alpha = 1
            newLabel.frame = initialFrame
        }, completion: nil)
    }
}
