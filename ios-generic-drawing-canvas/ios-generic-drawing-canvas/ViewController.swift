//
//  ViewController.swift
//  ios-generic-drawing-canvas
//
//  Created by Lucas Tavares on 19/11/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var imagesView: UIView!
    
    @IBOutlet weak var lbSizeFont: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    
    @IBOutlet weak var penButton: UIButton!
    @IBOutlet weak var moveButton: UIButton!
    
    var images: [Image] = []
    
    var selectedView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canvasView.isMultipleTouchEnabled = true
        let reqImages = NSFetchRequest<Image>(entityName: "Image")
        lbSizeFont.text = "1.0"
        self.penButtonPressed("")
        DispatchQueue.main.async {
            self.images = CoreDataManager.sharedManager.fetch(reqImages)!
            print(self.images)
            guard let image = self.images.last ?? nil, let picture = image.picture  else { return }
            self.canvasView.drawing = UIImage(data: picture)
            self.canvasView.backgroundColor = .clear
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func didClearCanvas(_ sender: Any) {
        canvasView.clearCanvas()
    }
    
    @IBAction func didChangePenColorToYellow(_ sender: Any) {
        select(selectButton: yellowButton)
        canvasView.lineColor = UIColor.yellow
    }
    
    @IBAction func didChangePenColorToBlue(_ sender: Any) {
        select(selectButton: blueButton)
        canvasView.lineColor = UIColor.blue
    }
    
    @IBAction func didChangePenColorToRed(_ sender: Any) {
        select(selectButton: redButton)
        canvasView.lineColor = UIColor.red
    }
    
    @IBAction func didDecreasePenSize(_ sender: Any) {
        if canvasView.path.lineWidth > 1 {
            canvasView.path.lineWidth = canvasView.path.lineWidth - 1
        }
        lbSizeFont.text = "\(canvasView.path.lineWidth)"
    }
    
    @IBAction func didIncreasePenSize(_ sender: Any) {
        canvasView.path.lineWidth += 1
        lbSizeFont.text = "\(canvasView.path.lineWidth)"
    }
    func drawFinish() {
        canvasView.backgroundColor = .clear
//        CanvasViewHelper().save(that: imagesView)
    }
    
    func eraseDraw() {
        let reqImages = NSFetchRequest<Image>(entityName: "Image")
        images = CoreDataManager.sharedManager.fetch(reqImages)!
        print(images)
        if images.count > 0 {
            for image in self.images {
                CoreDataManager.sharedManager.delete(object: image)
            }
        }
        
    }
    
    func select(selectButton : UIButton ){
        let unselectButtons = buttons.filter { (button) -> Bool in
            button != selectButton
        }
        
        for button in buttons {
            if unselectButtons.contains(button) {
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clear.cgColor
            } else {
                button.layer.borderWidth = 3
                button.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        
    }
    
    @IBAction func penButtonPressed(_ sender: Any) {
        penButton.layer.borderWidth = 5
        penButton.layer.borderColor = UIColor.white.cgColor
        moveButton.layer.borderWidth = 0
        
        canvasView.isUserInteractionEnabled = true
        
        selectedView?.layer.borderWidth = 0
        selectedView?.layer.borderColor = UIColor.clear.cgColor
        selectedView = nil
    }
    
    @IBAction func moveButtonPressed(_ sender: Any) {
        penButton.layer.borderWidth = 0
        moveButton.layer.borderWidth = 5
        moveButton.layer.borderColor = UIColor.white.cgColor
        
        canvasView.isUserInteractionEnabled = false
    }
    
    @IBAction func addViewButtonPressed(_ sender: Any) {
        let newView = UIView(frame: CGRect(x: 8, y: 16, width: 150, height: 150))
        
        let randomHue = CGFloat(arc4random()%256)/256
        
        newView.backgroundColor = UIColor(hue: randomHue, saturation: 1, brightness: 1, alpha: 1)
        
        imagesView.addSubview(newView)
    }
    
    @IBAction func tapGestureRecognized(_ sender: Any) {
        let recognizer = sender as! UITapGestureRecognizer
        
        let location = recognizer.location(in: imagesView)
        
        let tappedView = imagesView.hitTest(location, with: nil)!
        
        print(tappedView)
        
        if tappedView == imagesView {
            
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
    
    @IBAction func panGestureRecognized(_ sender: Any) {
        let recognizer = sender as! UIPanGestureRecognizer
        
        let location = recognizer.location(in: imagesView)
        
        var touchedView = imagesView
        
        if imagesView.hitTest(location, with: nil)! == selectedView {
            touchedView = imagesView.hitTest(location, with: nil)!
        }
        
        if recognizer.state == .changed {
            
            if imagesView != imagesView {
                view.bringSubviewToFront(touchedView!)
                touchedView!.center = CGPoint(x: location.x, y: location.y)
            }
        }
    }
}

