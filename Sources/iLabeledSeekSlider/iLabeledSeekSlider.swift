//
//  iLabeledSeekSlider.swift
//  iLabeledSeekSlider
//
//  Created by Edgar Žigis on 2021-10-20.
//  Copyright © 2021 Edgar Žigis. All rights reserved.
//

import UIKit

class iLabeledSeekSlider: UIView {
    
    //  MARK: - Open variables -
    
    /**
     *  Lower range value also displayed in the left corner
     */
    open var minValue: Int = 0 {
        didSet {
            if oldValue != minValue {
                actualXPosition = nil
            }
            if actualFractionalValue < minValue {
                actualFractionalValue = minValue
            }
            setNeedsDisplay()
        }
    }
    /**
     *  Upper range value also displayed in the right corner
     */
    open var maxValue: Int = 100 {
        didSet {
            if oldValue != maxValue {
                actualXPosition = nil
            }
            if actualFractionalValue > maxValue {
                actualFractionalValue = maxValue
            }
            setNeedsDisplay()
        }
    }
    /**
     *  Default value which will be displayed during the initial draw
     */
    open var defaultValue: Int {
        set {
            if _defaultValue != newValue || _defaultValue != getDisplayValue() {
                actualXPosition = nil
            }
            let newValue = min(maxValue, max(minValue, newValue))
            _defaultValue = newValue
            actualFractionalValue = newValue
            setNeedsDisplay()
        }
        get {
            return self._defaultValue
        }
    }
    /**
     *  Max sliding value, must be larger than @param minValue and smaller than @param maxValue
     *  Won't be applicable if null
    */
    open var limitValue: Int? = nil {
        didSet {
            if oldValue != limitValue {
                actualXPosition = nil
            }
            if let limitValue = limitValue {
                if actualFractionalValue > limitValue {
                    actualFractionalValue = limitValue
                }
            }
            setNeedsDisplay()
        }
    }
    /**
     *  Text label which indicates that the @param limitValue is reached
    */
    open var limitValueIndicator: String = "Max" {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Allows sliding past @param limitValue if needed
    */
    open var allowLimitValueBypass: Bool = false
    /**
     *  Toggles vibration after @param limitValue is reached
    */
    open var vibrateOnLimitReached: Bool = true
    /**
     *  Slider title label value
    */
    open var title: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Slider unit label value
     *  Will be set near the @param minValue and @param maxValue
    */
    open var unit: String = "" {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Slider unit label position
     *  Can be placed in front or back
    */
    open var unitPosition = UnitPosition.back {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Will disable user interaction and grayscale whole view
    */
    open var isDisabled: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Already filled track color
    */
    open var activeTrackColor = UIColor(red: 1.0, green: 0.14, blue: 0.0, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Yet not filled track color
     */
    open var inactiveTrackColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Thumb slider background color
    */
    open var thumbSliderBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Font for UITextViews containing @param minValue and @param maValue
    */
    open var rangeValueTextFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Text color for UITextViews containing @param minValue and @param maValue
    */
    open var rangeValueTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Font for UITextView containing @param title
    */
    open var titleTextFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Text color for UITextView containing @param title
    */
    open var titleTextColor = UIColor(red: 0.62, green: 0.65, blue: 0.68, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Current value bubble outline color
    */
    open var bubbleOutlineColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Current value bubble text font
    */
    open var bubbleValueTextFont = UIFont.boldSystemFont(ofSize: 12) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Current value bubble text color
    */
    open var bubbleValueTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     *  Values which will be "jumped" through and not emitted
     *  As well as not displayed in the UI.
     *  For example if min is 1, max is 5 and valuesToSkip has 3 and 4
     *  Only 1, 2 and 5 will be displayed and emitted to the user.
    */
    open var valuesToSkip: Array<Int> = []
    /**
     *  Sliding interval value.
     *  For example if set to 50, sliding values will be 0, 50, 100 etc.
    */
    open var slidingInterval: Int = 1
    /**
     *  Callback reporting changed values upstream
    */
    open var onValueChanged: (Int)->() = { value in }
    /**
     *  Read-only parameter for fetching current slider value
    */
    open private(set) var currentValue: Int = 50
    
    //  MARK: - Private variables -
    
    private var _defaultValue: Int = 50
    
    private var actualFractionalValue: Int = 50
    private var actualXPosition: CGFloat? = nil
    
    private let topPadding: CGFloat = 2
    private let sidePadding: CGFloat = 16
    private let bubbleHeight: CGFloat = 26
    private let minimumBubbleWidth: CGFloat = 84
    private let bubbleTextPadding: CGFloat = 16

    private let trackHeight: CGFloat = 4
    private let thumbSliderRadius: CGFloat = 12
    
    //  MARK: - UI methods -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawInactiveTrack(in: rect)
    }
    
    private func drawInactiveTrack(in rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()

        let rectangle = CGRect(x: sidePadding, y: 0, width: rect.width - sidePadding * 2, height: trackHeight)
        let path = UIBezierPath(roundedRect: rectangle, cornerRadius: trackHeight / 2).cgPath

        context?.addPath(path)
        context?.setFillColor(inactiveTrackColor.cgColor)
        context?.closePath()
        context?.fillPath()
        
        context?.restoreGState()
    }
    
    private func getDisplayValue() -> Int {
        return actualFractionalValue
    }
}
