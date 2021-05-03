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
    
}
