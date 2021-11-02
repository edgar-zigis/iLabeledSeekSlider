# iLabeledSeekSlider


Custom & highly configurable seek slider with sliding intervals, disabled state and every possible setting to tackle!
##### Minimum iOS version 9.0

![alt text](https://github.com/edgar-zigis/LabeledSeekSlider/blob/master/sample-slide.gif?raw=true)

### Carthage

```
github "edgar-zigis/iLabeledSeekSlider" ~> 1.0.0
```
### Cocoapods

```
pod 'iLabeledSeekSlider', '~> 1.0.0'
```
### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/edgar-zigis/iLabeledSeekSlider.git", .upToNextMajor(from: "1.0.0"))
]
```
### Usage
``` swift
let slider = iLabeledSeekSlider()
slider.title = "Amount"
slider.unit = "€"
slider.unitPosition = .back
slider.limitValueIndicator = "Max"
slider.minValue = 100
slider.maxValue = 1000
slider.defaultValue = 550
slider.limitValue = 850
slider.slidingInterval = 50
slider.valuesToSkip = [300, 350]
slider.trackHeight = 4
slider.activeTrackColor = UIColor(red: 1.0, green: 0.14, blue: 0.0, alpha: 1.0)
slider.inactiveTrackColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
slider.thumbSliderRadius = 12
slider.thumbSliderBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
slider.rangeValueTextFont = UIFont.systemFont(ofSize: 12)
slider.rangeValueTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
slider.titleTextFont = UIFont.systemFont(ofSize: 12)
slider.titleTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0)
slider.bubbleStrokeWidth = 2
slider.bubbleCornerRadius = 5
slider.bubbleValueTextFont = UIFont.boldSystemFont(ofSize: 12)
slider.bubbleOutlineColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
slider.bubbleValueTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
slider.vibrateOnLimitReached = true
slider.allowLimitValueBypass = false
slider.isDisabled = false
```
### Remarks
It can be used both programmatically and with storyboards. Samples are available at **iLabeledSeekSliderTest**
