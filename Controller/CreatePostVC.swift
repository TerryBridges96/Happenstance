
import UIKit
import Firebase
import FirebaseStorage


class CreatePostVC: UIViewController {

    let storage = Storage.storage().reference()
    let database = Database.database().reference()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        textView.delegate = self
        self.emaillbl.text = Auth.auth().currentUser?.email
      
        textView.delegate = self
//        sendBtn.bindToKeyboard()
        
    }




    @IBAction func sendBtnWasPressed (_ sender: Any){
        if textView.text != nil && textView.text != "Share Song Locations..." {
            sendBtn.isEnabled = false
            DataService.shared.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, sendComplete: {(isComplete) in
                if isComplete{
                    self.sendBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.sendBtn.isEnabled = true
                    print("There was an Error!")
                }
            })
        }
    }

    
    @IBAction func cancelBtnWasPressed( sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension CreatePostVC: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
        }
        
}


