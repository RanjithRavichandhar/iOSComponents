//
//  ColorSystemModel.swift
//  iOSComponents
//
//  Created by Ranjith Ravichandran on 30/08/22.
//

import Foundation

struct ColorsModel : Codable {
    let colors : Results?

    enum CodingKeys: String, CodingKey {
        case colors = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        colors = try values.decodeIfPresent(Results.self, forKey: .colors)
    }
}

struct Results : Codable {
    let background : Background?
    let backgroundLightVarient : BackgroundLightVarient?
    let primaryActive : PrimaryActive?
    let secondaryInactive : SecondaryInactive?
    let linksText : LinksText?
    let borderDefault : BorderDefault?
    let focusedLine : FocusedLine?
    let errorLine : ErrorLine?
    let formDisableFilled : FormDisableFilled?
    let formDisableIcon : FormDisableIcon?

    enum CodingKeys: String, CodingKey {
        case background = "background"
        case backgroundLightVarient = "backgroundLightVarient"
        case primaryActive = "primaryActive"
        case secondaryInactive = "secondaryInactive"
        case linksText = "linksText"
        case borderDefault = "borderDefault"
        case focusedLine = "focusedLine"
        case errorLine = "errorLine"
        case formDisableFilled = "formDisableFilled"
        case formDisableIcon = "formDisableIcon"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        background = try values.decodeIfPresent(Background.self, forKey: .background)
        backgroundLightVarient = try values.decodeIfPresent(BackgroundLightVarient.self, forKey: .backgroundLightVarient)
        primaryActive = try values.decodeIfPresent(PrimaryActive.self, forKey: .primaryActive)
        secondaryInactive = try values.decodeIfPresent(SecondaryInactive.self, forKey: .secondaryInactive)
        linksText = try values.decodeIfPresent(LinksText.self, forKey: .linksText)
        borderDefault = try values.decodeIfPresent(BorderDefault.self, forKey: .borderDefault)
        focusedLine = try values.decodeIfPresent(FocusedLine.self, forKey: .focusedLine)
        errorLine = try values.decodeIfPresent(ErrorLine.self, forKey: .errorLine)
        formDisableFilled = try values.decodeIfPresent(FormDisableFilled.self, forKey: .formDisableFilled)
        formDisableIcon = try values.decodeIfPresent(FormDisableIcon.self, forKey: .formDisableIcon)
    }
}

struct Background : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct BackgroundLightVarient : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct BorderDefault : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct ErrorLine : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct FocusedLine : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct FormDisableFilled : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct FormDisableIcon : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct LinksText : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct PrimaryActive : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}

struct SecondaryInactive : Codable {
    let light : String?
    let dark : String?

    enum CodingKeys: String, CodingKey {
        case light = "light"
        case dark = "dark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        light = try values.decodeIfPresent(String.self, forKey: .light)
        dark = try values.decodeIfPresent(String.self, forKey: .dark)
    }
}
