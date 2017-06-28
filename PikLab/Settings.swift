/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/

import UIKit
import MessageUI


class Settings: UIViewController,
MFMailComposeViewControllerDelegate
{
    /* Views */
    @IBOutlet var otherButtons: [UIButton]!
    
    
    
    
// HIDE STATUS BAR
override var prefersStatusBarHidden : Bool {
        return true
}
    
    
override func viewDidLoad() {
        super.viewDidLoad()
    
    
    // Round views corners
    for butt in otherButtons {
        butt.layer.cornerRadius = 6
        butt.layer.shadowColor = UIColor.darkGray.cgColor
        butt.layer.shadowOffset = CGSize(width: 0, height: 1)
        butt.layer.shadowOpacity = 0.2
        butt.layer.shadowRadius = 0.1
    }
    
}
    
    
    
   
// MARK: - RATE APP BUTTON
@IBAction func rateAppButt(_ sender: AnyObject) {
    let reviewURL = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(APP_ID)")
    UIApplication.shared.openURL(reviewURL!)
}
    
    
    
    
// MARK: - SEND FEEDBACK BUTTON
@IBAction func mailSupportButt(_ sender: AnyObject) {
    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self
    mailComposer.setSubject("Feedback for \(APP_NAME)")
    mailComposer.setToRecipients([FEEDBACK_EMAIL_ADDRESS])
    if MFMailComposeViewController.canSendMail() {
        present(mailComposer, animated: true, completion: nil)
    } else {
        let alert = UIAlertView(title: APP_NAME,
        message: "Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.",
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
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
        default:break
    }
    let alert = UIAlertView(title: APP_NAME,
        message: outputMessage,
        delegate: nil,
        cancelButtonTitle: "OK")
    alert.show()
    
    dismiss(animated: false, completion: nil)
}
    
    
    
// MARK: - OTHER APPS BUTTON
@IBAction func checkAppsButt(_ sender: AnyObject) {
    let myAppStoreLink = URL(string: MY_ARTIST_APPSTORE_LINK)
    UIApplication.shared.openURL(myAppStoreLink!)
}
    

    
    
// MARK: - DISMISS CONTROLLER
@IBAction func dismissViewButt(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
}
    
 
    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

