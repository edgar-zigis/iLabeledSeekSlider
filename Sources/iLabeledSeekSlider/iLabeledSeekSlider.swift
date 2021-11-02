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
    open var title: NSString = "" {
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
    private var lastSliderLocation: CGFloat = 0
    
    private let topPadding: CGFloat = 2
    private let sidePadding: CGFloat = 16
    private let bubbleHeight: CGFloat = 26
    private let minimumBubbleWidth: CGFloat = 84
    private let bubbleTextPadding: CGFloat = 16

    private let trackHeight: CGFloat = 4
    private let thumbSliderRadius: CGFloat = 12
    
    private var bubbleText: NSString = ""
    private var bubblePathWidth: CGFloat = 0
    private var bubbleTextSize: CGSize = CGSize.zero
    
    private var titleTextSize: CGSize = CGSize.zero
    
    //  MARK: - UI methods -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let x = getInitialX()
        
        drawBubbleValue(in: rect, context: context, x: x)
        drawTitleLabel(context: context)
        drawInactiveTrack(in: rect, context: context)
        drawActiveTrack(in: rect, context: context, x: x)
        drawThumbSlider(in: rect, context: context, x: x)
        drawMinRangeText(context: context)
        drawMaxRangeText(in: rect, context: context)
    }
    
    private func drawActiveTrack(in rect: CGRect, context: CGContext, x: CGFloat) {
        context.saveGState()

        let rectangle = CGRect(
            x: sidePadding,
            y: getSlidingTrackVerticalOffset(),
            width: min(rect.width - sidePadding * 2, max(sidePadding, x)),
            height: trackHeight
        )
        let path = UIBezierPath(roundedRect: rectangle, cornerRadius: trackHeight / 2).cgPath

        context.addPath(path)
        context.setFillColor(activeTrackColor.cgColor)
        context.closePath()
        context.fillPath()
        
        context.restoreGState()
    }
    
    private func drawInactiveTrack(in rect: CGRect, context: CGContext) {
        context.saveGState()

        let rectangle = CGRect(
            x: sidePadding,
            y: getSlidingTrackVerticalOffset(),
            width: rect.width - sidePadding * 2,
            height: trackHeight
        )
        let path = UIBezierPath(roundedRect: rectangle, cornerRadius: trackHeight / 2).cgPath

        context.addPath(path)
        context.setFillColor(inactiveTrackColor.cgColor)
        context.closePath()
        context.fillPath()
        
        context.restoreGState()
    }
    
    private func drawThumbSlider(in rect: CGRect, context: CGContext, x: CGFloat) {
        context.saveGState()
        
        let sliderX = min(
            rect.width - thumbSliderRadius * 2 - sidePadding,
            max(sidePadding, x)
        )
        
        let shadowColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 0.27)
        let ellipseRect = CGRect(
            x: sliderX,
            y: getSlidingTrackVerticalOffset() - thumbSliderRadius + 1,
            width: thumbSliderRadius * 2,
            height: thumbSliderRadius * 2
        )
        
        context.setShadow(
            offset: CGSize(width: 0, height: 0),
            blur: 6,
            color: shadowColor.cgColor
        )
        context.setFillColor(thumbSliderBackgroundColor.cgColor)
        context.fillEllipse(in: ellipseRect)
        
        context.restoreGState()
    }
    
    private func drawBubbleValue(in rect: CGRect, context: CGContext, x: CGFloat) {
        let displayValue = getDisplayValue()
        
        if valuesToSkip.contains(displayValue) {
            drawBubbleValueOnCanvas(in: rect, context: context, x: x)
            return
        }
        
        let previousText = bubbleText
        if let limitValue = limitValue, actualFractionalValue == limitValue && !allowLimitValueBypass {
            if vibrateOnLimitReached {
                if !bubbleText.contains(String(limitValue)) && previousText.length > 0 {
                    //  vibrate
                }
            }
            bubbleText = "\(limitValueIndicator) \(getUnitValue(value: limitValue))" as NSString
            currentValue = limitValue
        } else {
            bubbleText = getUnitValue(value: displayValue)
            currentValue = displayValue
        }
        if previousText != bubbleText && previousText.length > 0 {
            onValueChanged(currentValue)
        }
        
        drawBubbleValueOnCanvas(in: rect, context: context, x: x)
    }
    
    private func drawBubbleValueOnCanvas(in rect: CGRect, context: CGContext, x: CGFloat) {
        context.saveGState()
        
        let attributes = [
            NSAttributedString.Key.font : bubbleValueTextFont,
            NSAttributedString.Key.foregroundColor : bubbleValueTextColor
        ]
        bubbleTextSize = bubbleText.size(withAttributes: attributes)
        bubbleText.draw(
            at: CGPoint(x: getBubbleTextHorizontalOffset(in: rect, x: x), y: getBubbleTextVerticalOffset()),
            withAttributes: attributes
        )
    }
    
    private func drawTitleLabel(context: CGContext) {
        context.saveGState()
        
        let attributes = [
            NSAttributedString.Key.font : titleTextFont,
            NSAttributedString.Key.foregroundColor : titleTextColor
        ]
        title.draw(
            at: CGPoint(x: sidePadding, y: getTitleLabelTextVerticalOffset()),
            withAttributes: attributes
        )
        titleTextSize = title.size(withAttributes: attributes)
        
        context.restoreGState()
    }
    
    private func drawMinRangeText(context: CGContext) {
        context.saveGState()
        
        getUnitValue(value: minValue).draw(
            at: CGPoint(x: sidePadding, y: getRangeTextVerticalOffset()),
            withAttributes: [
                NSAttributedString.Key.font : rangeValueTextFont,
                NSAttributedString.Key.foregroundColor : rangeValueTextColor
            ]
        )
        
        context.restoreGState()
    }
    
    private func drawMaxRangeText(in rect: CGRect, context: CGContext) {
        context.saveGState()
        
        let text = getUnitValue(value: maxValue)
        let attributes = [
            NSAttributedString.Key.font : rangeValueTextFont,
            NSAttributedString.Key.foregroundColor : rangeValueTextColor
        ]
        let textSize = text.size(withAttributes: attributes)
        
        text.draw(
            at: CGPoint(x: rect.width - sidePadding - textSize.width, y: getRangeTextVerticalOffset()),
            withAttributes: attributes
        )
        
        context.restoreGState()
    }
    
    private func getUnitValue(value: Int) -> NSString {
        if unitPosition == .front {
            return "\(unit)\(value)" as NSString
        }
        return "\(value) \(unit)" as NSString
    }
    
    private func getActiveX(in rect: CGRect, currentValue: Int) -> CGFloat {
        let slidingAreaWidth = rect.width - sidePadding - thumbSliderRadius
        let progress = CGFloat(currentValue - minValue) / CGFloat(maxValue - minValue)
        return slidingAreaWidth * progress
    }
    
    private func getInitialX() -> CGFloat {
        return actualXPosition ?? getActiveX(in: frame, currentValue: actualFractionalValue)
    }
    
    private func getDisplayValue() -> Int {
        return (actualFractionalValue / slidingInterval) * slidingInterval
    }
    
    private func getTitleLabelTextVerticalOffset() -> CGFloat {
        return bubbleHeight + topPadding + 5
    }
    
    private func getRangeTextVerticalOffset() -> CGFloat {
        return getSlidingTrackVerticalOffset() + trackHeight / 2 + thumbSliderRadius + 2
    }
    
    private func getSlidingTrackVerticalOffset() -> CGFloat {
        return getTitleLabelTextVerticalOffset() + titleTextSize.height + thumbSliderRadius + 2
    }
    
    private func getBubbleTextVerticalOffset() -> CGFloat {
        return (bubbleHeight - bubbleTextSize.height) / 2 - 2
    }
    
    private func getBubbleTextHorizontalOffset(in rect: CGRect, x: CGFloat) -> CGFloat {
        bubblePathWidth = max(minimumBubbleWidth, bubbleTextSize.width + bubbleTextPadding * 2)
        return min(
            rect.width - sidePadding / 2 - bubbleTextSize.width - ((bubblePathWidth - bubbleTextSize.width) / 2),
            max(
                bubblePathWidth / 2 - bubbleTextSize.width / 2 + sidePadding / 2,
                x - bubbleTextSize.width / 2 + sidePadding * 0.75
            )
        )
    }
    
    //  MARK: Gestures
    
    @objc private func onPan(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            lastSliderLocation = getInitialX()
            let recognizerX = recognizer.location(in: self).x
            if abs(lastSliderLocation - recognizerX) > thumbSliderRadius * 4 {
                recognizer.isEnabled = false
                recognizer.isEnabled = true
            }
        }
        if recognizer.state != .cancelled {
            positionLayers(at: lastSliderLocation + recognizer.translation(in: self).x)
        }
    }
    
    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        positionLayers(at: recognizer.location(in: self).x)
    }
    
    private func positionLayers(at x: CGFloat) {
        let relativeX = min(frame.width - sidePadding - thumbSliderRadius, max(0, x))
        let slidingAreaWidth = frame.width - sidePadding - thumbSliderRadius
        
        let newValue = min(
            maxValue,
            max(
                minValue,
                minValue + Int(round(Double(CGFloat((maxValue - minValue)) * (relativeX / slidingAreaWidth))))
            )
        )
        
        if limitValue == nil || allowLimitValueBypass {
            actualFractionalValue = newValue
        } else {
            actualFractionalValue = min(newValue, limitValue!)
        }
        if limitValue != nil && !allowLimitValueBypass {
            if newValue <= limitValue! {
                actualXPosition = relativeX
            } else {
                actualXPosition = getActiveX(in: frame, currentValue: limitValue!)
            }
        } else {
            actualXPosition = relativeX
        }
        
        setNeedsDisplay()
    }
    
    //  MARK: Init
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        addObservers()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addObservers()
    }
    
    private func addObservers() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onPan(_:))))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
    }
}
