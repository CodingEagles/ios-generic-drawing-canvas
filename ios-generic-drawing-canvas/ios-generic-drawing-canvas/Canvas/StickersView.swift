//
//  StickersView.swift
//  ios-generic-drawing-canvas
//
//  Created by Daniel Barbosa on 20/11/18.
//  Copyright © 2018 CodingEagles. All rights reserved.
//

import UIKit

class StickersView: UIView {
    
    var selectedView: UIView?
    
    func loadView() {
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(self.handlePan(_:)))
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap(_:)))
        
        self.addGestureRecognizer(pan)
        self.addGestureRecognizer(tap)
        
    }
    
    func addView() {
        let newView = UIView(frame: CGRect(x: 8, y: 16, width: 150, height: 150))
        
        let randomHue = CGFloat(arc4random()%256)/256
        
        newView.backgroundColor = UIColor(hue: randomHue, saturation: 1, brightness: 1, alpha: 1)
        
        self.addSubview(newView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let recognizer = sender as UITapGestureRecognizer
        
        let location = recognizer.location(in: self)
        
        let tappedView = self.hitTest(location, with: nil)!
        
        if tappedView == self {
            
        } else if tappedView == selectedView {
            selectedView?.layer.borderWidth = 0
            selectedView?.layer.borderColor = UIColor.clear.cgColor
            selectedView = nil
        } else {
            selectedView?.layer.borderWidth = 0
            selectedView?.layer.borderColor = UIColor.clear.cgColor
            
            tappedView.layer.borderWidth = 10
            tappedView.layer.borderColor = UIColor.red.cgColor
            selectedView = tappedView
        }
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let recognizer = sender
        
        let location = recognizer.location(in: self)
        
        var touchedView = self as UIView
        
        if self.hitTest(location, with: nil)! == selectedView {
            touchedView = self.hitTest(location, with: nil)!
        }
        
        if recognizer.state == .changed {
            
            if touchedView != self {
                self.bringSubviewToFront(touchedView)
                touchedView.center = CGPoint(x: location.x, y: location.y)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
}
