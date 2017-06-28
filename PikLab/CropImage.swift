/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/

import UIKit
import CoreImage


class CropImage: UIViewController,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
{
    
    
    /* Views */
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var cropBkg: UIImageView!
    @IBOutlet weak var imageToBeCropped: UIImageView!
    
    @IBOutlet weak var selectBKGLabel: UILabel!
    @IBOutlet weak var bkgScrollView: UIScrollView!
    
    @IBOutlet weak var addPhotoOutlet: UIButton!

    
    
    
// HIDE STATUS BAR
override var prefersStatusBarHidden : Bool {
        return true
}
func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
}
    
    
override func viewDidLoad() {
        super.viewDidLoad()
        
    // Set picked image
    imageToBeCropped.image = pickedImage
        
    // Round views corners
    addPhotoOutlet.layer.cornerRadius = addPhotoOutlet.bounds.width/2
    
    
    // Resize Views accordingly to the device used
    cropView.frame = CGRect(x: 0, y: 44, width: view.frame.size.width, height: view.frame.size.width)
    selectBKGLabel.frame.origin.y = cropView.frame.size.height + 44
    bkgScrollView.frame.origin.y = cropView.frame.size.height + 88

    
    // Set size for ScrollView of bkg thumbnails
    bkgScrollView.contentSize = CGSize(width: 70*9, height: bkgScrollView.frame.size.height)
}
    
    
// MARK: - CROP IMAGE BUTTON
@IBAction func okCropButt(_ sender: AnyObject) {
    // Crop the image into the square CropView
    UIGraphicsBeginImageContextWithOptions(cropView.bounds.size, true, 0.0)
    cropView.drawHierarchy(in: cropView.bounds, afterScreenUpdates: false)
    croppedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    
    if imageTAG > -1 {
      switch imageTAG {
        case 0:  image1 = croppedImage;  break
        case 1:  image2 = croppedImage;  break
        case 2:  image3 = croppedImage;  break
        case 3:  image4 = croppedImage;  break
      default:break  }
        
        // Go to Edit Collage VC
        let ecVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCollage") as! EditCollage
        ecVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(ecVC, animated: true, completion: nil)
        
    
    // Go to Image Editor
    } else {
        let ieVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditor") as! ImageEditor
        ieVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(ieVC, animated: true, completion: nil)
    }
    
}
    
    
    
    
// MARK: - CHANGE BKG BUTTON
@IBAction func bkgButt(_ sender: AnyObject) {
    let button = sender as! UIButton
    let buttImage = button.backgroundImage(for: UIControlState())
    
    cropBkg.image = buttImage!
}

    
// MARK: - PICK AN IMAGE FROM LIBRARY (TO ASSIGN IT AS A NEW BKG)
@IBAction func addPhotoAsBkgButt(_ sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        present(imagePicker, animated: true, completion: nil)
    }
}
// ImagePicker Delegate
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
    
    cropBkg.image = image
    dismiss(animated: false, completion: nil)
}
    
    

// MARK: - ZOOM IMAGE WITH PINCH GESTURES
    @IBAction func zoomImage(_ sender: UIPinchGestureRecognizer) {
        sender.view?.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
}
 
// MARK: - MOVE IMAGE WITH PAN GESTURE
    @IBAction func moveImage(_ sender: UIPanGestureRecognizer) {
        let translation: CGPoint =  sender.translation(in: self.view)
        sender.view?.center = CGPoint(x: sender.view!.center.x +  translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
}
    
    
   
@IBAction func rotateImage(_ sender: UIRotationGestureRecognizer) {
    if sender.state == UIGestureRecognizerState.began ||
        sender.state == UIGestureRecognizerState.changed
    {
        sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
}
    
    
    

    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  }
}

