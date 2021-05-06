//
//  Extension.swift
//  Project_4_Instagrid
//
//  Created by ROUX Maxime on 06/05/2021.
//

import UIKit

/// EXTENSION UIView : Allow to transform CollectionView to UIImage
extension UIView {
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
