# iOSComponents

[![CI Status](https://img.shields.io/travis/RanjithRavichandhar/iOSComponents.svg?style=flat)](https://travis-ci.org/RanjithRavichandhar/iOSComponents)
[![Version](https://img.shields.io/cocoapods/v/iOSComponents.svg?style=flat)](https://cocoapods.org/pods/iOSComponents)
[![License](https://img.shields.io/cocoapods/l/iOSComponents.svg?style=flat)](https://cocoapods.org/pods/iOSComponents)
[![Platform](https://img.shields.io/cocoapods/p/iOSComponents.svg?style=flat)](https://cocoapods.org/pods/iOSComponents)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

iOSComponents is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'iOSComponents'
```
## Usage
###### M2PBottomNavigation
```js
let tabbarController = M2PBottomNavigation()
let tabBarItems = [M2PTabBarItems(storyboardName: "Main",
controllerName: "blue",
image: "Home_tab",
selectedIimage: "Home_tab_selected",
order: 0,
title: "home"),
M2PTabBarItems(storyboardName: "Main",
controllerName: "blue",
image: "cam",
selectedIimage: "cam_selected",
order: 0,
title: "Test")
]

tabbarController.M2PTintColor = .ImperialRed100
tabbarController.M2PSetUpTabbar(tabBarItems: tabBarItems)

self.navigationController?.pushViewController(tabbarController, animated: true)
```
###### M2PStepper
```js
@IBOutlet weak var checkStepper: M2PStepper!
@IBOutlet weak var checkStepperWithCount: M2PStepper!
checkStepper.M2PSetUpStepper(stepperType: .withoutCount)

checkStepperWithCount.M2PSetUpStepper(stepperType: .withCount, colorSet: M2PStepperColorSetup(stepperBGColor: .backgroundLightVarient, buttonBGColor: .clear, buttonTextColor: .secondaryInactive, selectButtonBGColor: .white, selectButtonTextColor: .secondaryRedColor, countLableBGColor: .background, countLableTextColor: .primaryActive))

checkStepper.M2POnClick = { (isPluseTap, Count) in
self.titleLbl.text = "\(Count)"
}
```
###### M2PToggle
```js
@IBOutlet weak var checkToggelSwitch: UISwitch!
checkToggelSwitch.M2PSetSwitchState(state: .enable, withState: .off)
checkToggelSwitch2.M2PSetSwitchState(state: .disable, withState: .on)
checkToggelSwitch3.M2PSetSwitchState(state: .disable, withState: .off)
checkToggelSwitch.M2POnClick { sender in
if sender.isOn {
print("ON---->>>>")
} else {
print("OFF---->>>>")
}
}
```
###### M2PRadioButton
```js
@IBOutlet weak var radio1: M2PRadioButton!
@IBOutlet weak var radio2: M2PRadioButton!

radio1.M2PSetUpRadioButton(forSelectedImage: M2PRadioButtonProperties(lightModeImage: UIImage(named: "radioSelectLight"), darkModeImage: UIImage(named: "radioSelectDark")), forUnSelectedImage: M2PRadioButtonProperties(lightModeImage: UIImage(named: "radioUnSelect"), darkModeImage: UIImage(named: "radioUnSelect")), initialState: .unSelected)

radio1.M2POnClick = { (sender) in
self.radio1.M2PSetSelected()
self.radio2.M2PSetUnSelected()
self.radio3.M2PSetUnSelected()
self.radio4.M2PSetUnSelected()
self.radio5.M2PSetUnSelected()

radio5.M2PEnableDisableRadioButton(state: .disable, withState: .selected)
}

radio2.M2POnClick = { (sender) in
self.radio1.M2PSetUnSelected()
self.radio2.M2PSetSelected()
self.radio3.M2PSetUnSelected()
self.radio4.M2PSetUnSelected()
self.radio5.M2PSetUnSelected()

}
```
###### M2PCheckBox
```js
@IBOutlet weak var checkBox1: M2PCheckBox!
@IBOutlet weak var checkBox2: M2PCheckBox!

checkBox1.M2PSetUpCheckBox(forSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_fill"), darkModeImage: UIImage(named: "checkboxDark_fill")), forUnSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_unfill"), darkModeImage: UIImage(named: "checkbox_unfill")), initialState: .selected, checkBoxShapes: .box)

checkBox2.M2PSetUpCheckBox(forSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_round_fill"), darkModeImage: UIImage(named: "checkbox_roundDark_fill")), forUnSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_round_unfill"), darkModeImage: UIImage(named: "checkbox_round_unfill")), initialState: .unSelected, checkBoxShapes: .round)


checkBox1.M2POnClick = { (isSelected, sender) in
print(isSelected)
}
checkBox1.M2PEnableDisableCheckBox(state: .enable, withState: .unSelected)
checkBox2.M2PEnableDisableCheckBox(state: .disable, withState: .selected)
```
###### M2PTopNavigation
```js
@IBOutlet weak var topNavigation: M2PTopNavigation!
topNavigation.setTopNavigation(contentType: .withSearchAndAdd, contentProperty: M2PContentProperty(backImage: UIImage(named: "backk"), searchImage: UIImage(named: "searchh"), addImage: UIImage(named: "pluss"), userProfileImage: UIImage(named: "profilee"), userProfileName: "vinoth", title: "Cart", backTitle: "Shop"))
topNavigation.M2PSearchButton.isHidden = true
topNavigation.M2PBackButton.isHidden = true
topNavigation.M2PBackTitleLabel.isHidden = true
topNavigation.M2POnClickProfile = {
print("profile Tapped --->>>")
}
```
###### M2PBottomSheet
```js
**Note:- Root View Controller Must set in app delegate**
**Note:- In storyboard, set this class name to the NavigationController**
let popupNavController = self.storyboard?.instantiateViewController(withIdentifier: "CheckBottomSheetNavigation") as! CheckBottomSheetNavigation
popupNavController.height = 500
popupNavController.topCornerRadius = 35
popupNavController.presentDuration = 0.5
popupNavController.dismissDuration = 0.5
popupNavController.shouldDismissInteractivelty = true
self.navigationController?.present(popupNavController, animated: true, completion: nil)

import UIKit
import iOSComponents

class CheckBottomSheetNavigation: M2PBottomSheetNavigationController {

var height: CGFloat?
var topCornerRadius: CGFloat?
var presentDuration: Double?
var dismissDuration: Double?
var shouldDismissInteractivelty: Bool?

// Bottom popup attribute variables
// You can override the desired variable to change appearance

override var M2PPopupHeight: CGFloat { return height ?? CGFloat(300) }
override var M2PPopupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
override var M2PPopupPresentDuration: Double { return presentDuration ?? 1.0 }
override var M2PPopupDismissDuration: Double { return dismissDuration ?? 1.0 }
override var M2PPopupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
override var M2PPopupDimmingViewAlpha: CGFloat { return M2PBottomPopupConstants.kDimmingViewDefaultAlphaValue }
}
```
## Author

RanjithRavichandhar, ranjith@m2p.in

## License

iOSComponents is available under the MIT license. See the LICENSE file for more info.
