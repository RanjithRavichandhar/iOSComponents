//
//  ToggleExtension.swift
//  iOSComponents
//
//  Created by SENTHIL KUMAR on 06/09/22.
//

// MARK: Implementation

/* checkToggelSwitch.M2PSetSwitchState(state: .enable, withState: .off)
checkToggelSwitch2.M2PSetSwitchState(state: .disable, withState: .on)
checkToggelSwitch3.M2PSetSwitchState(state: .disable, withState: .off)
checkToggelSwitch.M2POnClick { sender in
    if sender.isOn {
        print("ON---->>>>")
    } else {
        print("OFF---->>>>")
    }
} */

import Foundation
import UIKit

extension UISwitch {
    
    public enum M2PSwitchState {
        case enable, disable
        public enum M2PWithState {
            case on, off
        }
    }
    
    public func M2PSetSwitchState(state: M2PSwitchState, withState: M2PSwitchState.M2PWithState) {
        self.isOn = withState == .on ? true : false
        self.isEnabled = state == .enable ? true : false
    }
}

extension UIControl {
    
    public func M2POnClick(for controlEvents: UIControl.Event = .valueChanged, _ closure: @escaping(UISwitch)->()) {
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

