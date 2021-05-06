//
//  ViewController.swift
//  Project_4_Instagrid
//
//  Created by ROUX Maxime on 05/03/2021.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

// MARK: Variables
    @IBOutlet weak private var button1: UIButton!
    @IBOutlet weak private var button2: UIButton!
    @IBOutlet weak private var button3: UIButton!
    @IBOutlet weak private var swipeText: UILabel!
    @IBOutlet weak private var layoutCollectionView: UICollectionView!
    @IBOutlet weak private var collectionViewLandscapeConstraint: NSLayoutConstraint!
    @IBOutlet weak private var collectionViewPortraitConstraint: NSLayoutConstraint!
    @IBOutlet private var swipeGesture: UISwipeGestureRecognizer!
    // Layout by default
    private var layoutSelected : Layouts = .layout2
    // Table of images (empty)
    private var imagesSelected : [UIImage?] = [nil, nil, nil, nil]
    // Image index
    private var indexPath : IndexPath?

// MARK: viewDidLoad
    // viewDidLoad : Called after the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewDidLoad()
    }

    // set up the method viewDidLoad
    private func setUpViewDidLoad() {
        // Layout 2 by default : Button2 selected and Layout2 apply in the CollectionView
        self.deselectAllButtons()
        self.button2.isSelected = true
        self.layoutSelected = .layout2

        // dataSource and delegate refer to itself (ViewController class)
        layoutCollectionView.dataSource = self
        layoutCollectionView.delegate = self

        /// SWIPE ORIENTATION : determine the orientation
        orientation(isLandscape: landscapeOrientation())

        // Solution 2 : Add space between CollectionView cells
        let spacing: CGFloat = 15
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.layoutCollectionView?.collectionViewLayout = layout
    }

    /// SWIPE ORIENTATION : determine if screen width is bigger than screen height --> landscape
    private func landscapeOrientation() -> Bool {
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            return true
        } else {
            return false
        }
    }

    /// SWIPE ORIENTATION : Adjust swipe direction according to the screen orientation
    private func orientation(isLandscape: Bool) {
        if isLandscape {
            self.swipeText.text = "Swipe left to share"
            self.swipeGesture.direction = .left
        } else {
            self.swipeText.text = "Swipe up to share"
            self.swipeGesture.direction = .up
        }
    }

// MARK: Buttons IBAction to choose the layout
    /// LAYOUT : Selection of the layout after press button
    @IBAction func Button1(_ sender: UIButton) {
        // All buttons state : deselected
        deselectAllButtons()
        // Button1 state : selected
        button1.isSelected = true
        // Layout selected = layout1
        layoutSelected = .layout1
        // Actualise
        layoutCollectionView.reloadData()
    }

    @IBAction func Button2(_ sender: UIButton) {
        deselectAllButtons()
        button2.isSelected = true
        layoutSelected = .layout2
        layoutCollectionView.reloadData()
    }

    @IBAction func Button3(_ sender: UIButton) {
        deselectAllButtons()
        button3.isSelected = true
        layoutSelected = .layout3
        layoutCollectionView.reloadData()
    }

    private func deselectAllButtons() {
        // All buttons state : deselected
        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = false
    }

// MARK: Swipe IBAction to share
    /// SWIPE : Share the image
    @IBAction func SwipeToShare(_ sender: UISwipeGestureRecognizer) {
        // Tranform the CollectionView to an image
        let layoutToShare = self.layoutCollectionView.asImage()

        // Animation
        UIView.animate(withDuration: 0.75, animations: {
            // If orientation is Portrait : CollectionView sent up
            if UIDevice.current.orientation.isPortrait ||  self.landscapeOrientation() == false {
                self.collectionViewPortraitConstraint.constant = -700
            // If orientation is Landscape : : CollectionView sent left
            }else{
                self.collectionViewLandscapeConstraint.constant = -700
            }

            // CollectionView reduced and disappear
            self.layoutCollectionView.layer.opacity = 0
//            self.LayoutCollectionView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            // Permit to apply the duration to the animation
            self.view.layoutIfNeeded()

            // Go back to the view before the Animation
        }, completion: { (finished) in
            let activityController = UIActivityViewController(activityItems: [layoutToShare], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (type,completed,items,error) in

                // CollectionView go back to initial position (even if the orientation change during the animation)
                self.collectionViewPortraitConstraint.constant = 0
                self.collectionViewLandscapeConstraint.constant = 0
                self.layoutCollectionView.reloadData()

                // CollectionView reappear and recover initial size (same duration)
                UIView.animate(withDuration: 0.75) {
                    self.layoutCollectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.layoutCollectionView.layer.opacity = 1
                    self.view.layoutIfNeeded()
                }
            }

            // The activity controller appear (to send or save the image)
            self.present(activityController, animated: true, completion: nil)
        })
    }
    
// MARK: viewWillTransition
    /// SWIPE : Change the swipe direction if the orientation is modified
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setUpViewWillTransition()
    }

    // set up the method viewWillTransition
    private func setUpViewWillTransition(){
        self.layoutCollectionView.reloadData()

        // If orientation is Landscape : Swipe Gesture to left and text changed
        if UIDevice.current.orientation.isLandscape {
            self.swipeGesture.direction = .left
            self.swipeText.text = "Swipe left to share"

            // If orientation is Portrait : Swipe Gesture to up and text changed
        } else {
            self.swipeGesture.direction = .up
            self.swipeText.text = "Swipe up to share"
        }
    }
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    /// LAYOUT : Enum of the 3  layouts
    enum Layouts {
        case layout1
        case layout2
        case layout3

        // Number of cells by Layout
        func getCellNumber () -> Int{
            switch self {
            case .layout1, .layout2 :
                return 3
            case .layout3 :
                return 4
            }
        }
    }

    /// COLLECTIONVIEW  : found and apply the  number of cells (according to the layout selected) to the CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutSelected.getCellNumber()
    }

    /// COLLECTIONVIEW  :  Show the image saved in the table and hide the "+"
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


}

// MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /// COLLECTIONVIEW : Open image gallery when clic on a cell of the CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        imgController.allowsEditing = true
        self.present(imgController, animated: true, completion: nil)
    }

    /// COLLECTIONVIEW : Apply the size to each cells according to the layout selected
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // Size cells :
        let spacingBetweenCells:CGFloat = 15
        let fullSize = collectionView.frame.size.width - spacingBetweenCells * 2
        let halfSize = collectionView.frame.size.width / 2 - spacingBetweenCells * 1.5

        switch layoutSelected {
        case .layout1  :
            if indexPath.item == 0 {
                // Apply to the first cell : width  = full size of the CollectionView
                return CGSize.init(width: fullSize, height: halfSize)
            } else {
                // Apply to other cells : width  = demi size of the CollectionView
                return CGSize.init(width: halfSize, height: halfSize)
            }
        case .layout2 :
            if indexPath.item == 2 {
                // Apply to the third cell : width  = full size of the CollectionView
                return CGSize.init(width: fullSize, height: halfSize)
            } else {
                // Apply to other cells : width  = demi size of the CollectionView
                return CGSize.init(width: halfSize, height: halfSize)
            }
        case .layout3 :
            // Apply to all cells : width  = demi size of the CollectionView
            return CGSize.init(width: halfSize, height: halfSize)
        }
    }
}

// MARK: imagePickerController
extension ViewController: UIImagePickerControllerDelegate  {
    /// IMAGE PICKER : Choose image from gallery and add to the table
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = img
        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = img
        }
        self.imagesSelected[indexPath?.item ?? 0] = image
        picker.dismiss(animated: true) {
            self.layoutCollectionView.reloadData()
        }
    }
}
