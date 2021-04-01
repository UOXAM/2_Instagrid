//
//  ViewController.swift
//  Project_4_Instagrid
//
//  Created by ROUX Maxime on 05/03/2021.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDataSource {
    
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
        deselectAllButtons()
        Button2.isSelected = true
        selectedLayout2.alpha = 1
        layoutSelected = .layout2
//        layout.getCellNumber()
        
        // pour qu'il sache que les données du DATASOURCE se trouvent dans cette classe
        LayoutCollectionView.dataSource = self
        
        
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
    
    @IBAction func Button3(_ sender: Any) {
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

// RÉCUPÉRER LE NOMBRE DE CELLULES DU LAYOUT POUR LA COLLECTIONVIEW
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
    func collectionView(_ collectionView: UICollectionView, layout LayoutCollectionView: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let demiWidth = collectionView.frame.size.width / 2
        let fullWidth = collectionView.frame.size.width
        
        switch layoutSelected {
        case .layout1  :
            if indexPath.item == 0 {
                // Appliquer à la 1ère cellule la largeur complète de la CollectionView
                return CGSize.init(width: fullWidth, height: demiWidth)
            } else {
                // Appliquer aux autres cellules une demie largeur de la CollectionView
                return CGSize.init(width: demiWidth, height: demiWidth)
            }
        case .layout2 :
            if indexPath.item == 2 {
                // Appliquer à la 3ème cellule la largeur complète de la CollectionView
                return CGSize.init(width: fullWidth, height: demiWidth)
            } else {
                // Appliquer aux autres cellules une demie largeur de la CollectionView
                return CGSize.init(width: demiWidth, height: demiWidth)
            }
        case .layout3 :
            // Appliquer à chaque cellule une demie largeur de la CollectionView
            return CGSize.init(width: demiWidth, height: demiWidth)
        }
    }
    


    
    
    

        
        

    // *** IF CLICK ON A LAYOUT BUTTON ***
    // Action sur les Boutons
    // 1. Mise en forme des boutons
    // var oldLayoutImage = Button2.image ???
    // Button2.image = ButtonActive.image
    // ButtonActive.image = oldLayoutImage
    // Button2.stateConfig = .selected (background color : Bleu dur avec opacité à 30% ?)
    
    // *** IF SWIPE ***
    // Action sur 2 zones ?
    // Envoyer vers
        
    // *** CHOISIR UNE PHOTO ***
    // Action sur les cellules de la collectionView
    // Accès à la bibliothèque du téléphone pour choisir image
    // Attribution de l'image et disparition du "+"
        
    
        
        
        
        
    }
    
    
    
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//    var layoutChoice = Layout
//}
//




//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection Section: Int)  -> Int {
//        let list : [UIImage] = [Image("Layout 1"), Image("Layout 2"), Image("Layout 3"), Image("Plus")]
//



// *** GENERER LA COLLECTION VIEW ***
// récupérer le bouton sélectionné : nombre d'items, largeur des items, quel layout
// créer les différentes mises en formes Layout 1, 2 et 3
// appliquer le bon layout



//    func collectionViewLayouts() {
//
//        let demiWidth = LayoutCollectionView.frame.size.width / 2
//        let fullWidth = LayoutCollectionView.frame.size.width
//
//        switch self.layout {
//        case .layout1  :
//            // Items number = 3
//            LayoutCollectionView.numberOfItems(inSection: 3)
//            // First cell width = fullWidth and height = demiWidth
//            // Other cells (2 and 3) width = height = demiWidth
//           // (CGSize)indexPath[0]
//           // CGSize.init(width: classicSize, height: classicSize)
//
//        case .layout2 :
//            // Items number = 3
//            // Third cell width = fullWidth and height = demiWidth
//            // Other cells (1 and 2) width = height = demiWidth
//
//        case .layout3 :
//            // Items number = 4
//            // Each cell (1, 2 and 3) width = height = demiWidth
//
//    }
