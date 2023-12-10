//
//  DashedLineView.swift
//  Presentation
//
//  Created by Dao Van Nha on 14/10/2023.
//

import Foundation
import UIKit
import Utils

@IBDesignable
public class DashedLineView: UIView {
    
    @IBInspectable public var dashLength: CGFloat = 2.0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var spaceBetweenDash: CGFloat = 2.0 {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var color: UIColor = .black {
        didSet { setNeedsDisplay() }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard dashLength > 0 else { return }
        
        let  path = UIBezierPath()
        if heightBound > widthBound {
            let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)
            
            let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
            path.lineWidth = widthBound
            
        } else {
            let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)
            
            let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
            path.lineWidth = heightBound
        }
        
        let  dashes: [ CGFloat ] = [ dashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        path.lineCapStyle = .butt
        color.set()
        path.stroke()
    }
    
    private var widthBound: CGFloat {
        return self.bounds.width
    }
    
    private var heightBound: CGFloat {
        return self.bounds.height
    }
}

public class DashedBorderView: UIView {
    @IBInspectable public var dashLength: CGFloat = 6.0 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var dashWidth: CGFloat = 1.0 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var spaceBetweenDash: CGFloat = 6.0 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var dashColor: UIColor = ColorConstant.lineView {
        didSet { setNeedsDisplay() }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let rect = CGRect(x: dashWidth - 1,
                          y: dashWidth - 1,
                          width: bounds.width - 2 * (dashWidth - 1),
                          height: bounds.height - 2 * (dashWidth - 1))
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius)
        let dashes: [ CGFloat ] = [ dashLength, spaceBetweenDash ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        path.lineCapStyle = .butt
        path.lineWidth = dashWidth
        dashColor.set()
        path.stroke()
    }
}

