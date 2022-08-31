//
//  ColorSystem.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 30/08/22.
//

import Foundation
import UIKit

public class M2PColorSystem {
    var background : Background? = nil
    var backgroundLightVarient : BackgroundLightVarient? = nil
    var primaryActive : PrimaryActive? = nil
    var secondaryInactive : SecondaryInactive? = nil
    var linksText : LinksText? = nil
    var borderDefault : BorderDefault? = nil
    var focusedLine : FocusedLine? = nil
    var errorLine : ErrorLine? = nil
    var formDisableFilled : FormDisableFilled? = nil
    var formDisableIcon : FormDisableIcon? = nil
    
    public func M2PConfigureColor(jsonFileName: String = "colors") {
        if let colors = self.getColors(json: jsonFileName) {
            self.background = colors.background
            self.backgroundLightVarient = colors.backgroundLightVarient
            self.primaryActive = colors.primaryActive
            self.secondaryInactive = colors.secondaryInactive
            self.linksText = colors.linksText
            self.borderDefault = colors.borderDefault
            self.focusedLine = colors.focusedLine
            self.errorLine = colors.errorLine
            self.formDisableFilled = colors.formDisableFilled
            self.formDisableIcon = colors.formDisableIcon
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data?, completionHandler: @escaping (ColorsModel?) -> Void ) {
        do {
            guard let jsonData = jsonData else {
                return completionHandler(nil)
            }
            let decodedData = try JSONDecoder().decode(ColorsModel.self,
                                                       from: jsonData)
            completionHandler(decodedData)
        } catch {
            completionHandler(nil)
        }
    }
    
    private func getColors(json: String) -> Results? {
        var colorsList: Results?
        if let mockData = M2PColorSystem().readLocalFile(forName: json) {
            M2PColorSystem().parse(jsonData: mockData) { response in
                print(response?.colors ?? "")
                colorsList = response?.colors
            }
            print("Invalid Json File")
            colorsList = nil
        }
        return colorsList
    }
}

