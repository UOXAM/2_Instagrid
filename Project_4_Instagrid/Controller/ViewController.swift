//
//  ViewController.swift
//  Project_4_Instagrid
//
//  Created by ROUX Maxime on 05/03/2021.
//

import UIKit

// Extension de l'UIView qui permet de transformer la collectionView en UIImage
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var SwipeView: UIView!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var swipeText: UILabel!
    
    @IBOutlet weak var LayoutCollectionView: UICollectionView!
    @IBOutlet weak var selectedLayout1: UIImageView!
    @IBOutlet weak var selectedLayout2: UIImageView!
    @IBOutlet weak var selectedLayout3: UIImageView!
    
    @IBOutlet weak var CollectionViewLandscapeConstraint: NSLayoutConstraint!
    @IBOutlet weak var CollectionViewPortraitConstraint: NSLayoutConstraint!
    
    @IBOutlet var SwipeGesture: UISwipeGestureRecognizer!

    // Selection par défaut de Layout 2 : Button2 selected et Layout 2 dans la CollectionView
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deselectAllButtons()
        self.Button2.isSelected = true
        self.selectedLayout2.alpha = 1
        self.layoutSelected = .layout2
        
        // Pour qu'il sache que les données du DATASOURCE se trouvent dans cette classe
        LayoutCollectionView.dataSource = self
        LayoutCollectionView.delegate = self
        
        orientation(isLandscape: landscapeOrientation())
        
        // Pourquoi UIDevice.current.orientation.isLandscape ne fonctionne pas dans le viewDidLoad ?
        // Modifier le sens du swipe en fonction de l'orientation de départ
//        if UIDevice.current.orientation.isLandscape {
//            self.SwipeGesture.direction = .left
//            self.swipeText.text = "Swipe left to share"
//        } else {
//            self.SwipeGesture.direction = .up
//            self.swipeText.text = "Swipe up to share"
//        }
        
        // Ajout de bordures à la CollectionView pour uniformiser avec les bordures des cellules
        LayoutCollectionView.layer.borderWidth = 10
        LayoutCollectionView.layer.borderColor = #colorLiteral(red: 0, green: 0.4076067805, blue: 0.6132292151, alpha: 1)
    }
    


    // Définir l'orientation de l'écran en comparant la hauteur à la largeur
    private func landscapeOrientation() -> Bool {
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            return true
        } else {
            return false
        }
    }
    
    // Ajuster le sens du Swipe selon l'orientation de l'écran
    private func orientation(isLandscape: Bool) {
        if isLandscape {
            self.swipeText.text = "Swipe left to share"
            self.SwipeGesture.direction = .left
        } else {
            self.swipeText.text = "Swipe up to share"
            self.SwipeGesture.direction = .up
        }
    }
    
    
// ÉNUMÉRATION DES LAYOUTS
    enum Layouts {
        case layout1
        case layout2
        case layout3
        
        // Nombre de cases par layout
        func getCellNumber () -> Int{
            switch self {
            case .layout1, .layout2 :
                return 3
            case .layout3 :
                return 4
            }
        }
    }

// CRÉATION DES VARIABLES :
    // Layout actif par défaut
    var layoutSelected : Layouts = .layout2
    // Tableau d'images vide
    var imagesSelected : [UIImage?] = [nil, nil, nil, nil]
    // Index de l'image
    var indexPath : IndexPath?

    
    
// SÉLECTION DU LAYOUT LORSQU'ON APPUIE SUR UN DES TROIS BOUTONS:
    @IBAction func Button1(_ sender: UIButton) {
        // Désélectionner tous les boutons
        deselectAllButtons()
        // Bouton 1 devient sélectionné
        Button1.isSelected = true
        // Image se superposant au layout pour indiqué qu'il est sélectionné devient visible (sans transparence)
        selectedLayout1.alpha = 1
        // Affecter le layout 1
        layoutSelected = .layout1
        // Actualiser
        LayoutCollectionView.reloadData()
    }
    
    @IBAction func Button2(_ sender: UIButton) {
        deselectAllButtons()
        Button2.isSelected = true
        selectedLayout2.alpha = 1
        layoutSelected = .layout2
        LayoutCollectionView.reloadData()
    }
    
    @IBAction func Button3(_ sender: UIButton) {
        deselectAllButtons()
        Button3.isSelected = true
        selectedLayout3.alpha = 1
        layoutSelected = .layout3
        LayoutCollectionView.reloadData()
    }

    private func deselectAllButtons() {
        Button1.isSelected = false
        Button2.isSelected = false
        Button3.isSelected = false
        selectedLayout1.alpha = 0
        selectedLayout2.alpha = 0
        selectedLayout3.alpha = 0
    }

// RÉCUPÉRER LE NOMBRE DE CELLULES DU LAYOUT POUR LA CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutSelected.getCellNumber()
    }
    

// Permettre d'ouvrir la galerie d'image lors d'un clic sur une cellule de la CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        imgController.allowsEditing = true
        self.present(imgController, animated: true, completion: nil)
    }
    
// Choisir une image dans la galerie et l'ajouter à la table
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }
        self.imagesSelected[indexPath?.item ?? 0] = image
        picker.dismiss(animated: true) {
            self.LayoutCollectionView.reloadData()
        }
    }
    
    
// AFFICHER L'IMAGE SÉLECTIONNÉE ET ENLEVER LE "+"
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutCell", for: indexPath) as? LayoutCell {
            cell.imageView.image = self.imagesSelected[indexPath.item]
            if cell.imageView.image != nil {
                cell.addImageView.isHidden = true
            } else {
                cell.addImageView.isHidden = false
            }
            return cell
        }
        return UICollectionViewCell()
    }

    
// DIMENSIONNER LES CELLULES SELON LAYOUT CHOISI
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let fullSize = collectionView.frame.size.width
        let halfSize = fullSize / 2
        
        switch layoutSelected {
        case .layout1  :
            if indexPath.item == 0 {
                // Appliquer à la 1ère cellule la largeur complète de la CollectionView
                return CGSize.init(width: fullSize, height: halfSize)
            } else {
                // Appliquer aux autres cellules une demie largeur de la CollectionView
                return CGSize.init(width: halfSize, height: halfSize)
            }
        case .layout2 :
            if indexPath.item == 2 {
                // Appliquer à la 3ème cellule la largeur complète de la CollectionView
                return CGSize.init(width: fullSize, height: halfSize)
            } else {
                // Appliquer aux autres cellules une demie largeur de la CollectionView
                return CGSize.init(width: halfSize, height: halfSize)
            }
        case .layout3 :
            // Appliquer à chaque cellule une demie largeur de la CollectionView
            return CGSize.init(width: halfSize, height: halfSize)
        }
    }
    
// SWIPE TO SHARE
    
    

    
    
    @IBAction func SwipeToShare(_ sender: UISwipeGestureRecognizer) {
        // Tranforme la CollectionView en image
        let layoutToShare = self.LayoutCollectionView.asImage()
        
        UIView.animate(withDuration: 0.75, animations: {
            // si mode portrait : on envoie vers le haut
            if UIDevice.current.orientation.isPortrait ||  self.landscapeOrientation() == false {
                self.CollectionViewPortraitConstraint.constant = -300
            }else{
                // si mode paysage : on envoie vers le haut
                self.CollectionViewLandscapeConstraint.constant = -300
            }
            
            // faire disparaître
            self.LayoutCollectionView.layer.opacity = 0
            self.LayoutCollectionView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            // permet d'appliquer la durée de l'animation
            self.view.layoutIfNeeded()

        // Revenir à la position initiale
        }, completion: { (finished) in
            let activityController = UIActivityViewController(activityItems: [layoutToShare], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (type,completed,items,error) in
                if UIDevice.current.orientation.isPortrait {
                    self.CollectionViewPortraitConstraint.constant = 0
                    self.CollectionViewLandscapeConstraint.constant = 0
                    self.LayoutCollectionView.reloadData()

                } else {
                    self.CollectionViewPortraitConstraint.constant = 0
                    self.CollectionViewLandscapeConstraint.constant = 0
                    self.LayoutCollectionView.reloadData()
                }
                UIView.animate(withDuration: 0.75) {
                    self.LayoutCollectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.LayoutCollectionView.layer.opacity = 1
                    self.view.layoutIfNeeded()
                }
            }
            self.present(activityController, animated: true, completion: nil)
        })

    }
    
    
    // Modifier le sens du swipe en lorsque l'orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.LayoutCollectionView.reloadData()
        
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            self.SwipeGesture.direction = .left
            self.swipeText.text = "Swipe left to share"

        } else {
            print("Portrait")
            self.SwipeGesture.direction = .up
            self.swipeText.text = "Swipe up to share"
        }
        
    }

}
