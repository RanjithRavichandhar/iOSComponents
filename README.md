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

# M2PBottomNavigation

- You have to initialize the Tabbar `M2PBottomNavigation()` like shown in the code.
```js
let tabbarController = M2PBottomNavigation()
```
- Here, `M2PSetUpTabbar` is the function used to setUp the tabbar properties by passing the arguments `M2PTabBarItems` as Array.

- `M2PTabBarItems` is contains `storyboardName` `controllerName` `image` `selectedImage` `order` `title`

```js
let tabBarItems = [M2PTabBarItems(storyboardName: "Main",
controllerName: "HomeViewController",
image: "Home_tab",
selectedImage: "Home_tab_selected",
order: 0,
title: "home"),
M2PTabBarItems(storyboardName: "Main",
controllerName: "CamViewController",
image: "cam",
selectedImage: "cam_selected",
order: 1,
title: "Test")
]
```
```js
tabbarController.M2PSetUpTabbar(tabBarItems: tabBarItems)
```
- `M2PTintColor` is used to set a color for Tabbar Icon. The `Light Mode` and `Dark Mode` is handle by this `M2PTintColor`.
```js
tabbarController.M2PTintColor = .ImperialRed100
```
Finally, By using `navigationController` push or present the Tabbar
```js
self.navigationController?.pushViewController(tabbarController, animated: true)
```
# M2PStepper

- Design a `uiView` in storyboard and mention the class name as `M2PStepper`
- Take a `@IBOutlet` for the view.
```js
@IBOutlet weak var checkStepper: M2PStepper!
@IBOutlet weak var checkStepperWithCount: M2PStepper!
```
- You can Customize the view `WithCountLabel` or `WithoutCountLabel` using `M2PSetUpStepper` function. And also `Text` and `Background` color
```js
checkStepper.M2PSetUpStepper(stepperType: .withCount)
checkStepper2.M2PSetUpStepper(stepperType: .withoutCount)
```
```js
checkStepperWithCount.M2PSetUpStepper(stepperType: .withCount, colorSet: M2PStepperColorSetup(stepperBGColor: .backgroundLightVarient, buttonBGColor: .clear, buttonTextColor: .secondaryInactive, selectButtonBGColor: .white, selectButtonTextColor: .secondaryRedColor, countLableBGColor: .background, countLableTextColor: .primaryActive))
```
- `M2POnClick` closure is used for call back functionality for click action. 
```js
public var onClick:((Bool, Int) -> Void)? // pluse(+) = true, Mynus(-) = false
```
- In this call back we can get `Count` and `isPluseTap` is used to identify which icon pressed eg. `+` or `-`.
```js
checkStepper.M2POnClick = { (isPluseTap, Count) in
self.titleLbl.text = "\(Count)"
}
```
# M2PToggle

- Design a `UISwitch` in storyboard and mention the class name as `M2PToggle`
- Take a `@IBOutlet` for the view.
```js
@IBOutlet weak var checkToggelSwitch: UISwitch!
```
- By using `M2PSetSwitchState` function, you can control the `Enable` and `Disable` State also with `ON` and `OFF` state.
```js
public func setSwitchState(state: SwitchState, withState: SwitchState.WithState)
```
- Example:-
```js
checkToggelSwitch.M2PSetSwitchState(state: .enable, withState: .off)
checkToggelSwitch2.M2PSetSwitchState(state: .disable, withState: .on)
checkToggelSwitch3.M2PSetSwitchState(state: .disable, withState: .off)
```
- `M2POnClick` closure is used for call back functionality for click action.
```js
checkToggelSwitch.M2POnClick { sender in
if sender.isOn {
print("ON---->>>>")
} else {
print("OFF---->>>>")
}
}
```
# M2PRadioButton

- Design a `uiView` in storyboard and mention the class name as `M2PRadioButton`
- Take a `@IBOutlet` for the view.
```js
@IBOutlet weak var radio1: M2PRadioButton!
@IBOutlet weak var radio2: M2PRadioButton!
```
- You can Customize the `Selected` and `Unselected` Image with `Dark mode` and `Light mode` using `M2PSetUpRadioButton` function. And also set `InitialState` for the Radio Button.
```js
radio1.M2PSetUpRadioButton(forSelectedImage: M2PRadioButtonProperties(lightModeImage: UIImage(named: "radioSelectLight"), darkModeImage: UIImage(named: "radioSelectDark")), forUnSelectedImage: M2PRadioButtonProperties(lightModeImage: UIImage(named: "radioUnSelect"), darkModeImage: UIImage(named: "radioUnSelect")), initialState: .unSelected)
```
- Here `M2PSetSelected()` and `M2PSetUnSelected()` is used to change the selection state of Radio Button
```js
public func setUnSelected()
public func setSelected()
```
- Example:-
```js
self.radio1.M2PSetSelected()
self.radio2.M2PSetUnSelected()
```
- `M2PEnableDisableRadioButton` function is used to `Enable` and `Disable` the radio button with specific state like `Selected` and `Unselected` State
```js
public func M2PEnableDisableRadioButton(state: RadioButtonState = .enable, withState: RadioButtonState.WithState = .selected)
```
- Example:-
```js
radio5.M2PEnableDisableRadioButton(state: .disable, withState: .selected)
```
- `M2POnClick` closure is used for call back functionality for click action. 
```js
public var onClick:((UITapGestureRecognizer) -> Void)?
```
- In this call back we can get all the functionality of `UITapGestureRecognizer`, And you can perform the `Selection` and `Unselection` logic.
- Example:-
```js
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
# M2PCheckBox

- Design a `uiView` in storyboard and mention the class name as `M2PCheckBox`
- Take a `@IBOutlet` for the view.
```js
@IBOutlet weak var checkBox1: M2PCheckBox!
@IBOutlet weak var checkBox2: M2PCheckBox!
```
- You can Customize the `Selected` and `Unselected` Image using `M2PSetUpCheckBox` function. And also set `InitialState` and `Shapes` for the Check Box.

```js
checkBox1.M2PSetUpCheckBox(forSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_fill"), darkModeImage: UIImage(named: "checkboxDark_fill")), forUnSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_unfill"), darkModeImage: UIImage(named: "checkbox_unfill")), initialState: .selected, checkBoxShapes: .box)

checkBox2.M2PSetUpCheckBox(forSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_round_fill"), darkModeImage: UIImage(named: "checkbox_roundDark_fill")), forUnSelectedImage: M2PCheckBoxProperties(lightModeImage: UIImage(named: "checkbox_round_unfill"), darkModeImage: UIImage(named: "checkbox_round_unfill")), initialState: .unSelected, checkBoxShapes: .round)
```
- `M2PCheckBoxShapes` is a enum type variable that contains `.box` and `.round` which specify the shape of the checkBox.
```js
checkBox1.M2PCheckBoxShapes = .round
checkBox2.M2PCheckBoxShapes = .box
```
- `M2PEnableDisableCheckBox` function is used to `Enable` and `Disable` the check box with specific state like `Selected` and `Unselected` State
- If you want to set selected state initially, you use this function.
```js
public func M2PEnableDisableCheckBox(state: CheckBoxState = .enable, withState: CheckBoxState.WithState = .selected)
```
- Example:-
```js
checkBox1.M2PEnableDisableCheckBox(state: .enable, withState: .unSelected)
checkBox2.M2PEnableDisableCheckBox(state: .disable, withState: .selected)
```
- `M2POnClick` closure is used for call back functionality for click action. Here `Bool` is used to get `Select` and `Unselect` state. 
- In this call back we can get all the functionality of `UITapGestureRecognizer`
```js
public var M2POnClick:((Bool, UITapGestureRecognizer) -> Void)?
```
- Example:-
```js
checkBox1.M2POnClick = { (isSelected, sender) in
print(isSelected)
}
```
# M2PTopNavigation
- Design a `uiView` in storyboard and mention the class name as `M2PTopNavigation`
- Take a `@IBOutlet` for the view.
```js
@IBOutlet weak var topNavigation: M2PTopNavigation!
```
- `M2PSetTopNavigation` using this function, you can modify the `Image` and `Title` for the view, And also you can set the view like `.withSearchAndAdd` and `.withProfile`.
```js
topNavigation.M2PSetTopNavigation(contentType: .withSearchAndAdd, contentProperty: M2PContentProperty(backImage: UIImage(named: "backk"), searchImage: UIImage(named: "searchh"), addImage: UIImage(named: "pluss"), userProfileImage: UIImage(named: "profilee"), userProfileName: "vinoth", title: "Cart", backTitle: "Shop"))
```
- You can easy Hide and Unhide the properties present in the view.
```js
topNavigation.M2PSearchButton.isHidden = true
topNavigation.M2PBackButton.isHidden = true
topNavigation.M2PBackTitleLabel.isHidden = true
```
-`M2POnClickBack` `M2POnClickSearch` `M2POnClickAdd` `M2POnClickProfile` are the closure is used for call back functionality for click action.
```js
public var M2POnClickBack:(() -> Void)?
public var M2POnClickSearch:(() -> Void)?
public var M2POnClickAdd:(() -> Void)?
public var M2POnClickProfile:(() -> Void)?
```
- Example:-
```js
topNavigation.M2POnClickProfile = {
print("profile Tapped --->>>")
}
topNavigation.M2POnClickSearch = {
}
topNavigation.M2POnClickBack = {
}
```
# M2PBottomSheet

**Note:- Root View Controller Must set in app delegate.**

**Note:- In storyboard, set this class name to the NavigationController.**

- Here you can Override the method to modify or customise the Bottom Sheet. Like `Height` `Top Corner Radius` `Present Duration` `Dismiss Duration` of the sheet.

```js
import UIKit
import iOSComponents

class CheckBottomSheetNavigation: M2PBottomSheetNavigationController {

var height: CGFloat?
var topCornerRadius: CGFloat?
var presentDuration: Double?
var dismissDuration: Double?
var shouldBeganDismiss: Bool?
var shouldDismissInteractivelty: Bool?

// Bottom popup attribute variables
// You can override the desired variable to change appearance

override var M2PPopupHeight: CGFloat { return height ?? CGFloat(300) }
override var M2PPopupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
override var M2PPopupPresentDuration: Double { return presentDuration ?? 1.0 }
override var M2PPopupDismissDuration: Double { return dismissDuration ?? 1.0 }
override var M2PPopupShouldBeganDismiss: Bool { return shouldBeganDismiss ?? true }
override var M2PPopupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
override var M2PPopupDimmingViewAlpha: CGFloat { return M2PBottomPopupConstants.kDimmingViewDefaultAlphaValue }
}
```
- ##### Usage:- 
```js
let popupNavController = self.storyboard?.instantiateViewController(withIdentifier: "CheckBottomSheetNavigation") as! CheckBottomSheetNavigation
popupNavController.height = 500
popupNavController.topCornerRadius = 35
popupNavController.presentDuration = 0.5
popupNavController.dismissDuration = 0.5
popupNavController.shouldDismissInteractivelty = true
self.navigationController?.present(popupNavController, animated: true, completion: nil)
```
## Author

RanjithRavichandhar, ranjith@m2p.in

## License

iOSComponents is available under the MIT license. See the LICENSE file for more info.
