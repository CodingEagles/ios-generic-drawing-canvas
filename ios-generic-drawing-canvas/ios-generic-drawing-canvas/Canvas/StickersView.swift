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
        self.addInteraction(UIDragInteraction(delegate: self))
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        
        self.addGestureRecognizer(pinch)
        self.addGestureRecognizer(rotation)
        
        let newView = UIView.init(frame: CGRect.init(x: 250, y: 400, width: 250, height: 250))
        newView.backgroundColor = .black
        
        addSubview(newView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer? = nil) {
        let recognizer = sender as! UIPinchGestureRecognizer
        
        let location = recognizer.location(in: self)
        
        let tappedView = self.hitTest(location, with: nil)!
        
        if tappedView == self {
            
        } else {
            if recognizer.state == .began || recognizer.state == .changed {
                tappedView.transform = (tappedView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))
                recognizer.scale = 1.0
            }
        }
    }
    
    @objc func handleRotation(_ sender: UIRotationGestureRecognizer? = nil) {
        let recognizer = sender as! UIRotationGestureRecognizer
        
        let location = recognizer.location(in: self)
        
        let tappedView = self.hitTest(location, with: nil)!
        
        if tappedView == self {
            
        } else {
            if recognizer.state == .began || recognizer.state == .changed {
                tappedView.transform = tappedView.transform.rotated(by: recognizer.rotation)
                recognizer.rotation = 0
            }
        }
    }
    
}

extension StickersView: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        let touchedPoint = session.location(in: self)
        
        if let touchedView = self.hitTest(touchedPoint, with: nil) as? UIImageView {
            let touchedImage = touchedView.image
            
            let itemProvider = NSItemProvider(object: touchedImage!)
            
            let dragItem = UIDragItem(itemProvider: itemProvider)
            
            dragItem.localObject = touchedView
            
            return [dragItem]
        }
        
        if let touchedView = self.hitTest(touchedPoint, with: nil) as? UILabel {
            let touchedText = touchedView.text! as NSString

            let itemProvider = NSItemProvider(object: touchedText)

            let dragItem = UIDragItem(itemProvider: itemProvider)

            dragItem.localObject = touchedView

            return [dragItem]
        }
    
        return []
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }

    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        session.items.forEach { (dragItem) in
            if let touchedView = dragItem.localObject as? UIView {
                touchedView.removeFromSuperview()
            }
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        self.addSubview(item.localObject as! UIView)
    }
}
