//
//  CanvasViewHelper.swift
//  ios-generic-drawing-canvas
//
//  Created by Lucas Tavares on 19/11/18.
//  Copyright © 2018 Coding Eagles. All rights reserved.
//

import Foundation
import UIKit

class CanvasViewHelper {
    func save(that view:UIView) {
        let viewToImage = Image(context:  CoreDataManager.sharedManager.persistentContainer.viewContext)
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { (context) in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        viewToImage.picture = image.jpegData(compressionQuality: 0.75)
        CoreDataManager.sharedManager.saveContext()
    }
}
