/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/

import UIKit
import GoogleMobileAds
import AudioToolbox
import CoreImage



class ImageEditor: UIViewController,
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
UITextViewDelegate,
GADInterstitialDelegate
{
    
    /* Views */
    @IBOutlet weak var toolbarView: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var originalImage: UIImageView!
    
    @IBOutlet weak var buttonsView: UIView!
    
    @IBOutlet weak var watermarkLabel: UILabel!
    
    // Keyboard Toolbar View
    var keyboardToolbar: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    // TextView for text
    @IBOutlet weak var txtView: UITextView!
    
    // Interstitial AdMob 
    var adMobInterstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)

    
    
    
    
// HIDE STATUS BAR
override var prefersStatusBarHidden : Bool {
        return true
}
    
   
// MARK: - VIEW DID LOAD
override func viewDidLoad() {
        super.viewDidLoad()
        
    // Get the cropped Image
    originalImage.image = croppedImage
        
    // Set the image for filters as the Original image
    imageForFilters.image = croppedImage
        
        
    // Resize Views accordingly to the device used
    containerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
    buttonsView.frame.origin.y = containerView.frame.size.height

    
    // Move the Tool Views out of the screen
    fontsView.frame.origin.y      = view.frame.size.height
    stickersView.frame.origin.y   = view.frame.size.height
    texturesView.frame.origin.y   = view.frame.size.height
    bordersView.frame.origin.y    = view.frame.size.height
    filtersView.frame.origin.y    = view.frame.size.height
    adjustmentView.frame.origin.y = view.frame.size.height
        
        
    // SETUP IMAGE EDITOR TOOLS:
    DispatchQueue.main.async(execute: {
        self.setupTextTool()
        self.setupStickersTool()
        self.setupTexturesTool()
        self.setupBordersTool()
        self.setupFiltersTool()
    })
    
    
        
    // Call AdMob Interstitial
    let delayTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    adMobInterstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
    adMobInterstitial.load(GADRequest())
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        self.showInterstitial()
    }
}
    
    
// MARK - ADMOB INTERSTITIAL
func showInterstitial() {
    // Show AdMob interstitial
    if adMobInterstitial.isReady {
        adMobInterstitial.present(fromRootViewController: self)
        print("present Interstitial")
    }
}
    
   
    

    
// MARK: -  CANCEL EDITING BUTTON
@IBAction func cancelButt(_ sender: AnyObject) {
    let alert = UIAlertView(title: APP_NAME,
        message: "Are you sure you want to exit? \nYou'll lose all the changes you've made so far",
        delegate: self,
        cancelButtonTitle: "No",
        otherButtonTitles: "Exit")
        alert.show()
}
// AlertView delegate
func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.buttonTitle(at: buttonIndex) == "Exit" {
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainScreen") as! MainScreen
            mainVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            present(mainVC, animated: true, completion: nil)
        }
}
    
    
    
// MARK: - SAVE IMAGE BUTTON
@IBAction func saveImageButt(_ sender: AnyObject) {
    renderEditedImage()
    
    let shareVC = self.storyboard?.instantiateViewController(withIdentifier: "SharingController") as! SharingController
    
    if UIDevice.current.userInterfaceIdiom == .pad { // iPad
        let popOver = UIPopoverController(contentViewController: shareVC)
        shareVC.preferredContentSize = CGSize(width: view.frame.size.width-320, height: view.frame.size.height-450)
        popOver.present(from: CGRect(x: 400, y: 400, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection(), animated: true)
    } else { // iPhone
        shareVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(shareVC, animated: true, completion: nil)
    }
    
}
    

// MARK: -  RENDER THE EDITED IMAGE
func renderEditedImage() {
    UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, true, 0.0)
    containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: false)
    editedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
}
    
   
// MARK: - SETTINGS BUTTON
@IBAction func settingsButt(_ sender: AnyObject) {
    let settVC = self.storyboard?.instantiateViewController(withIdentifier: "Settings") as! Settings
    
    if UIDevice.current.userInterfaceIdiom == .pad { // iPad
        let popOver = UIPopoverController(contentViewController: settVC)
        settVC.preferredContentSize = CGSize(width: view.frame.size.width-320, height: view.frame.size.height-450)
        popOver.present(from: CGRect(x: 400, y: 400, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection(), animated: true)
    } else { // iPhone
        present(settVC, animated: true, completion: nil)
    }
    

}
    
    
/* TOOL BUTTONS ======*/
    @IBAction func textToolButt(_ sender: AnyObject) {
        showFontsView()
    }
    @IBAction func stickersToolButt(_ sender: AnyObject) {
        showStickersView()
    }
    @IBAction func texturesToolButt(_ sender: AnyObject) {
        showTexturesView()
    }
    @IBAction func bordersToolButt(_ sender: AnyObject) {
        showBordersView()
    }
    @IBAction func filtersToolButt(_ sender: AnyObject) {
        showFiltersView()
    }
    
    @IBAction func adjustmentButt(_ sender: AnyObject) {
        showAdjustmentView()
        hideAdjustmentSliders()
    }
    // Hide Adjustment Sliders when they're not used
    func hideAdjustmentSliders() {
        brightnessSlider.isHidden = true
        contrastSlider.isHidden = true
        saturationSlider.isHidden = true
        exposureSlider.isHidden = true
        brightnessOutlet.backgroundColor = lightBlack
        contrastOutlet.backgroundColor = lightBlack
        saturationOutlet.backgroundColor = lightBlack
        exposureOutlet.backgroundColor = lightBlack
        
    }
    
    

    
    
    
// MARK: -  TEXT TOOL -----------------
    
    /*Variables */
    var textIsVisible = true
    
    /* Views */
    @IBOutlet weak var fontsView: UIView!
    @IBOutlet weak var fontsTableView: UITableView!
    @IBOutlet weak var opacityFontSlider: UISlider!
    
    // Colors ScrollView
    var colorScrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var colorButt: UIButton?
    var colorTag = 0
    
    
    
  
func setupTextTool() {
        
        // TxtView settings
        txtView.delegate = self
        txtView.inputAccessoryView = keyboardToolbar
        
        
        // Keyboard Toolbar settings
        keyboardToolbar.backgroundColor = UIColor(red: 31.0/255.0, green: 37.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        keyboardToolbar.autoresizingMask = UIViewAutoresizing.flexibleWidth
        keyboardToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        
        
        // LEFT Alignment button
        let leftButt: UIButton = UIButton(type: UIButtonType.custom)
        leftButt.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        leftButt.setBackgroundImage(UIImage(named: "left"), for: UIControlState())
        leftButt.addTarget(self, action: #selector(leftTapped(_:)), for: UIControlEvents.touchUpInside)
        keyboardToolbar.addSubview(leftButt)
        
        // CENTER Alignment button
        let centerButt: UIButton = UIButton(type: UIButtonType.custom)
        centerButt.frame = CGRect(x: leftButt.frame.origin.x+54, y: 0, width: 44, height: 44)
        centerButt.setBackgroundImage(UIImage(named: "center"), for: UIControlState())
        centerButt.addTarget(self, action: #selector(centerTapped(_:)), for: UIControlEvents.touchUpInside)
        keyboardToolbar.addSubview(centerButt)
        
        // RIGHT Alignment button
        let rightButt: UIButton = UIButton(type: UIButtonType.custom)
        rightButt.frame = CGRect(x: centerButt.frame.origin.x+54, y: 0, width: 44, height: 44)
        rightButt.setBackgroundImage(UIImage(named: "right"), for: UIControlState())
        rightButt.addTarget(self, action: #selector(rightTapped(_:)), for: UIControlEvents.touchUpInside)
        keyboardToolbar.addSubview(rightButt)
        
        // COLORS ScrollView (to color the text)
        colorScrollView.frame = CGRect(x: rightButt.frame.origin.x+54, y: 0, width: keyboardToolbar.frame.size.width - 142 - 58, height: 44)
        colorScrollView.backgroundColor = UIColor.clear
        colorScrollView.isUserInteractionEnabled = true
        colorScrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        keyboardToolbar.addSubview(colorScrollView)
        
        
        // DISMISS KEYBOARD button
        let dismissButt: UIButton = UIButton(type: UIButtonType.custom)
        dismissButt.frame = CGRect(x: keyboardToolbar.frame.size.width-44, y: 0, width: 44, height: 44)
        dismissButt.setBackgroundImage(UIImage(named: "okCropButt"), for: UIControlState())
        dismissButt.addTarget(self, action: #selector(dismissKeyboard(_:)), for: UIControlEvents.touchUpInside)
        keyboardToolbar.addSubview(dismissButt)
    
    
    
    // Resize fontsTableView
    fontsTableView.frame.size.height = 160
    
    // Setup Text Colors Menu
    setupTextColorsMenu()
}
    
    
    
    
    
// MARK: - FONTS TABLEVIEW DELEGATES
func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fontList.count
}
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"Cell")
    
        // Cell settings ========
        cell.contentView.backgroundColor = UIColor.black
        cell.textLabel!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        cell.textLabel!.textAlignment = NSTextAlignment.center
        cell.textLabel!.font = UIFont(name: fontList[(indexPath as NSIndexPath).row], size: 17)
        cell.textLabel!.textColor = UIColor.white
        cell.textLabel!.text = fontList[(indexPath as NSIndexPath).row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
return cell
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
}
    
// MARK: - FONT SELECTED
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    txtView.font = UIFont(name: fontList[(indexPath as NSIndexPath).row], size: 26)
}
    
    
    
    
// Show/Hide Text button
@IBOutlet weak var hideTxtOutlet: UIButton!
@IBAction func hideTxtButt(_ sender: AnyObject) {
        textIsVisible = !textIsVisible
        print("textVisible: \(textIsVisible)")
        
        if textIsVisible {
            txtView.isHidden = false
            hideTxtOutlet.setBackgroundImage(UIImage(named: "hideTxtButt"), for: UIControlState())
        } else {
            txtView.isHidden = true
            hideTxtOutlet.setBackgroundImage(UIImage(named: "showTxtButt"), for: UIControlState())
        }
}
    
@IBAction func dismissFontsButt(_ sender: AnyObject) {
    hideFontsView()
}
    
    
@IBAction func opacityFontChanged(_ sender: UISlider) {
    txtView.alpha = CGFloat(sender.value)
}
    
    
@objc func dismissKeyboard(_ sender: AnyObject) {
    txtView.resignFirstResponder()
}
    
    
    
    
// MARK: - SETUP TEXT COLORS MENU
func setupTextColorsMenu() {
    // Variables for setting the Color Buttons
    var xCoord: CGFloat = 0
    let yCoord: CGFloat = 8
    let buttonWidth:CGFloat = 40
    let buttonHeight: CGFloat = 28
    let gap: CGFloat = 0
    
        
    // Loop for creating buttons -------------------------------------------
    for colorsCount in 0..<colorList.count  {
            colorTag = colorsCount
            
            // Create a Button
            colorButt = UIButton(type: UIButtonType.custom)
            colorButt?.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            colorButt?.tag = colorTag
            colorButt?.backgroundColor = colorList[colorsCount]
            colorButt?.showsTouchWhenHighlighted = false
            colorButt?.addTarget(self, action: #selector(colorButtTapped(_:)), for: UIControlEvents.touchUpInside)
            
            xCoord +=  buttonWidth + gap
            colorScrollView.addSubview(colorButt!)
        
        
        // Place Buttons into the ScrollView
        colorScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(colorsCount) + buttonWidth, height: yCoord)
    
    } // END LOOP -------------------------------------------------
    
        
 
}
    
@objc func colorButtTapped(_ sender: AnyObject) {
    txtView.textColor = sender.backgroundColor
    resetTxtViewFrame()
}
    

// MARK: - ALIGNMENT BUTTONS
    @objc func leftTapped(_ sender: AnyObject) {
        txtView.textAlignment = NSTextAlignment.left
    }
    @objc func rightTapped(_ sender: AnyObject) {
        txtView.textAlignment = NSTextAlignment.right
    }
    @objc func centerTapped(_ sender: AnyObject) {
        txtView.textAlignment = NSTextAlignment.center
    }
    
    
    /* TEXT VIEW DELEGATES ============*/
    func textViewDidChange(_ textView: UITextView) {
        resetTxtViewFrame()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtView.text == "TAP TO EDIT TEXT" {
            txtView.text = ""
        }
        txtView.becomeFirstResponder()
        
        // Hide all Tool Views
        hideStickersView()
    }
    
    /* GESTURE RECOGNIZERS ON TEXT VIEW ========================*/
    @IBAction func scaleTxtView(_ sender: UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended ||
            sender.state == UIGestureRecognizerState.changed {
                let currentScale: CGFloat = CGFloat(txtView.frame.size.width / txtView.bounds.size.width)
                var newScale: CGFloat = CGFloat(currentScale * sender.scale)
                
                if newScale < 0.8 {
                    newScale = 0.8
                }
                if newScale > 1.3 {
                    newScale = 1.3
                }
                
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                // CGAffineTransform(scaleX: newScale, y: newScale);
                txtView.transform = transform
                sender.scale = 1
        }
    }
    
    @IBAction func moveTxtView(_ sender: UIPanGestureRecognizer) {
        let translation: CGPoint =  sender.translation(in: self.view)
        sender.view?.center = CGPoint(x: sender.view!.center.x +  translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    
    
    // Reset the TextView frame
    func resetTxtViewFrame() {
        let fixedWidth = CGFloat(txtView.frame.size.width)
        let maxFloat = CGFloat(MAXFLOAT)
        let newSize:CGSize = txtView.sizeThatFits(CGSize(width: fixedWidth, height: maxFloat))
        var newFrame:CGRect = txtView.frame
        newFrame.size = CGSize(width: fmax(newSize.width, fixedWidth), height: newSize.height)
        txtView.frame = newFrame
        
        print("txtFrame: \(newFrame)")
    }
    
    
/* Hide/Show Fonts View */
func showFontsView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.fontsView.frame.origin.y = self.buttonsView.frame.origin.y
        }, completion: { (finished: Bool) in
    })
}
func hideFontsView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.fontsView.frame.origin.y = self.view.frame.size.height
        }, completion: { (finished: Bool) in
    })
}

    
    
    
    
    
    
    
// MARK: - STICKERS TOOL ---------------------------------------------------------------------------
    
    /* Variables */
    var stickerTAG = 0
    
    /* VIEWS */
    @IBOutlet weak var stickersView: UIView!
    @IBOutlet weak var stickersScrollView: UIScrollView!
    var stickerButt: UIButton?
    
    
    
func setupStickersTool() {
        // Variables for setting the Font Buttons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 10
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 10
        
        // Loop for creating buttons
        for itemCount in 0..<11+1 {
            stickerTAG = itemCount
            
            // Create a Button for each Sticker
            stickerButt = UIButton(type: .custom)
            stickerButt?.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            stickerButt?.tag = stickerTAG
            stickerButt?.showsTouchWhenHighlighted = true
            stickerButt?.setImage(UIImage(named: "s\(stickerTAG)"), for: UIControlState())
            stickerButt?.setTitleColor(UIColor.white, for: UIControlState())
            stickerButt?.addTarget(self, action: #selector(stickerButtTapped(_:)), for: .touchUpInside)
            stickerButt?.layer.borderWidth = 1
            stickerButt?.layer.borderColor = UIColor.darkGray.cgColor
            // stickerButt?.layer.cornerRadius = 8
            stickerButt?.clipsToBounds = true
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            stickersScrollView.addSubview(stickerButt!)
            
            // Place Buttons into the ScrollView
            stickersScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount+2) + buttonWidth, height: yCoord)
            
        } // END LOOP
        
        
}
    
    var stickerImg: UIImageView?
    
    var stickersTAGArray = [Int]()
    var sndrTAG = 0
    
@objc func stickerButtTapped(_ sender: AnyObject) {
    let butt = sender as! UIButton
    
    sndrTAG = 100
    print("sndrTAG: \(sndrTAG)")
        
    stickerImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    stickerImg?.center = CGPoint(x: containerView.frame.size.width/2, y: containerView.frame.size.height/2)
    stickerImg?.backgroundColor = UIColor.clear
    stickerImg?.image = UIImage(named: "s\(butt.tag)")
    stickerImg?.tag = sndrTAG
    stickerImg?.isUserInteractionEnabled = true
    stickerImg?.isMultipleTouchEnabled = true
    containerView.addSubview(stickerImg!)
        
    // Add an array of stickers
    stickersTAGArray.append(stickerImg!.tag)
    print("stickersTAGArray:\(stickersTAGArray)")
        
        
        // Add PAN GESTURES to the sticker
        let panGestSticker = UIPanGestureRecognizer()
        panGestSticker.addTarget(self, action: #selector(moveSticker(_:)))
        stickerImg!.addGestureRecognizer(panGestSticker)
        
        // Add DOUBLE TAP GESTURES to the sticker
        let doubletapGestSticker = UITapGestureRecognizer()
        doubletapGestSticker.addTarget(self, action: #selector(deleteSticker(_:)))
        doubletapGestSticker.numberOfTapsRequired = 2
        stickerImg!.addGestureRecognizer(doubletapGestSticker)
        
        // Add PINCH GESTURES to the sticker
        let pinchGestSticker = UIPinchGestureRecognizer()
        pinchGestSticker.addTarget(self, action: #selector(zoomSticker(_:)))
        stickerImg!.addGestureRecognizer(pinchGestSticker)
        
        
        // Add ROTATION GESTURES to the sticker
        let rotationGestSticker = UIRotationGestureRecognizer()
        rotationGestSticker.addTarget(self, action: #selector(rotateSticker(_:)))
        stickerImg!.addGestureRecognizer(rotationGestSticker)
}
    
// MOVE STICKER
@objc func moveSticker(_ sender: UIPanGestureRecognizer) {
    let translation: CGPoint =  sender.translation(in: self.view)
    sender.view?.center = CGPoint(x: sender.view!.center.x +  translation.x, y: sender.view!.center.y + translation.y)
    sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
}
// DELETE STICKER (with a double-tap on a sticker
@objc func deleteSticker(_ sender: UITapGestureRecognizer) {
    sender.view?.removeFromSuperview()
        
    stickersTAGArray.removeLast()
    //println("stkrTAGArray2:\(stickersTAGArray)")
}
// ZOOM STICKER
@objc func zoomSticker(_ sender: UIPinchGestureRecognizer) {
    sender.view?.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
    sender.scale = 1
}
// ROTATE STICKER
@objc func rotateSticker(_ sender:UIRotationGestureRecognizer){
    if sender.state == UIGestureRecognizerState.began ||
        sender.state == UIGestureRecognizerState.changed
    {
        sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
}
    
    
    
@IBAction func dismissStickersButt(_ sender: AnyObject) {
    hideStickersView()
}
    
// Show/Hide Stickers View ======
func showStickersView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.stickersView.frame.origin.y = self.buttonsView.frame.origin.y
        }, completion: { (finished: Bool) in
    })
}
func hideStickersView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.stickersView.frame.origin.y = self.view.frame.size.height
        }, completion: { (finished: Bool) in
    })
}

    
    
    
    
    
    

// MARK: - TEXTURES TOOL ----------------------------
    
    /* Variables */
    var textureTAG = 0
    
    /* Views */
    @IBOutlet weak var texturesView: UIView!
    @IBOutlet weak var texturesScrollView: UIScrollView!
    var textureButt = UIButton()
    @IBOutlet weak var textureAlphaSlider: UISlider!
    
    
func setupTexturesTool() {
    // Variables for setting the Buttons
    var xCoord: CGFloat = 10
    let yCoord: CGFloat = 0
    let buttonWidth:CGFloat = 70
    let buttonHeight: CGFloat = 70
    let gapBetweenButtons: CGFloat = 10

        
    // Loop for creating buttons
    for itemCount in 0..<9+1 {
        textureTAG = itemCount
            
        // Create a Button for each Texture ==========
        textureButt = UIButton(type: UIButtonType.custom)
        textureButt.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
        textureButt.tag = textureTAG
        textureButt.showsTouchWhenHighlighted = true
        textureButt.setImage(UIImage(named: "t\(textureTAG)"), for: UIControlState())
        textureButt.setTitleColor(UIColor.white, for: UIControlState())
        textureButt.addTarget(self, action: #selector(textureButtTapped(_:)), for: UIControlEvents.touchUpInside)
        textureButt.layer.borderWidth = 1
        textureButt.layer.borderColor = UIColor.darkGray.cgColor
        textureButt.clipsToBounds = true
        
        // Add Buttons & Labels based on xCood
        xCoord +=  buttonWidth + gapBetweenButtons
        texturesScrollView.addSubview(textureButt)
  
        // Place Buttons into the ScrollView
        texturesScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(textureTAG+2) + (gapBetweenButtons * CGFloat(textureTAG)),  height: yCoord)
        
        print("\(textureTAG)")
        
    } // END LOOP
        
}
    
    var textureImg: UIImageView?
    
@objc func textureButtTapped(_ sender: AnyObject) {
    let butt = sender as! UIButton
    
        if (textureImg != nil) {
            textureImg?.removeFromSuperview()
        }
        
        textureImg = UIImageView(frame: CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height))
        textureImg?.center = CGPoint(x: containerView.frame.size.width/2, y: containerView.frame.size.height/2)
        textureImg?.backgroundColor = UIColor.clear
        textureImg?.image = UIImage(named: "t\(butt.tag)")
        // println("textureTAG= \(butt.tag)")
        textureImg?.isUserInteractionEnabled = true
        textureImg?.isMultipleTouchEnabled = true
        textureImg?.alpha = CGFloat(textureAlphaSlider.value)
        containerView.addSubview(textureImg!)
        
        if butt.tag == 0 {
            textureImg?.removeFromSuperview()
        }
        
        
        // Bring Borders, Text and Stickers to FRONT ============
        if borderImg != nil {
            containerView.bringSubview(toFront: borderImg!)
        }
        if txtView != nil {
            containerView.bringSubview(toFront: txtView)
        }
        if stickerImg != nil {
            for stkrCount in 0..<stickersTAGArray.count {
                let viewTAG = stickersTAGArray[stkrCount]
                containerView.bringSubview(toFront: self.view.viewWithTag(viewTAG)! )
            }
        }
        // Bring PhotoLab watermark to FRONT
        containerView.bringSubview(toFront: watermarkLabel)
    }
    
    // Texture opacity Slider
    @IBAction func textureAlphaChanged(_ sender: UISlider) {
        textureImg?.alpha = CGFloat(sender.value)
    }
    
    // Rotate Texture Button
    @IBAction func rotateTextureButt(_ sender: AnyObject) {
        if textureImg == nil {
            return
        }
        
        textureImg?.transform = textureImg!.transform.rotated(by: CGFloat (M_PI_2))
    }
    
    // Dismiss texturesView Button
    @IBAction func dismissTexturesView(_ sender: AnyObject) {
        hideTexturesView()
    }
    
   
// Show/Hide Textures View =====================
func showTexturesView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.texturesView.frame.origin.y = self.buttonsView.frame.origin.y
        }, completion: { (finished: Bool) in
    })
}
func hideTexturesView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.texturesView.frame.origin.y = self.view.frame.size.height
        }, completion: { (finished: Bool) in
    })
}

    
    
    
    
    
    
    
    
// MARK: - BODERS TOOL ------------------
    /* Variables */
    var borderTAG = 0
    
    /* Views */
    @IBOutlet weak var bordersView: UIView!
    @IBOutlet weak var bordersScrollView: UIScrollView!
    var borderButt = UIButton()
    @IBOutlet weak var borderAlphaSlider: UISlider!
    
    @IBOutlet weak var borderColorsScrollView: UIScrollView!
    var colorBorderButt: UIButton?

    var borderImg: UIImageView?

    
func setupBordersTool() {
        // Variables for setting the Buttons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 0
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 10
    
        // Loop for creating buttons =========================
        for itemCountB in 0..<9+1 {
            borderTAG = itemCountB
            
            // Create a Button for each Texture ==========
            borderButt = UIButton(type: UIButtonType.custom)
            borderButt.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            borderButt.tag = borderTAG
            borderButt.showsTouchWhenHighlighted = true
            borderButt.setImage(UIImage(named: "b\(borderTAG)"), for: UIControlState())
            borderButt.setTitleColor(UIColor.white, for: UIControlState())
            borderButt.addTarget(self, action: #selector(borderButtTapped(_:)), for: UIControlEvents.touchUpInside)
            borderButt.layer.borderWidth = 1
            borderButt.layer.borderColor = UIColor.darkGray.cgColor
           // borderButt?.layer.cornerRadius = 8
            borderButt.clipsToBounds = true
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            bordersScrollView.addSubview(borderButt)
        
            
            // Place Buttons into the ScrollView
            bordersScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCountB+2) + buttonWidth, height: yCoord)
            
    } // END LOOP =========================================
        
    
        // Setup the colors menu for Borders
        setupBorderColorsMenu()
}
    
    
@objc func borderButtTapped(_ sender: AnyObject) {
    let butt = sender as! UIButton

    if (borderImg != nil) {  borderImg?.removeFromSuperview() }
        
        borderImg = UIImageView(frame: CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height))
        borderImg?.backgroundColor = UIColor.clear
        borderImg?.image = UIImage(named: "b\(butt.tag)")
        borderImg?.isUserInteractionEnabled = true
        borderImg?.isMultipleTouchEnabled = true
        borderImg?.alpha = CGFloat(borderAlphaSlider.value)
        containerView.addSubview(borderImg!)
        
        
        // Remove Border when empty button is selected
        if butt.tag == 0 {
            borderImg?.removeFromSuperview()
        }
        
        // Add PINCH GESTURES to the selected Border
        let pinchGestBorder = UIPinchGestureRecognizer()
        pinchGestBorder.addTarget(self, action: #selector(zoomBorder(_:)))
        borderImg!.addGestureRecognizer(pinchGestBorder)
        
        
        // Bring Text and Stickers to FRONT
        if txtView != nil {
            containerView.bringSubview(toFront: txtView)
        }
        if stickerImg != nil {
            for stkrCount in 0..<stickersTAGArray.count {
                let viewTAG = stickersTAGArray[stkrCount]
                containerView.bringSubview(toFront: self.view.viewWithTag(viewTAG)! )
            }
        }
        // Bring PhotoLab watermark to FRONT
        containerView.bringSubview(toFront: watermarkLabel)
}

    
// ZOOM BORDER
@objc func zoomBorder(_ sender: UIPinchGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended ||
            sender.state == UIGestureRecognizerState.changed {
                let currentScale: CGFloat = CGFloat(borderImg!.frame.size.width / borderImg!.bounds.size.width)
                var newScale: CGFloat = CGFloat(currentScale * sender.scale)
                
                //Constrain zoom to specific scale ratios
                if newScale < 1.0 {
                    newScale = 1.0
                }
                if newScale > 1.4 {
                    newScale = 1.4
                }
                let transform: CGAffineTransform = CGAffineTransform(scaleX: newScale, y: newScale)
                // CGAffineTransform(scaleX: newScale, y: newScale);
                borderImg!.transform = transform
                sender.scale = 1
        }
}
    
  
// Setup Colors for Borders Tool
func setupBorderColorsMenu() {
    // Variables for setting the Color Buttons
    var xCoord: CGFloat = 0
    let yCoord: CGFloat = 3
    let buttonWidth:CGFloat = 34
    let buttonHeight: CGFloat = 34
    let gapBetweenButtons: CGFloat = 0
    
    borderColorsScrollView.frame.size.width = view.frame.size.width - 170

    // Loop for creating buttons ========
    for colorsCount in 0..<colorList.count {
        colorTag = colorsCount
            
        // Create a Button for each Color ==========
        colorBorderButt = UIButton(type: UIButtonType.custom)
        colorBorderButt?.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
        colorBorderButt?.tag = colorTag  // Assign a tag to each button
        colorBorderButt?.backgroundColor = colorList[colorsCount]
        colorBorderButt?.showsTouchWhenHighlighted = false
        colorBorderButt?.addTarget(self, action: #selector(colorBorderButtTapped(_:)), for: UIControlEvents.touchUpInside)
            
        xCoord +=  buttonWidth + gapBetweenButtons
        borderColorsScrollView.addSubview(colorBorderButt!)
    
    
        // Place Buttons into the ScrollView
        borderColorsScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(colorsCount) + buttonWidth, height: yCoord)
    
    } // END LOOP
    
}
    
@objc func colorBorderButtTapped(_ sender: AnyObject) {
    borderImg?.image = borderImg?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    borderImg?.tintColor = sender.backgroundColor
}
    
    
    
// Border opacity slider
@IBAction func borderAlphaChanged(_ sender: UISlider) {
    borderImg?.alpha = CGFloat(sender.value)
}
    
@IBAction func dismissBordersView(_ sender: AnyObject) {
    hideBordersView()
}
    
    
// Show/Hide Borders View
func showBordersView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.bordersView.frame.origin.y = self.buttonsView.frame.origin.y
        }, completion: { (finished: Bool) in
    })
}
func hideBordersView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.bordersView.frame.origin.y = self.view.frame.size.height
        }, completion: { (finished: Bool) in
    })
}
    
    
    
    
    
    
    
    
// MARK: - FILTERS TOOL ------------------------------------------

    
    /* Variables */
    var filterTAG = 0
    
    /* Views */
    @IBOutlet weak var imageForFilters: UIImageView!
    
    @IBOutlet weak var filtersView: UIView!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    var filterButt: UIButton?
    
    
    // Filters List & Names ------------------------
    let filtersList = [
        "None",                    //0
        "CIVignette",              //1
        "CIPhotoEffectInstant",    //2
        "CIPhotoEffectProcess",    //3
        "CIPhotoEffectTransfer",   //4
        "CISepiaTone",             //5
        "CIPhotoEffectChrome",     //6
        "CIPhotoEffectFade",       //7
        "CIPhotoEffectTonal",      //8
        "CIPhotoEffectNoir",       //9
        "CIMaximumComponent",      //10
        "CIMinimumComponent",      //11
        "CIDotScreen",             //12
        "CIColorMonochrome",       //13
        "CIColorMonochrome",       //14
        "CIColorMonochrome",       //15
        "CIColorPosterize",        //16
        "CISharpenLuminance",      //17
        "CIGammaAdjust",           //18
        "CIHueAdjust",             //19
        "CIHueAdjust",             //20
        "CIHueAdjust",             //21
        "CISepiaTone",             //22
        
        // Add here new CIFilters...
    ]
    
    let filterNamesList = [
        "None",        //0
        "Vignette",    //1
        "Imagine",     //2
        "Retro",       //3
        "Chic",        //4
        "Sepia",       //5
        "Light",       //6
        "Aqua",        //7
        "Tonal",       //8
        "Noir",        //9
        "Darken",      //10
        "Rude",        //11
        "Dotted",      //12
        "Orange",      //13
        "Reddy",       //14
        "Canary",      //15
        "Poster",      //16
        "Sharp",       //17
        "Boris",       //18
        "Marylin",     //19
        "Fantik",      //20
        "Ipse",        //21
        "Vintiq",      //22
        
        //Set new Filter Names here...
        
    ]
    //-------------------------------------------
    
    
    
    
func setupFiltersTool() {
        // Variables for setting the Buttons
        var xCoord: CGFloat = 10
        let yCoord: CGFloat = 10
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 10
        

        // Loop for creating buttons =========================
        for itemCount in 0..<filtersList.count {
            filterTAG = itemCount
            
            // Create a Button for each Texture ==========
            filterButt = UIButton(type: UIButtonType.custom)
            filterButt?.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButt?.tag = filterTAG
            filterButt?.showsTouchWhenHighlighted = true
            filterButt?.setImage(UIImage(named: "f\(filterTAG)"), for: UIControlState())
            filterButt?.setTitleColor(UIColor.white, for: UIControlState())
            filterButt?.addTarget(self, action: #selector(filterButtTapped(_:)), for: UIControlEvents.touchUpInside)
            filterButt?.layer.borderWidth = 1
            filterButt?.layer.borderColor = UIColor.darkGray.cgColor
           // filterButt?.layer.cornerRadius = 8
            filterButt?.clipsToBounds = true
            
            // Add a Label that shows Filter Name =========
            let filterLabel: UILabel = UILabel()
            filterLabel.frame = CGRect(x: 0, y: filterButt!.frame.size.height-15, width: buttonWidth, height: 15)
            filterLabel.backgroundColor = UIColor.black
            filterLabel.alpha = 0.8
            filterLabel.textColor = UIColor.white
            filterLabel.textAlignment = NSTextAlignment.center
            filterLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 10)
            filterLabel.text = "\(filterNamesList[itemCount])"
            filterButt?.addSubview(filterLabel)
            
            
            // Add Buttons & Labels based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButt!)

            
            // Place Buttons into the ScrollView
            filtersScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount+4) + buttonWidth, height: yCoord)
            
    } // END LOOP =========================================
        
}
    
@objc func filterButtTapped(_ button: UIButton) {
        
        // Remove adjImage (if any)
        adjImage?.image = nil
        
        // Reset the Adjustment Tools
        brightnessSlider.value = 0
        contrastSlider.value = 1
        saturationSlider.value = 1
        exposureSlider.value = 0.5
        
        
        // Set the filteredImage as the Original image
        imageForFilters.image = originalImage.image
        
        if button.tag == 0 {
            // NO Filter (go back to Original image)
            imageForFilters.image = originalImage.image
        } else {
            
            
            
    
// MARK: - FILTER SETTINGS ------------------------------------
            
            let CIfilterName = "\(filtersList[button.tag])"
            print("\(CIfilterName)")
            
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: imageForFilters.image!)
            let filter = CIFilter(name: CIfilterName)
            filter!.setDefaults()
            
            
        switch button.tag {
                
            case 1: // Vignette
                filter!.setValue(3.0, forKey: kCIInputRadiusKey)
                filter!.setValue(4.0, forKey: kCIInputIntensityKey)
                break
                
            case 13: // Orangy
                let color:UIColor = UIColor(red: 247/255.0, green: 174/255.0, blue: 71/255.0, alpha: 1.0)
                filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
                filter!.setValue(0.8, forKey: kCIInputIntensityKey)
                break
                
            case 14: // Red X
                let color:UIColor = UIColor(red: 201/255.0, green: 91/255.0, blue: 96/255.0, alpha: 1.0)
                filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
                filter!.setValue(0.8, forKey: kCIInputIntensityKey)
                break
                
            case 15: // Canary
                let color:UIColor = UIColor(red: 241/255.0, green: 247/255.0, blue: 71/255.0, alpha: 1.0)
                filter!.setValue(CIColor(color: color), forKey: kCIInputColorKey)
                filter!.setValue(0.8, forKey: kCIInputIntensityKey)
                break
                
            case 16: //Poster
                filter!.setValue(6.0, forKey: "inputLevels")
                break
                
            case 17: // Sharp
                filter!.setValue(0.9, forKey: kCIInputSharpnessKey)
                break
                
            case 18: //Dark
                filter!.setValue(3, forKey: "inputPower")
                break
                
            case 19: //Tint 1
                filter!.setValue(3.10, forKey: kCIInputAngleKey)
                break
                
            case 20: //Tint 2
                filter!.setValue(2.00, forKey: kCIInputAngleKey)
                break
                
            case 21: //Tint 3
                filter!.setValue(1.00, forKey: kCIInputAngleKey)
                break
                
            case 22: //Vintage
                filter!.setValue(0.5, forKey:"inputIntensity")
                break
                
            
                /* You can add new filters settings here,
                Check Core Image Filter Reference here: https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
                */
                
                
        default: break }
            
            
            // Log the Filters attributes in the XCode console
            // println("\(filter.attributes())")
            
            // Finalize the filtered image ==========
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            
            imageForFilters.image = UIImage(cgImage: filteredImageRef!);
        } // END FILTER SETTINGS
}
    

// DISMISS FILTERS VIEW
@IBAction func dismissFiltersViewButt(_ sender: AnyObject) {
    hideFiltersView()
}

// Show/Hide Filters View ==========
func showFiltersView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.filtersView.frame.origin.y = self.buttonsView.frame.origin.y
        }, completion: { (finished: Bool) in
    })
}
func hideFiltersView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.filtersView.frame.origin.y = self.view.frame.size.height
        }, completion: { (finished: Bool) in
    })
}

    
    
    
    
    
    
    

// MARK: - ADJUSTMENT TOOL ---------------------
    
    /* Variables */
    let lightBlack = UIColor(red: 47.0/255.0, green: 55.0/255.0, blue: 65.0/255.0, alpha: 1.0)
    
    /* Views */
    @IBOutlet weak var adjustmentView: UIView!
    @IBOutlet weak var adjustmentLabel: UILabel!
    
    /* Adjustment Buttons */
    @IBOutlet weak var brightnessOutlet: UIButton!
    @IBOutlet weak var contrastOutlet: UIButton!
    @IBOutlet weak var saturationOutlet: UIButton!
    @IBOutlet weak var exposureOutlet: UIButton!
    
    /* Adjustment Sliders */
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    @IBOutlet weak var saturationSlider: UISlider!
    @IBOutlet weak var exposureSlider: UISlider!
    
    /* Adjustment Image */
    var adjImage: UIImageView?
    

    
@IBAction func adjustmentButtons(_ sender: AnyObject) {
    let butt = sender as! UIButton

        switch (butt.tag) {
        case 0: // Brightness
            adjustmentLabel.text = "Brightness"
            
            brightnessOutlet.backgroundColor = UIColor.black
            contrastOutlet.backgroundColor = lightBlack
            saturationOutlet.backgroundColor = lightBlack
            exposureOutlet.backgroundColor = lightBlack
            
            brightnessSlider.isHidden = false
            contrastSlider.isHidden = true
            saturationSlider.isHidden = true
            exposureSlider.isHidden = true
            break
        case 1: // Contrast
            adjustmentLabel.text = "Contrast"
            
            brightnessOutlet.backgroundColor = lightBlack
            contrastOutlet.backgroundColor = UIColor.black
            saturationOutlet.backgroundColor = lightBlack
            exposureOutlet.backgroundColor = lightBlack
            
            brightnessSlider.isHidden = true
            contrastSlider.isHidden = false
            saturationSlider.isHidden = true
            exposureSlider.isHidden = true
            break
        case 2: // Saturation
            adjustmentLabel.text = "Saturation"
            
            brightnessOutlet.backgroundColor = lightBlack
            contrastOutlet.backgroundColor = lightBlack
            saturationOutlet.backgroundColor = UIColor.black
            exposureOutlet.backgroundColor = lightBlack
            
            brightnessSlider.isHidden = true
            contrastSlider.isHidden = true
            saturationSlider.isHidden = false
            exposureSlider.isHidden = true
            break
        case 3: // Exposure
            adjustmentLabel.text = "Exposure"
            
            brightnessOutlet.backgroundColor = lightBlack
            contrastOutlet.backgroundColor = lightBlack
            saturationOutlet.backgroundColor = lightBlack
            exposureOutlet.backgroundColor = UIColor.black
            
            brightnessSlider.isHidden = true
            contrastSlider.isHidden = true
            saturationSlider.isHidden = true
            exposureSlider.isHidden = false
            break
            
        default: break
        }
    }
    
    @IBAction func adjustmentChanged(_ sender: UISlider) {
        print("brightn: \(brightnessSlider.value)")
        print("contrast: \(contrastSlider.value)")
        print("saturat: \(saturationSlider.value)")
        print("exposure: \(exposureSlider.value)")
        
        
        if adjImage != nil {
            adjImage?.removeFromSuperview()
        }
        
        adjImage = UIImageView(frame: CGRect(x: imageForFilters.frame.origin.x, y: imageForFilters.frame.origin.y, width: imageForFilters.frame.size.width, height: imageForFilters.frame.size.height))
        adjImage?.image = imageForFilters.image
        
        
        // Image process =======================
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self.adjImage!.image!)
        let filter = CIFilter(name: "CIColorControls")
        filter!.setDefaults()
        
        filter!.setValue(self.brightnessSlider.value, forKey: "inputBrightness") // -1 to 1
        filter!.setValue(self.contrastSlider.value, forKey: "inputContrast")     // 0 to 2
        filter!.setValue(self.saturationSlider.value, forKey: "inputSaturation") // 0 to 2
        
        let exposureFilter = CIFilter(name: "CIExposureAdjust")
        exposureFilter!.setDefaults()
        exposureFilter!.setValue(exposureSlider.value, forKey:"inputEV")
        
        
        // Log the Filters attributes in the XCode console
        print("\(exposureFilter!.attributes)")
        
        // Finalize the filtered image ==========
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        exposureFilter!.setValue(filter!.outputImage, forKey: kCIInputImageKey)
        
        let filteredImageData = exposureFilter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        self.adjImage?.image = UIImage(cgImage: filteredImageRef!);
        
        self.containerView.addSubview(self.adjImage!)
        
        
        // Bring Textures, Borders, Text and Stickers to FRONT ============
        if textureImg != nil {
            containerView.bringSubview(toFront: textureImg!)
        }
        if borderImg != nil {
            containerView.bringSubview(toFront: borderImg!)
        }
        if txtView != nil {
            containerView.bringSubview(toFront: txtView)
        }
        if stickerImg != nil {
            for stkrCount in 0..<stickersTAGArray.count {
                let viewTAG = stickersTAGArray[stkrCount]
                containerView.bringSubview(toFront: self.view.viewWithTag(viewTAG)! )
            }
        }
        
    // Bring PhotoLab watermark to FRONT
    containerView.bringSubview(toFront: watermarkLabel)
}
    
    
    
// DISMISS ADJUSTMENT VIEW
@IBAction func dismissAdjustmentViewButt(_ sender: AnyObject) {
    hideAdjustmentView()
}
    
// Show/Hide Adjustment View ==========
func showAdjustmentView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.adjustmentView.frame.origin.y = self.buttonsView.frame.origin.y
        }, completion: { (finished: Bool) in
    })
}
func hideAdjustmentView() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.adjustmentView.frame.origin.y = self.view.frame.size.height
        }, completion: { (finished: Bool) in
    })
}
    
 
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


