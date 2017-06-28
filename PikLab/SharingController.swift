/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/

import UIKit
import MessageUI
import Social
import GoogleMobileAds


class SharingController: UIViewController,
MFMessageComposeViewControllerDelegate,
MFMailComposeViewControllerDelegate,
UIDocumentInteractionControllerDelegate,
GADInterstitialDelegate
{
    
    /* Views */
    @IBOutlet weak var imageToBeShared: UIImageView!
    var docIntController = UIDocumentInteractionController()
    
    @IBOutlet var buttons: [UIButton]!
    
    var adMobInterstitial: GADInterstitial!

    


    
// HIDE STATUS BAR
override var prefersStatusBarHidden : Bool {
        return true
}
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    // Call AdMob Interstitial
    let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    adMobInterstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
    adMobInterstitial.load(GADRequest())
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
        self.showInterstitial()
    }
    
    
    // Get image from previous Controller
    imageToBeShared.image = editedImage
    
    // Round views corners
    for butt in buttons {
        butt.layer.cornerRadius = 6
        butt.layer.shadowColor = UIColor.darkGray.cgColor
        butt.layer.shadowOffset = CGSize(width: 0, height: 1)
        butt.layer.shadowOpacity = 0.2
        butt.layer.shadowRadius = 0.1
    }
    
}
 
    
// MARK: - ADMOB INTERSTITIAL
func showInterstitial() {
        if adMobInterstitial.isReady {
            adMobInterstitial.present(fromRootViewController: self)
            print("AdMob Interstitial!")
        }
}
    
    
    
// MARK: - DISMISS BUTTON
@IBAction func dismissButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}
    
    

// MARK: - SAVE TO PHOTO LIBRARY BUTTON
@IBAction func saveToLibraryButt(_ sender: AnyObject) {
    UIImageWriteToSavedPhotosAlbum(imageToBeShared.image!, nil,nil, nil)
        
    let alert = UIAlertView(title: "Image saved to Photo library",
        message: nil,
        delegate: nil,
        cancelButtonTitle: "OK" )
        alert.show()
}
    

    
// MARK: - TWITTER BUTTON
@IBAction func twitterButt(_ sender: AnyObject) {
    if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let twSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twSheet?.setInitialText(messageText)
            twSheet?.add(imageToBeShared.image)
            present(twSheet!, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Twitter",
            message: "Please login to your Twitter account in Settings",
            delegate: nil,
            cancelButtonTitle: "OK")
            alert.show()
        }
}
    
    
    
    
// MARK: - FACEBOOK BUTTON
    @IBAction func facebookButt(_ sender: AnyObject) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbSheet?.setInitialText(messageText)
            fbSheet?.add(imageToBeShared.image)
            self.present(fbSheet!, animated: true, completion: nil)
        } else {
            let alert: UIAlertView = UIAlertView(title: "Facebook",
                message: "Please login to your Facebook account in Settings",
                delegate: nil,
                cancelButtonTitle: "OK")
            alert.show()
        }
}
    
    
// MARK: - MAIL BUTTON
    @IBAction func mailButt(_ sender: AnyObject) {
        let mailComposer: MFMailComposeViewController = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(subjectText)
        mailComposer.setMessageBody(messageText, isHTML: true)
        // Prepares the image to be shared by Email
        let imageData = UIImageJPEGRepresentation(imageToBeShared.image!, 1.0)
        mailComposer.addAttachmentData(imageData!, mimeType: "image/png", fileName: "MyPhoto.png")
        
        present(mailComposer, animated: true, completion: nil)
    }
// Email delegate
func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
    var outputMessage = ""
    
    switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            outputMessage = "Mail cancelled"
        case MFMailComposeResult.saved.rawValue:
            outputMessage = "Mail saved"
        case MFMailComposeResult.sent.rawValue:
            outputMessage = "Mail sent"
        case MFMailComposeResult.failed.rawValue:
            outputMessage = "Mail sent failure: \(error!.localizedDescription)"
    default:break  }
    
    let alert = UIAlertView(title: APP_NAME,
        message: outputMessage,
        delegate: nil,
        cancelButtonTitle: "OK" )
    alert.show()
    
    dismiss(animated: false, completion: nil)
}
    
    
    
    
// MARK: - MESSAGE SHARING
@IBAction func messageButt(_ sender: AnyObject) {
    // NOTE: The following methods work only on real device, not iOS Simulator!

    let messageComposer: MFMessageComposeViewController = MFMessageComposeViewController()
    messageComposer.messageComposeDelegate = self
    messageComposer.subject = subjectText
        
    // Check if the device can send MMS messages
    if MFMessageComposeViewController.responds(to: #selector(MFMessageComposeViewController.canSendAttachments)) &&
        MFMessageComposeViewController.canSendAttachments() {
            let attachmentData: Data = UIImageJPEGRepresentation(imageToBeShared.image!, 1.0)!
            messageComposer.addAttachmentData(attachmentData, typeIdentifier: "kUTTypeMessage", filename: "myPhoto.jpg")
    } else {
        let alert = UIAlertView(title: APP_NAME,
        message: "Sorry, your device doesn't support Messages",
        delegate: nil,
        cancelButtonTitle: "OK" )
        alert.show()
    }
        
    present(messageComposer, animated: true, completion: nil)
}
// SMS Delegate
func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    dismiss(animated: true, completion: nil)
}
    
    
    
    
    
    
// MARK: - OTHER APPS SHARING
@IBAction func otherAppsButt(_ sender: AnyObject) {
    // NOTE: The following method works only on a Real device, not on iOS Simulator, + You should have apps like Instagram, iPhoto, etc. already installed into your device!
    
    //Save the Image to default device Directory
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let savedImagePath:String = paths + "/image.jpg"
    let imageData: Data = UIImageJPEGRepresentation(imageToBeShared.image!, 1.0)!
    try? imageData.write(to: URL(fileURLWithPath: savedImagePath), options: [])
    
    //Load the Image Path
    let getImagePath = paths + "/image.jpg"
    let fileURL: URL = URL(fileURLWithPath: getImagePath)
    
    // Open the Document Interaction controller for Sharing options
    docIntController.delegate = self
    docIntController = UIDocumentInteractionController(url: fileURL)
    docIntController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
    
}
    
    
    
   
// MARK: - INSTAGRAM SHARING
@IBAction func instagramButt(_ sender: AnyObject) {
    // NOTE: The following method works only on a Real device, not on iOS Simulator
    
    let instagramURL = URL(string: "instagram://app")!
    if UIApplication.shared.canOpenURL(instagramURL) {
        
    //Save the Image to default device Directory
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let savedImagePath:String = paths + "/image.igo"
    let imageData: Data = UIImageJPEGRepresentation(imageToBeShared.image!, 1.0)!
    try? imageData.write(to: URL(fileURLWithPath: savedImagePath), options: [])
    
    //Load the Image Path
    let getImagePath = paths + "/image.igo"
    let fileURL: URL = URL(fileURLWithPath: getImagePath)
    
    // Open the Document Interaction controller for Sharing options
    docIntController.delegate = self
    docIntController.uti = "com.instagram.exclusivegram"
    docIntController = UIDocumentInteractionController(url: fileURL)
    docIntController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
    
    } else {
        let alert = UIAlertView(title: APP_NAME,
        message: "Instagram not found. Please install it on your device",
        delegate: nil,
        cancelButtonTitle: "OK")
        alert.show()
    }
}
    

    
    
// MARK: - INSTAGRAM SHARING
@IBAction func whatsAppButt(_ sender: AnyObject) {
    // NOTE: The following method works only on a Real device, not on iOS Simulator
    
    let instagramURL = URL(string: "whatsapp://app")!
    if UIApplication.shared.canOpenURL(instagramURL) {
        
        //Save the Image to default device Directory
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let savedImagePath:String = paths + "/image.wai"
        let imageData: Data = UIImageJPEGRepresentation(imageToBeShared.image!, 1.0)!
        try? imageData.write(to: URL(fileURLWithPath: savedImagePath), options: [])
        
        //Load the Image Path
        let getImagePath = paths + "/image.wai"
        let fileURL: URL = URL(fileURLWithPath: getImagePath)
        
        // Open the Document Interaction controller for Sharing options
        docIntController.delegate = self
        docIntController.uti = "net.whatsapp.image"
        docIntController = UIDocumentInteractionController(url: fileURL)
        docIntController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
        
    } else {
        let alert = UIAlertView(title: APP_NAME,
            message: "WhatsApp not found. Please install it on your device",
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
}
    

    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



