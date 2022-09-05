//
//  UIColor+Extension.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 29/08/22.
//

import Foundation
import UIKit

extension UIColor {
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["background"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["background"] as? [String:Any])?["dark"] as? String ?? ""))
    public static var background: UIColor
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["backgroundLightVarient"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["backgroundLightVarient"] as? [String:Any])?["light"] as? String ?? ""))
    public static var backgroundLightVarient: UIColor
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["primaryActive"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["primaryActive"] as? [String:Any])?["light"] as? String ?? ""))
    public static var primaryActive: UIColor

    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["secondaryInactive"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["secondaryInactive"] as? [String:Any])?["light"] as? String ?? ""))
    public static var secondaryInactive: UIColor
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["linksText"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["linksText"] as? [String:Any])?["light"] as? String ?? ""))
    public static var linksText: UIColor
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["borderDefault"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["borderDefault"] as? [String:Any])?["light"] as? String ?? ""))
    public static var borderDefault: UIColor
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["focusedLine"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["focusedLine"] as? [String:Any])?["light"] as? String ?? ""))
    public static var focusedLine: UIColor
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["errorLine"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["errorLine"] as? [String:Any])?["light"] as? String ?? ""))
    public static var errorLine: UIColor
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["formDisableFilled"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["formDisableFilled"] as? [String:Any])?["light"] as? String ?? ""))
    public static var formDisableFilled: UIColor
    
    @M2PTheme(light: UIColor(hex: (M2PColorSystem.shared.colorsList?["formDisableIcon"] as? [String:Any])?["light"] as? String ?? ""),
           dark: UIColor(hex: (M2PColorSystem.shared.colorsList?["formDisableIcon"] as? [String:Any])?["light"] as? String ?? ""))
    public static var formDisableIcon: UIColor
}

extension UIColor {
    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    public convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        if hex.count < 3 {
            hex = "\(hex)\(hex)\(hex)"
        }

        if hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil {
            if hex.count == 3 {
                let startIndex = hex.index(hex.startIndex, offsetBy: 1)
                let endIndex = hex.index(hex.startIndex, offsetBy: 2)

                let redHex = String(hex[..<startIndex])
                let greenHex = String(hex[startIndex ..< endIndex])
                let blueHex = String(hex[endIndex...])

                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }

            let startIndex = hex.index(hex.startIndex, offsetBy: 2)
            let endIndex = hex.index(hex.startIndex, offsetBy: 4)
            let redHex = String(hex[..<startIndex])
            let greenHex = String(hex[startIndex ..< endIndex])
            let blueHex = String(hex[endIndex...])

            var redInt: CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt: CUnsignedInt = 0

            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)

            self.init(red: CGFloat(redInt) / 255.0,
                      green: CGFloat(greenInt) / 255.0,
                      blue: CGFloat(blueInt) / 255.0,
                      alpha: CGFloat(alpha))
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }

    public var hexValue: String {
        var color = self

        if color.cgColor.numberOfComponents < 4 {
            let c = color.cgColor.components!
            color = UIColor(red: c[0], green: c[0], blue: c[0], alpha: c[1])
        }
        if color.cgColor.colorSpace!.model != .rgb {
            return "#FFFFFF"
        }
        let c = color.cgColor.components!
        return String(format: "#%02X%02X%02X", Int(c[0] * 255.0), Int(c[1] * 255.0), Int(c[2] * 255.0))
    }
}
