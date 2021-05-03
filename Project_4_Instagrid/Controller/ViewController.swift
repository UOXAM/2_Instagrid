//
//  ViewController.swift
//  Project_4_Instagrid
//
//  Created by ROUX Maxime on 05/03/2021.
//

import UIKit

/// EXTENSION UIView : Allow to transform CollectionView to UIImage
extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var swipeText: UILabel!

    @IBOutlet weak var LayoutCollectionView: UICollectionView!

    @IBOutlet weak var CollectionViewLandscapeConstraint: NSLayoutConstraint!
    @IBOutlet weak var CollectionViewPortraitConstraint: NSLayoutConstraint!

    @IBOutlet var SwipeGesture: UISwipeGestureRecognizer!

    // Layout by default
    var layoutSelected : Layouts = .layout2
    // Table of images (empty)
    var imagesSelected : [UIImage?] = [nil, nil, nil, nil]
    // Image index
    var indexPath : IndexPath?

    // viewDidLoad : Called after the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Layout 2 by default : Button2 selected and Layout2 apply in the CollectionView
        self.deselectAllButtons()
        self.Button2.isSelected = true
        self.layoutSelected = .layout2

        // dataSource and delegate refer to itself (ViewController class)
        LayoutCollectionView.dataSource = self
        LayoutCollectionView.delegate = self

        /// SWIPE ORIENTATION : determine the orientation
        orientation(isLandscape: landscapeOrientation())

        // Solution 2 : Add space between CollectionView cells
        let spacing: CGFloat = 15
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.LayoutCollectionView?.collectionViewLayout = layout
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
            self.SwipeGesture.direction = .left
        } else {
            self.swipeText.text = "Swipe up to share"
            self.SwipeGesture.direction = .up
        }
    }

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

    /// LAYOUT : Selection of the layout after press button
    @IBAction func Button1(_ sender: UIButton) {
        // All buttons state : deselected
        deselectAllButtons()
        // Button1 state : selected
        Button1.isSelected = true
        // Layout selected = layout1
        layoutSelected = .layout1
        // Actualise
        LayoutCollectionView.reloadData()
    }

    @IBAction func Button2(_ sender: UIButton) {
        deselectAllButtons()
        Button2.isSelected = true
        layoutSelected = .layout2
        LayoutCollectionView.reloadData()
    }

    @IBAction func Button3(_ sender: UIButton) {
        deselectAllButtons()
        Button3.isSelected = true
        layoutSelected = .layout3
        LayoutCollectionView.reloadData()
    }

    private func deselectAllButtons() {
        // All buttons state : deselected
        Button1.isSelected = false
        Button2.isSelected = false
        Button3.isSelected = false
    }

    /// COLLECTIONVIEW  : found and apply the  number of cells (according to the layout selected) to the CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutSelected.getCellNumber()
    }

    /// COLLECTIONVIEW : Open image gallery when clic on a cell of the CollectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        imgController.allowsEditing = true
        self.present(imgController, animated: true, completion: nil)
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

    /// SWIPE : Share the image
    @IBAction func SwipeToShare(_ sender: UISwipeGestureRecognizer) {
        // Tranform the CollectionView to an image
        let layoutToShare = self.LayoutCollectionView.asImage()

        // Animation
        UIView.animate(withDuration: 0.75, animations: {
            // If orientation is Portrait : CollectionView sent up
            if UIDevice.current.orientation.isPortrait ||  self.landscapeOrientation() == false {
                self.CollectionViewPortraitConstraint.constant = -700
            // If orientation is Landscape : : CollectionView sent left
            }else{
                self.CollectionViewLandscapeConstraint.constant = -700
            }

            // CollectionView reduced and disappear
            self.LayoutCollectionView.layer.opacity = 0
//            self.LayoutCollectionView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            // Permit to apply the duration to the animation
            self.view.layoutIfNeeded()

            // Go back to the view before the Animation
        }, completion: { (finished) in
            let activityController = UIActivityViewController(activityItems: [layoutToShare], applicationActivities: nil)
            activityController.completionWithItemsHandler = { (type,completed,items,error) in

                // CollectionView go back to initial position (even if the orientation change during the animation)
                self.CollectionViewPortraitConstraint.constant = 0
                self.CollectionViewLandscapeConstraint.constant = 0
                self.LayoutCollectionView.reloadData()

                // CollectionView reappear and recover initial size (same duration)
                UIView.animate(withDuration: 0.75) {
                    self.LayoutCollectionView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.LayoutCollectionView.layer.opacity = 1
                    self.view.layoutIfNeeded()
                }
            }

            // The activity controller appear (to send or save the image)
            self.present(activityController, animated: true, completion: nil)
        })
    }

    /// SWIPE : Change the swipe direction if the orientation is modified
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.LayoutCollectionView.reloadData()

        // If orientation is Landscape : Swipe Gesture to left and text changed
        if UIDevice.current.orientation.isLandscape {
            self.SwipeGesture.direction = .left
            self.swipeText.text = "Swipe left to share"

            // If orientation is Portrait : Swipe Gesture to up and text changed
        } else {
            self.SwipeGesture.direction = .up
            self.swipeText.text = "Swipe up to share"
        }
    }

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
            self.LayoutCollectionView.reloadData()
        }
    }
}
