//
//  CanvasViewController.swift
//  ios-generic-drawing-canvas
//
//  Created by Daniel Barbosa on 20/11/18.
//  Copyright © 2018 CodingEagles. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var canvas = CanvasView()
    var stickers = StickersView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stickers)
        view.addSubview(canvas)
        
        addFullScreenConstraints(to: canvas)
        addFullScreenConstraints(to: stickers)
        
        canvas.isUserInteractionEnabled = false
        
        stickers.backgroundColor = .white
        canvas.backgroundColor = .clear
        
        view.addInteraction(UIDropInteraction(delegate: self))
    }
    
    func addFullScreenConstraints(to subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        subView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        subView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

extension PageViewController: UIDropInteractionDelegate {

    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: NSString.self)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal.init(operation: .copy)
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {

        for dragItem in session.items {

            var isImage = false

            dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (obj, err) in

                if let err = err {
                    print("Failed to load out dragged item: ", err)
                    return
                }

                isImage = true

                guard let draggedImage = obj as? UIImage else { return }

                DispatchQueue.main.async {
                    let imageView = UIImageView.init(image: draggedImage)
                    imageView.isUserInteractionEnabled = true

//                    let xPosition = session.location(in: self.canvas).x - draggedImage.size.width/2
//                    let yPosition = session.location(in: self.canvas).y - draggedImage.size.height/2
                    let xPosition = session.location(in: self.stickers).x - draggedImage.size.width/2
                    let yPosition = session.location(in: self.stickers).y - draggedImage.size.height/2

                    imageView.frame = CGRect(x: xPosition, y: yPosition, width: draggedImage.size.width, height: draggedImage.size.height)

//                    self.canvas.addSubview(imageView)
                    self.stickers.addSubview(imageView)

                    return
                }
            }

            dragItem.itemProvider.loadObject(ofClass: NSString.self) { (obj, err) in

                if let err = err {
                    print("Failed to load out dragged item: ", err)
                    return
                }

                guard let draggedText = obj as? NSString else { return }

                DispatchQueue.main.async {

                    let label = UILabel()
                    label.numberOfLines = 0
                    label.text = String(draggedText)

                    let maximumLabelSize: CGSize = CGSize(width: 320, height: 9999)
                    let expectedLabelSize: CGSize = label.sizeThatFits(maximumLabelSize)

                    label.frame.size = CGSize(width: 320.0, height: expectedLabelSize.height)

//                    let xPosition = session.location(in: self.canvas).x - label.frame.width/2
//                    let yPosition = session.location(in: self.canvas).y - label.frame.height/2
                    let xPosition = session.location(in: self.stickers).x - label.frame.width/2
                    let yPosition = session.location(in: self.stickers).y - label.frame.height/2

                    label.frame.origin = CGPoint(x: xPosition, y: yPosition)

                    label.isUserInteractionEnabled = true

                    if isImage == false {
//                        self.canvas.addSubview(label)
                        self.stickers.addSubview(label)
                    }

                    return
                }
            }
        }
    }
}
