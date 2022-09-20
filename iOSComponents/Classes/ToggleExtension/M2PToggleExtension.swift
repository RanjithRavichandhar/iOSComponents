//
//  ToggleExtension.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 06/09/22.
//

// MARK: Implementation

/* checkToggelSwitch.setSwitchState(state: .enable, withState: .off)
checkToggelSwitch2.setSwitchState(state: .disable, withState: .on)
checkToggelSwitch3.setSwitchState(state: .disable, withState: .off)
checkToggelSwitch.onClick { sender in
    if sender.isOn {
        print("ON---->>>>")
    } else {
        print("OFF---->>>>")
    }
} */

import Foundation
import UIKit

public enum SwitchState {
    case enable, disable
    public enum WithState {
        case on, off
    }
}

extension UISwitch {
    
    public func setSwitchState(state: SwitchState, withState: SwitchState.WithState) {
        self.isOn = withState == .on ? true : false
        self.isEnabled = state == .enable ? true : false
    }
}

extension UIControl {
    
    public func onClick(for controlEvents: UIControl.Event = .valueChanged, _ closure: @escaping(UISwitch)->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:(UISwitch)->()
            init(_ closure: @escaping(UISwitch)->()) { self.closure = closure }
            @objc func invoke(_ sender: UISwitch) { closure(sender) }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke(_:)), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

