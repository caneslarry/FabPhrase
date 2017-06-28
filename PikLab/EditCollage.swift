/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/


import UIKit

/* GOLBAL IMAGES FOR COLLAGE */
var image1: UIImage?
var image2: UIImage?
var image3: UIImage?
var image4: UIImage?


class EditCollage: UIViewController,
UIScrollViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate
{

   /* Views */
    @IBOutlet var containerView: UIView!
    
    let hud = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

    /* Variables */
    var scroll1: UIScrollView?
    var scroll2: UIScrollView?
    var scroll3: UIScrollView?
    var scroll4: UIScrollView?
    
    var imageView1: UIImageView?
    var imageView2: UIImageView?
    var imageView3: UIImageView?
    var imageView4: UIImageView?
        
    var image1DTG: UITapGestureRecognizer?
    var image2DTG: UITapGestureRecognizer?
    var image3DTG: UITapGestureRecognizer?
    var image4DTG: UITapGestureRecognizer?
    
    
    
    
// Hide the status bar
override var prefersStatusBarHidden : Bool {
    return true;
}
    
override func viewWillAppear(_ animated: Bool) {
    // Get images previously cropped
    imageView1?.image = image1
    imageView2?.image = image2
    imageView3?.image = image3
    imageView4?.image = image4
    
    
    /*
    // CONSOLE LOGS ======================================
    println("imageTAG (on EditCollageVC): \(imageTAG)")
    println("image1: \(image1)")
    println("image2: \(image2)")
    println("image3: \(image3)")
    println("image4: \(image4)")
    println("collageFrame: \(collageFrameNr)")
    */
}
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    // Initialize ScrollViews
    scroll1 = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    scroll1?.delegate = self
    scroll1?.showsHorizontalScrollIndicator = false
    scroll1?.showsVerticalScrollIndicator = false
    scroll1?.minimumZoomScale = 1
    scroll1?.maximumZoomScale = 3
    scroll1?.clipsToBounds = true
    scroll1?.isScrollEnabled = true
    scroll1?.layer.borderColor = UIColor.white.cgColor
    scroll1?.layer.borderWidth = 1
    scroll1?.contentSize = CGSize(width: 320, height: 320)
    imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
    imageView1?.isUserInteractionEnabled = true
    imageView1?.isMultipleTouchEnabled = true
    
    scroll2 = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    scroll2?.delegate = self
    scroll2?.showsHorizontalScrollIndicator = false
    scroll2?.showsVerticalScrollIndicator = false
    scroll2?.minimumZoomScale = 1
    scroll2?.maximumZoomScale = 3
    scroll2?.clipsToBounds = true
    scroll2?.isScrollEnabled = true
    scroll2?.layer.borderColor = UIColor.white.cgColor
    scroll2?.layer.borderWidth = 1
    scroll2?.contentSize = CGSize(width: 320, height: 320)
    imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
    imageView2?.isUserInteractionEnabled = true
    imageView2?.isMultipleTouchEnabled = true
    
    scroll3 = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    scroll3?.delegate = self
    scroll3?.showsHorizontalScrollIndicator = false
    scroll3?.showsVerticalScrollIndicator = false
    scroll3?.minimumZoomScale = 1
    scroll3?.maximumZoomScale = 3
    scroll3?.clipsToBounds = true
    scroll3?.isScrollEnabled = true
    scroll3?.layer.borderColor = UIColor.white.cgColor
    scroll3?.layer.borderWidth = 1
    scroll3?.contentSize = CGSize(width: 320, height: 320)
    imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
    imageView3?.isUserInteractionEnabled = true
    imageView3?.isMultipleTouchEnabled = true
    
    scroll4 = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    scroll4?.delegate = self
    scroll4?.showsHorizontalScrollIndicator = false
    scroll4?.showsVerticalScrollIndicator = false
    scroll4?.minimumZoomScale = 1
    scroll4?.maximumZoomScale = 3
    scroll4?.clipsToBounds = true
    scroll4?.isScrollEnabled = true
    scroll4?.layer.borderColor = UIColor.white.cgColor
    scroll4?.layer.borderWidth = 1
    scroll4?.contentSize = CGSize(width: 320, height: 320)
    imageView4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
    imageView4?.isUserInteractionEnabled = true
    imageView4?.isMultipleTouchEnabled = true
    
    
    // Setup scrollViews
    addScrollViews()
}


    
    
    
    
// MARK: - ADD SCROLLVIEWS AS COLLAGE FRAMES INTO THE CONTAINER VIEW
func addScrollViews() {
    switch collageFrameNr {
    
    case 0:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 160, height: 320)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)

        scroll2?.frame = CGRect(x: 160, y: 0, width: 160, height: 320)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        break
        
    case 1:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 320, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 0, y: 160, width: 320, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        break
        
    case 2:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 160, y: 0, width: 160, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 0, y: 160, width: 320, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        break
       
    case 3:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 320, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 0, y: 160, width: 160, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 160, y: 160, width: 160, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        break
      
    case 4:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 160, height: 320)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 160, y: 0, width: 160, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 160, y: 160, width: 160, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        break
        
    case 5:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 160, y: 0, width: 160, height: 320)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 0, y: 160, width: 160, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        break
      
    case 6:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 106.6, height: 320)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 106.6, y: 0, width: 106.6, height: 320)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 213.3, y: 0, width: 106.6, height: 320)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        break
        
    case 7:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 320, height: 106.6)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 0, y: 106.6, width: 320, height: 106.6)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 0, y: 213.3, width: 320, height: 106.6)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        break
        
    case 8:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 160, y: 0, width: 160, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 0, y: 160, width: 160, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        
        scroll4?.frame = CGRect(x: 160, y: 160, width: 160, height: 160)
        scroll4?.addSubview(imageView4!)
        containerView.addSubview(scroll4!)
        break
        
    case 9:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 120, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 120, y: 0, width: 200, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 0, y: 160, width: 200, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        
        scroll4?.frame = CGRect(x: 200, y: 160, width: 120, height: 160)
        scroll4?.addSubview(imageView4!)
        containerView.addSubview(scroll4!)
        break
        
    case 10:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 106.6, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 106.6, y: 0, width: 106.6, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 213.3, y: 0, width: 106.6, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        
        scroll4?.frame = CGRect(x: 0, y: 160, width: 320, height: 160)
        scroll4?.addSubview(imageView4!)
        containerView.addSubview(scroll4!)
        break
   
    case 11:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 320, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 0, y: 160, width: 106.6, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 106.6, y: 160, width: 106.6, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        
        scroll4?.frame = CGRect(x: 213.3, y: 160, width: 106.6, height: 160)
        scroll4?.addSubview(imageView4!)
        containerView.addSubview(scroll4!)
        break
       
    case 12:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        containerView.bringSubview(toFront: scroll1!)
        break
       
    case 13:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 160, y: 160, width: 160, height: 160)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        containerView.bringSubview(toFront: scroll2!)
        break
     
    case 14:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 140, height: 160)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 180, y: 160, width: 140, height: 160)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        
        containerView.bringSubview(toFront: scroll1!)
        containerView.bringSubview(toFront: scroll3!)
        break
     
    case 15:
        scroll1?.frame = CGRect(x: 0, y: 0, width: 120, height: 140)
        scroll1?.addSubview(imageView1!)
        containerView.addSubview(scroll1!)
        
        scroll2?.frame = CGRect(x: 0, y: 0, width: 320, height: 320)
        scroll2?.addSubview(imageView2!)
        containerView.addSubview(scroll2!)
        
        scroll3?.frame = CGRect(x: 200, y: 0, width: 120, height: 140)
        scroll3?.addSubview(imageView3!)
        containerView.addSubview(scroll3!)
        
        scroll4?.frame = CGRect(x: 0, y: 180, width: 320, height: 140)
        scroll4?.addSubview(imageView4!)
        containerView.addSubview(scroll4!)
        
        containerView.bringSubview(toFront: scroll1!)
        containerView.bringSubview(toFront: scroll3!)
        containerView.bringSubview(toFront: scroll4!)
        break
        
        
        /* You can add new collage frames here... */
        
    default: break  }
    
    
    // Add Tap gesture Recognizer to the imageViews
    addTapGesturesToImages()
}
    

func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    var imageView = UIImageView()
    if scrollView == scroll1 {  imageView = imageView1! }
    if scrollView == scroll2 {  imageView = imageView2! }
    if scrollView == scroll3 {  imageView = imageView3! }
    if scrollView == scroll4 {  imageView = imageView4! }
    return imageView
}


func addTapGesturesToImages() {
    image1DTG = UITapGestureRecognizer(target: self, action: #selector(image1Tapped(_:)))
    image1DTG?.numberOfTapsRequired = 2
    image1DTG?.numberOfTouchesRequired = 1
    imageView1!.addGestureRecognizer(image1DTG!)

    image2DTG = UITapGestureRecognizer(target: self, action: #selector(image2Tapped(_:)))
    image2DTG?.numberOfTapsRequired = 2
    image2DTG?.numberOfTouchesRequired = 1
    imageView2!.addGestureRecognizer(image2DTG!)
    
    image3DTG = UITapGestureRecognizer(target: self, action: #selector(image3Tapped(_:)))
    image3DTG?.numberOfTapsRequired = 2
    image3DTG?.numberOfTouchesRequired = 1
    imageView3!.addGestureRecognizer(image3DTG!)
    
    image4DTG = UITapGestureRecognizer(target: self, action: #selector(image4Tapped(_:)))
    image4DTG?.numberOfTapsRequired = 2
    image4DTG?.numberOfTouchesRequired = 1
    imageView4!.addGestureRecognizer(image4DTG!)
}

    

    
    
// TAP GESTURES ON IMAGES ==================================
@objc func image1Tapped(_ recognizer: UITapGestureRecognizer) {
    imageTAG = 0
    openAlertView()
}
@objc func image2Tapped(_ recognizer: UITapGestureRecognizer) {
    imageTAG = 1
    openAlertView()
}
@objc func image3Tapped(_ recognizer: UITapGestureRecognizer) {
    imageTAG = 2
    openAlertView()
}
@objc func image4Tapped(_ recognizer: UITapGestureRecognizer) {
    imageTAG = 3
    openAlertView()
}
    
func openAlertView() {
    let alert = UIAlertView(title: APP_NAME,
    message: "Select where to get your image",
    delegate: self,
    cancelButtonTitle: "Cancel",
    otherButtonTitles: "Camera", "Library")
    alert.show()
}
// AlertView delegate =================
func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
    
    if alertView.buttonTitle(at: buttonIndex) == "Camera" {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }

 
    } else if alertView.buttonTitle(at: buttonIndex) == "Library" {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}
    
// IMAGE PICKER DELEGATE
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
    
    pickedImage = image

    dismiss(animated: true, completion: {
        let ciVC = self.storyboard?.instantiateViewController(withIdentifier: "CropImage") as! CropImage
        self.present(ciVC, animated: true, completion: nil)
    })
}


    
// MARK: - CHANGE COLLAGE FRAME WIDTH 
@IBAction func collageFrameSizeChanged(_ sender: UISlider) {
    scroll1?.layer.borderWidth = CGFloat(sender.value)
    scroll2?.layer.borderWidth = CGFloat(sender.value)
    scroll3?.layer.borderWidth = CGFloat(sender.value)
    scroll4?.layer.borderWidth = CGFloat(sender.value)
}
    
    
    
// MARK: - CROP IMAGE BUTTON =================================
@IBAction func cropImage(_ sender: AnyObject) {
    UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, true, 0.0)
    containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: false)
    croppedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    showHUD()
    Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(goToImageEditor), userInfo: nil, repeats: false)
}
@objc func goToImageEditor() {
    let ieVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditor") as! ImageEditor
    ieVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    
    // Remove all images
    image1 = nil; image2 = nil; image3 = nil;  image4 = nil
    
    present(ieVC, animated: true, completion: nil)
}
    
    
    
// MARK: - BACK BUTTON
@IBAction func backButt(_ sender: AnyObject) {
    imageTAG = -1
    image1 = nil
    image2 = nil
    image3 = nil
    image4 = nil
}


    
// MARK: - SHOW HUD
func showHUD() {
    hud.activityIndicatorViewStyle = .white
    hud.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
    hud.backgroundColor = UIColor.darkGray
    hud.layer.cornerRadius = hud.bounds.size.width/2
    hud.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
    view.addSubview(hud)
    hud.startAnimating()
}

    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}
