//
//  CanvasView.swift
//  ios-generic-drawing-canvas
//
//  Created by Lucas Tavares on 19/11/18.
//  Copyright © 2018 CodingEagles. All rights reserved.
//

import UIKit
import CoreGraphics

class CanvasView: UIView {
    
    // Data Source
    var lineColor: UIColor = .black
    var lineWidth: CGFloat = 5
    
    var path: UIBezierPath!
    
    var touchPoint: CGPoint!
    var startingPoint: CGPoint!
    
    var drawing: UIImage?
    
    var samplePoints: [CGPoint] = []
    
    weak var delegate: CanvasViewDelegate?
    
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        samplePoints.append((touch?.location(in: self))!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else  { return }
        for coalescedTouch in event!.coalescedTouches(for: touch)! {
            samplePoints.append(coalescedTouch.location(in: self))
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        drawing = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        samplePoints.removeAll()
        self.delegate?.finishedDrawingLine(on: self)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        ctx.setAllowsAntialiasing(true)
        ctx.setShouldAntialias(true)
        
        drawing?.draw(in: rect)
        lineColor.setStroke()
        path.removeAllPoints()
        
        if !samplePoints.isEmpty {
            path.move(to: samplePoints.first!)
            path.addLine(to: averageOfPoints(initial: samplePoints.first!, last: samplePoints[1]))
            for i in 1..<samplePoints.count - 1 {
                let midPoint = averageOfPoints(initial: samplePoints[i], last: samplePoints[i + 1])
                path.addQuadCurve(to: midPoint, controlPoint: samplePoints[i])
            }
            
            path.addLine(to: samplePoints.last!)
            path.stroke()
            
        }
    }
    
    func clearCanvas() {
        self.delegate?.eraseDrawing(on: self)
        drawing = nil
        setNeedsDisplay()
    }
    
    func averageOfPoints(initial: CGPoint, last:  CGPoint) -> CGPoint {
        return CGPoint(x: (initial.x + last.x)/2, y: (initial.y + last.y)/2)
    }
    
}
