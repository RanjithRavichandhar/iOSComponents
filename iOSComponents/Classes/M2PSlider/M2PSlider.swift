//
//  CustomSlider.swift
//  M2PCardManager
//
//  Created by Ranjith Ravichandran on 15/09/22.
//

import Foundation
import UIKit

public class M2PSlider: UISlider {

    public var tool_tip: ToolTipPopupView?
    private var toolImage: UIImageView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initToolTip()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        initToolTip()
    }
    
    public var M2PThumbTouchSize = CGSize(width: 24, height: 40)
    public static var shared = M2PSlider()
    
    private func initToolTip() {
        tool_tip = ToolTipPopupView.init(frame: CGRect.zero)
        tool_tip?.backgroundColor = UIColor.clear
        tool_tip?.tintColor = .purple
        tool_tip?.draw(CGRect.zero)
        tool_tip?.isHidden = true
        
        toolImage = UIImageView.init(frame: CGRect.zero)
        toolImage?.backgroundColor = .clear
        toolImage?.contentMode = .scaleAspectFill
        toolImage?.isHidden = true
        toolImage?.image = UIImage(named: "m2ptooltip", in: M2PComponentsBundle.shared.currentBundle, compatibleWith: nil)!
//        tool_tip?.addSubview(toolImage!)
        self.addSubview(toolImage!)
        self.addSubview(tool_tip!)
        
        self.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                self.setThumbImage(UIImage(named: "thumbHightlight"), for: .highlighted)
                self.toolImage?.isHidden = false
                self.tool_tip?.isHidden = false
                break
            case .moved:
                self.setThumbImage(UIImage(named: "thumbHightlight"), for: .highlighted)
                self.toolImage?.isHidden = false
                self.tool_tip?.isHidden = false
                break
            case .ended:
                self.setThumbImage(UIImage(named: ""), for: .normal)
                self.toolImage?.isHidden = true
                self.tool_tip?.isHidden = true
                break
            default:
                self.setThumbImage(UIImage(named: ""), for: .normal)
                break
            }
        }
    }
    
    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = 8.0
        return rect
    }
    
    public override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let knobRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let popupRect = knobRect.offsetBy(dx: 0, dy: -(knobRect.size.height))
        tool_tip?.frame = popupRect.offsetBy(dx: 0, dy: 0)
        toolImage?.frame = popupRect.offsetBy(dx: 0, dy: 0)
        tool_tip?.setValue(value: self.value)
        return knobRect
    }
}

public class ToolTipPopupView: UIView {
    
    private var toolTipValue: NSString?
    
    public override func draw(_ rect: CGRect) {
        
        if toolTipValue != nil {
            
            let paraStyle = NSMutableParagraphStyle.init()
            paraStyle.lineBreakMode = .byWordWrapping
            paraStyle.alignment = .center
            
            let textAttributes = [NSAttributedString.Key.font: UIFont.customFont(name: "Arial-BoldMT", size: .x13), NSAttributedString.Key.paragraphStyle: paraStyle, NSAttributedString.Key.foregroundColor: UIColor.black]
            
            if let s: CGSize = toolTipValue?.size(withAttributes: textAttributes as [NSAttributedString.Key : Any]) {
                let yOffset = s.height
                let textRect = CGRect.init(x: self.bounds.origin.x, y: yOffset, width: self.bounds.size.width, height: s.height)
                toolTipValue?.draw(in: textRect, withAttributes: textAttributes as [NSAttributedString.Key : Any])
            }
        }
    }
    
    func setValue(value: Float) {
        toolTipValue = NSString.init(format: "%d", Int(value))
        self.setNeedsDisplay()
    }
}
