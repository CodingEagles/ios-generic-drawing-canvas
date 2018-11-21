//
//  CanvasViewController.swift
//  ios-generic-drawing-canvas
//
//  Created by Daniel Barbosa on 20/11/18.
//  Copyright © 2018 CodingEagles. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var canvas: CanvasView?
    var stickers: StickersView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvas = CanvasView()
        canvas?.backgroundColor = .white
        
        stickers = StickersView()
        stickers?.backgroundColor = .clear
        
        view.addSubview(canvas!)
        view.addSubview(stickers!)
        
        canvas?.isUserInteractionEnabled = true
        stickers?.isUserInteractionEnabled = true
        
        addFullScreenConstraints(to: canvas!)
        addFullScreenConstraints(to: stickers!)
    }
    
    func addFullScreenConstraints(to subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        subView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        subView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}
