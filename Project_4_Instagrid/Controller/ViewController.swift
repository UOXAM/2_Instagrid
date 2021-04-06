//
//  ViewController.swift
//  Project_4_Instagrid
//
//  Created by ROUX Maxime on 05/03/2021.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var SwipeView: UIView!
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    
    @IBOutlet weak var LayoutCollectionView: UICollectionView!
    @IBOutlet weak var selectedLayout1: UIImageView!
    @IBOutlet weak var selectedLayout2: UIImageView!
    @IBOutlet weak var selectedLayout3: UIImageView!
    
// selection par défaut de Layout 2 : Button2 selected et Layout 2 dans la CollectionView
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deselectAllButtons()
        self.Button2.isSelected = true
        self.selectedLayout2.alpha = 1
        self.layoutSelected = .layout2
        
        // pour qu'il sache que les données du DATASOURCE se trouvent dans cette classe
        LayoutCollectionView.dataSource = self
        LayoutCollectionView.delegate = self
        
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
    
//
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutCell", for: indexPath) as? LayoutCell {
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
    @IBAction func SwipeToShare(_ sender: UIPanGestureRecognizer) {
            // si Portrait : swipe vers le haut
            // si Paysage : swipe vers la gauche
        
        // image to share : je voudrais que mon image soit la CollectionView
        let image = UIImage(named: "Icon")
        
        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)


    }
    
}
