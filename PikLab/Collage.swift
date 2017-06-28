/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/


import UIKit



class Collage: UIViewController,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UINavigationControllerDelegate
{
    
    
    
// Hide the status bar 
override var prefersStatusBarHidden : Bool {
    return true;
}
    
override func viewDidLoad() {
        super.viewDidLoad()
    
}

    
// DISMISS BUTTON ========================
@IBAction func dismissButt(_ sender: AnyObject) {
    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "MainScreen") as! MainScreen
    homeVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    present(homeVC, animated: true, completion: nil)
}
    
    
    
    
   
// MARK: - COLLECTION VIEW DELEGATES
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}
    
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return totalCollagesQty
}
    
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollageCell", for: indexPath) as! CollageCell
    
    cell.thumbnail.image = UIImage(named: "c\((indexPath as NSIndexPath).row)")
    
    return cell
}
    
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95, height: 95)
}
    
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collageFrameNr = (indexPath as NSIndexPath).row
    
    let ecVC = self.storyboard?.instantiateViewController(withIdentifier: "EditCollage") as! EditCollage
    ecVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    present(ecVC, animated: true, completion: nil)
}
    

    
    
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
}
}
