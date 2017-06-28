/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/


import UIKit

// GLOBAL VARIABLES FOR COLLAGE FRAMES
var collageFrameNr = 0
var imageTAG = -1




class MainScreen: UIViewController,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
{
 
    /* Views */
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet var buttons: [UIButton]!
    
    
    
// HIDE STATUS BAR
override var prefersStatusBarHidden : Bool {
        return true
}
func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        UIApplication.shared.isStatusBarHidden = true
}
    
// MARK: - VIEW DID LOAD
override func viewDidLoad() {
        super.viewDidLoad()
    
    imageTAG = -1
    
    containerView.center = view.center
    
    // Round views corners
    logoImg.layer.cornerRadius = 20
    
    for butt in buttons {
        butt.frame.origin.x = view.frame.size.width
        butt.layer.cornerRadius = 6
        butt.layer.shadowColor = UIColor.darkGray.cgColor
        butt.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        butt.layer.shadowOpacity = 0.2
        butt.layer.shadowRadius = 0.1
    }
    
    
    // Animate logo and buttons
    UIView.animate(withDuration: 0.3, delay: 1.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
        self.logoImg.frame.origin.x = 0 - self.logoImg.frame.size.width/2
    }, completion: { (finished: Bool) in
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            for butt in self.buttons {
                butt.center.x = self.view.center.x
            }
        }, completion: { (finished: Bool) in  })
    })
    
}

    
    
// MARK: - OPEN CAMERA BUTTON
@IBAction func camButt(_ sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
}
    
// MARK: - OPEN PHOTO LUBRARY BUTTON
@IBAction func libraryButt(_ sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }

}

// MARK: - ImagePicker delegate
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        pickedImage = image
        dismiss(animated: false, completion: nil)
        
        // go to Crop Image Controller to apply text to the picked image
        goToCropImage()
}

    
// MARK: - GO TO CROP IMAGE CONTROLLER
func goToCropImage() {
    let ciVC = self.storyboard?.instantiateViewController(withIdentifier: "CropImage") as! CropImage
    ciVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    present(ciVC, animated: true, completion: nil)
}
    
    
    
    
// MARK: - OPEN YOUR INSTAGRAM CHANNEL
// (you need to set your own Instagram Account and replace "photolabapp" with your username */
@IBAction func inspirationsButt(_ sender: AnyObject) {
    let instaWeb = URL(string: "http://instagram.com/\(INSTAGRAM_USERNAME)")
    let instaApp = URL(string: "instagram://user?username=\(INSTAGRAM_USERNAME)")
 
    if UIApplication.shared.canOpenURL(instaApp!) { UIApplication.shared.openURL(instaApp!)
    } else { UIApplication.shared.openURL(instaWeb!) }
}

    
    
    
// MARK: - OPEN SETTINGS BUTTON
@IBAction func settingsButt(_ sender: AnyObject) {
     let settVC = self.storyboard?.instantiateViewController(withIdentifier: "Settings") as! Settings
    
    if UIDevice.current.userInterfaceIdiom == .pad { // iPad
        let popOver = UIPopoverController(contentViewController: settVC)
        settVC.preferredContentSize = CGSize(width: view.frame.size.width-320, height: view.frame.size.height-450)
        popOver.present(from: CGRect(x: 400, y: 400, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection(), animated: true)
    } else { // iPhone
        settVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(settVC, animated: true, completion: nil)
    }

}

    
    
    
// MARK: - COLLAGE BUTTON
@IBAction func collageButt(_ sender: AnyObject) {
    let collVC = self.storyboard?.instantiateViewController(withIdentifier: "Collage") as! Collage
    collVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    present(collVC, animated: true, completion: nil)
}
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}

} 


