//
//  LayoutViewCell.swift
//  Project_4_Instagrid
//
//  Created by ROUX Maxime on 01/04/2021.
//

import UIKit


class LayoutCell: UICollectionViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // Image de la cellule
    @IBOutlet weak var imageView: UIImageView!

    // Image picker
    var imagePicker = UIImagePickerController()
    
    
    // Ajout de bordures autour des cellules de la collectionView pour qu'elles soient visibles
    override func awakeFromNib() {
        self.layer.borderWidth = 5
    }
    
    
    // PICK IMAGES FROM PHONE
    
//    @IBAction func imageButton(_ sender: UIButton) {
//
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            imagePicker.delegate = self
//            imagePicker.sourceType = .savedPhotosAlbum
//            imagePicker.allowsEditing = false
//
//            present(imagePicker, animated: true, completion: nil)
//               }
//           }
//
//           func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//               self.dismiss(animated: true, completion: { () -> Void in
//
//               })
//
//               imageView.image = image
//
//
//
//    }

    
}
