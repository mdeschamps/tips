//
//  TipsLabel.swift
//  tips
//
//  Created by Manuel Deschamps on 4/26/16.
//  Copyright © 2016 deschamps. All rights reserved.
//

import UIKit

/// Proxy classes to apply Appearance

class TipsLabel : UILabel {
    dynamic var textTintColor: UIColor! {
        get { return self.textColor }
        set { self.textColor = newValue }
    }
}

class SecundaryTipsLabel : TipsLabel { } 