//
//  DigitView.swift
//  DigitRecognizer
//
//  Created by xeadmin on 08/10/19.
//  Copyright © 2019 manav. All rights reserved.
//

import UIKit

struct Line {
    let strokeWidth: Float
    let color: UIColor
    var points: [CGPoint]
}

class DigitView: UIView {
    
    fileprivate var strokeColor = UIColor.white
    fileprivate var strokeWidth: Float = 5
    
    func setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    fileprivate var lines = [Line]()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 2, width: frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(bottomLine)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
}
