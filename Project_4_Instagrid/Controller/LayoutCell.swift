//
//  LayoutViewCell.swift
//  Project_4_Instagrid
//
//  Created by ROUX Maxime on 01/04/2021.
//

import UIKit


class LayoutCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Image of the cell
    @IBOutlet weak var imageView: UIImageView!
    
    // Image "+" of the cell
    @IBOutlet weak var addImageView: UIImageView!
    
    // Add border the each cells
    override func awakeFromNib() {
        self.layer.borderWidth = 4
        self.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
    }
    
}
