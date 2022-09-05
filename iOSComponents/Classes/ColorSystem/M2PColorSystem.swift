//
//  ColorSystem.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 30/08/22.
//

import Foundation
import UIKit

public class M2PColorSystem {
    
    static let shared = M2PColorSystem()
    public init() {}

    public var colorsList: [String: Any]? = [:]
    
    public func M2PConfigureColor(jsonFileName: String? = nil) {
        if let jsonFileName = jsonFileName {
            FetchComponentColor.shared.getColors(json: jsonFileName, pathFromMain: true) { colorResult in
                if let colors = colorResult {
                    self.colorsList = colors
                    M2PColorSystem.shared.colorsList = colors
                }
            }
        } else {
            FetchComponentColor.shared.M2PFetchComponentColor()
            self.colorsList = FetchComponentColor.shared.colorsList
        }
    }
}

public class FetchComponentColor {
    static let shared = FetchComponentColor()
    private init() {}
    public var colorsList: [String: Any]? = [:]

    func M2PFetchComponentColor(jsonFileName: String = "M2PColors") {
        self.getColors(json: jsonFileName,completionHandler: { colorResult in
            if let colors = colorResult {
                self.colorsList = colors
                M2PColorSystem.shared.colorsList = colors
            }
        })
    }
    
    private func readLocalFile(forName name: String, fromMain: Bool = false) -> Data? {
        do {
            if fromMain {
                if let bundlePath = Bundle.main.path(forResource: name,ofType: "json"),
                   let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    return jsonData
                }
            } else {
                if let bundlePath = M2PComponentsBundle.shared.currentBundle.path(forResource: "M2PColors",ofType: "json"),
                   let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                    return jsonData
                }
            }
            
        } catch {
            print("No File Found")
        }
        print("No M2PColors Json File Found")
        return nil
    }
    
    func parse(jsonData: Data?, completionHandler: @escaping ([String: Any]?) -> Void ) {
        do {
            guard let jsonData = jsonData else {
                return completionHandler(nil)
            }
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                completionHandler(json)
            }
        } catch {
            completionHandler(nil)
        }
    }
    
    func getColors(json: String, pathFromMain: Bool = false, completionHandler: @escaping ([String: Any]?) -> Void ) {
        if let mockData = FetchComponentColor().readLocalFile(forName: json, fromMain: pathFromMain) {
            FetchComponentColor().parse(jsonData: mockData) { response in
                completionHandler(response?["results"] as? [String: Any])
            }
        }
    }
}
