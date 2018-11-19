//
//  ViewController.swift
//  ios-generic-drawing-canvas
//
//  Created by Lucas Tavares on 19/11/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, ViewControllerDelegate {
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var lbSizeFont: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    
    var images: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canvasView.delegate = self
        self.canvasView.isMultipleTouchEnabled = true
        let reqImages = NSFetchRequest<Image>(entityName: "Image")
        lbSizeFont.text = "1.0"
        DispatchQueue.main.async {
            self.images = CoreDataManager.sharedManager.fetch(reqImages)!
            print(self.images)
            guard let image = self.images.last ?? nil, let picture = image.picture  else { return }
            self.canvasView.drawImage = UIImage(data: picture)
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
        CanvasViewHelper().save(that: self.canvasView)
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
                button.layer.cornerRadius = 0
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clear.cgColor
            } else {
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 3
                button.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
        
    }

}

