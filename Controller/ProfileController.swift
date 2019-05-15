import UIKit
import Firebase
import FirebaseStorage
import FBSDKLoginKit
import FBSDKCoreKit

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("logged out")
    }
    
    
    
    let storage = Storage.storage().reference()
    let databaseRef = Database.database().reference()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
      
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 10, y: 477, width: 355, height: 30)
        
        loginButton.delegate = self
     
        setupProfile()
        self.emailLabel.text = Auth.auth().currentUser?.email

    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
           let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as? LoginView
        self.present(loginView!, animated: true, completion: nil)
        print("Did LogOut")
    }
    
    @IBAction func signedOutBtnWasPressed(_ sender: Any){
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do {
              try Auth.auth().signOut()
              let loginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as? LoginView
                self.present(loginView!, animated: true, completion: nil)
                
            } catch{
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    
    
    
    func setupProfile(){
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        let uid = Auth.auth().currentUser?.uid
        databaseRef.child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
//                self.emailLabel.text = dict["users"] as? String
                if let imageViewURL = dict["pic"] as? String{
                    let url = URL(string: imageViewURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            self.imageView?.image = UIImage(data: data!)
                        }
                    }).resume()
                }
            }
        }
    }
    
    
    
    @IBAction func saveChanges(_ sender: Any ) {
        self.saveChanges()
    }
    
    
    @IBAction func uploadImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
        selectedImageFromPicker = editedImage
        } else if let originalImage = info ["UIImagePickerControllerOrginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func saveChanges() {
        
        let imageName = NSUUID().uuidString
        let storedImage = storage.child("imageView").child(imageName)
        if let uploadData = UIImagePNGRepresentation(self.imageView.image!) {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString {
                        self.databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["pic" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil {
                                print("Image Stored")
                                print(error!)
                                return
                            }
                        })
                    }
                })
            })
        }
    }
    
}








