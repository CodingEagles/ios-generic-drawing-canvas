//
//  ViewControllerDelegate.swift
//  ios-generic-drawing-canvas
//
//  Created by Lucas Tavares on 19/11/18.
//  Copyright © 2018 CodingEagles. All rights reserved.
//

import Foundation

protocol CanvasViewDelegate: class {
    func finishedDrawingLine(on canvasView: CanvasView)
    func eraseDrawing(on canvasView: CanvasView)
}
